// utils/DBHandler.dart

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/AccusedProceedingModel.dart';
import '../models/BailModel.dart';
import '../models/CaseModel.dart';
import '../models/CauseListModel.dart';
import '../models/ProceedingModel.dart';
import '../models/AccusedModel.dart';
import '../models/CitationModel.dart';

class DBHandler {
  DateTime _parseDate(String date) {
    // Split the date string into components
    List<String> parts = date.split('-');
    // Check if parts length is 3 (day, month, year)
    if (parts.length == 3) {
      // Return a DateTime object using the parsed components
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    }
    // If parsing fails, return a default date or throw an error
    throw FormatException('Invalid date format');
  }
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Get the application documents directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Define the path to the database file
    String path = join(directory.path, 'Munshi.db'); // Ensure the .db extension

    // Open the database and handle migrations
    _database = await openDatabase(
      path,
      version: 5, // Incremented version to accommodate new tables
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
      onOpen: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    return _database!;
  }

  // Create the database schema
  Future<void> _createDb(Database db, int version) async {
    // Create the 'cases' table
    await db.execute(
        '''
      CREATE TABLE cases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cpnumber TEXT,
        casetitle TEXT NOT NULL,
        courtname TEXT NOT NULL,
        casefor TEXT NOT NULL,
        provisions TEXT NOT NULL,
        selectedcasetype TEXT,
        nature TEXT
      )
      '''
    );

    // Create the 'proceeding' table
    await db.execute(
        '''
      CREATE TABLE proceeding (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        caseId INTEGER NOT NULL,
        data TEXT NOT NULL,
        proceeding TEXT NOT NULL,
        FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
      )
      '''
    );

    // Create the 'bail_proceeding' table
    await db.execute(
        '''
      CREATE TABLE bail_proceeding (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        caseId INTEGER NOT NULL,
        data TEXT NOT NULL,
        proceeding TEXT NOT NULL,
        FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
      )
      '''
    );

    // Create the 'accused' table
    await db.execute(
        '''
      CREATE TABLE accused (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        caseId INTEGER NOT NULL,
        profile TEXT NOT NULL,
        FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
      )
      '''
    );

    // Create the 'citation' table
    await db.execute(
        '''
      CREATE TABLE citation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        caseId INTEGER NOT NULL,
        citation TEXT NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
      )
      '''
    );

    await db.execute(
        '''
    CREATE TABLE accused_proceeding (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      accusedId INTEGER NOT NULL,
      date TEXT NOT NULL,
      proceeding TEXT NOT NULL,
      FOREIGN KEY (accusedId) REFERENCES accused(id) ON DELETE CASCADE
    )
    '''
    );

    await db.execute(
        '''
    CREATE TABLE causelist (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      number INTEGER NOT NULL
    )
    '''
    );

    // Optionally, create indexes for performance
    await db.execute('CREATE INDEX idx_proceeding_caseId ON proceeding(caseId)');
    await db.execute('CREATE INDEX idx_bail_proceeding_caseId ON bail_proceeding(caseId)');
    await db.execute('CREATE INDEX idx_accused_caseId ON accused(caseId)');
    await db.execute('CREATE INDEX idx_accused_proceeding_accusedId ON accused_proceeding(accusedId)');
    await db.execute('CREATE INDEX idx_citation_caseId ON citation(caseId)');
  }

  // Handle database upgrades
  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute(
          '''
        ALTER TABLE cases ADD COLUMN provisions TEXT NOT NULL DEFAULT ''
        '''
      );
      await db.execute(
          '''
        ALTER TABLE cases ADD COLUMN selectedcasetype TEXT
        '''
      );
      await db.execute(
          '''
        ALTER TABLE cases ADD COLUMN nature TEXT
        '''
      );
      await db.execute(
          '''
      ALTER TABLE cases ADD COLUMN cpnumber TEXT
      '''
      );
    }

    if (oldVersion < 6) {
      // Create the 'proceeding' table
      await db.execute(
          '''
        CREATE TABLE proceeding (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          caseId INTEGER NOT NULL,
          data TEXT NOT NULL,
          proceeding TEXT NOT NULL,
          FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
        )
        '''
      );

      await db.execute(
          '''
      CREATE TABLE causelist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number INTEGER NOT NULL
      )
      '''
      );

      // Create the 'bail_proceeding' table
      await db.execute(
          '''
        CREATE TABLE bail_proceeding (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          caseId INTEGER NOT NULL,
          data TEXT NOT NULL,
          proceeding TEXT NOT NULL,
          FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
        )
        '''
      );

      // Create the 'accused' table
      await db.execute(
          '''
        CREATE TABLE accused (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          caseId INTEGER NOT NULL,
          profile TEXT NOT NULL,
          FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
        )
        '''
      );

      // Create the 'citation' table
      await db.execute(
          '''
        CREATE TABLE citation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          caseId INTEGER NOT NULL,
          citation TEXT NOT NULL,
          description TEXT NOT NULL,
          FOREIGN KEY (caseId) REFERENCES cases(id) ON DELETE CASCADE
        )
        '''
      );

      await db.execute(
          '''
      CREATE TABLE accused_proceeding (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        accusedId INTEGER NOT NULL,
        date TEXT NOT NULL,
        proceeding TEXT NOT NULL,
        FOREIGN KEY (accusedId) REFERENCES accused(id) ON DELETE CASCADE
      )
      '''
      );

      // Create indexes for performance
      await db.execute('CREATE INDEX idx_proceeding_caseId ON proceeding(caseId)');
      await db.execute('CREATE INDEX idx_bail_proceeding_caseId ON bail_proceeding(caseId)');
      await db.execute('CREATE INDEX idx_accused_caseId ON accused(caseId)');
      await db.execute('CREATE INDEX idx_citation_caseId ON citation(caseId)');
      await db.execute('CREATE INDEX idx_accused_proceeding_accusedId ON accused_proceeding(accusedId)');
    }

    // Handle future upgrades here
  }

  // Existing CRUD methods for 'cases' table

  // Insert data into the 'cases' table
  Future<int> insertCase(ModelClass caseModel) async {
    final db = await database;
    return await db.insert(
      'cases',
      caseModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ModelClass?> fetchCaseById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cases',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ModelClass.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Fetch all cases from the 'cases' table
  Future<List<ModelClass>> fetchCases() async {
    final db = await database;
    final list = await db.query('cases');
    return list.map((map) => ModelClass.fromMap(map)).toList();
  }

  // Delete a case by id
  Future<void> deleteCase(int id) async {
    final db = await database;
    await db.delete(
      'cases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a case
  Future<void> updateCase(ModelClass modelclass) async {
    final db = await database;
    await db.update(
      'cases',
      modelclass.toMap(),
      where: 'id = ?',
      whereArgs: [modelclass.id],
    );
  }

  // Close the database (optional)
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // --- New CRUD Methods for the Four New Tables ---

  // 1. Proceeding Table

  // Insert into 'proceeding'
  Future<int> insertProceeding(ProceedingModel proceeding) async {
    final db = await database;
    return await db.insert(
      'proceeding',
      proceeding.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all proceedings for a case
  Future<List<ProceedingModel>> fetchProceedings(int caseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'proceeding',
      where: 'caseId = ?',
      whereArgs: [caseId],
    );
    return maps.map((map) => ProceedingModel.fromMap(map)).toList();
  }

  // Fetch proceedings by a specific date
  Future<List<ProceedingModel>> fetchProceedingsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'proceeding',
      where: 'data = ?',
      whereArgs: [date],
    );
    return maps.map((map) => ProceedingModel.fromMap(map)).toList();
  }


  // Update a proceeding
  Future<void> updateProceeding(ProceedingModel proceeding) async {
    final db = await database;
    await db.update(
      'proceeding',
      proceeding.toMap(),
      where: 'id = ?',
      whereArgs: [proceeding.id],
    );
  }

  // Delete a proceeding by id
  Future<void> deleteProceeding(int id) async {
    final db = await database;
    await db.delete(
      'proceeding',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 2. Bail Proceeding Table

  // Insert into 'bail_proceeding'
  Future<int> insertBailProceeding(BailProceedingModel bailProceeding) async {
    final db = await database;
    return await db.insert(
      'bail_proceeding',
      bailProceeding.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all bail proceedings for a case
  Future<List<BailProceedingModel>> fetchBailProceedings(int caseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bail_proceeding',
      where: 'caseId = ?',
      whereArgs: [caseId],
    );
    return maps.map((map) => BailProceedingModel.fromMap(map)).toList();
  }

  // Update a bail proceeding
  Future<void> updateBailProceeding(BailProceedingModel bailProceeding) async {
    final db = await database;
    await db.update(
      'bail_proceeding',
      bailProceeding.toMap(),
      where: 'id = ?',
      whereArgs: [bailProceeding.id],
    );
  }

  // Delete a bail proceeding by id
  Future<void> deleteBailProceeding(int id) async {
    final db = await database;
    await db.delete(
      'bail_proceeding',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 3. Accused Table

  // Insert into 'accused'
  Future<int> insertAccused(AccusedModel accused) async {
    final db = await database;
    return await db.insert(
      'accused',
      accused.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all accused for a case
  Future<List<AccusedModel>> fetchAccused(int caseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accused',
      where: 'caseId = ?',
      whereArgs: [caseId],
    );
    return maps.map((map) => AccusedModel.fromMap(map)).toList();
  }

  // Update an accused
  Future<void> updateAccused(AccusedModel accused) async {
    final db = await database;
    await db.update(
      'accused',
      accused.toMap(),
      where: 'id = ?',
      whereArgs: [accused.id],
    );
  }

  // Delete an accused by id
  Future<void> deleteAccused(int id) async {
    final db = await database;
    await db.delete(
      'accused',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 4. Citation Table

  // Insert into 'citation'
  Future<int> insertCitation(CitationModel citation) async {
    final db = await database;
    return await db.insert(
      'citation',
      citation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all citations for a case
  Future<List<CitationModel>> fetchCitations(int caseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'citation',
      where: 'caseId = ?',
      whereArgs: [caseId],
    );
    return maps.map((map) => CitationModel.fromMap(map)).toList();
  }

  // Update a citation
  Future<void> updateCitation(CitationModel citation) async {
    final db = await database;
    await db.update(
      'citation',
      citation.toMap(),
      where: 'id = ?',
      whereArgs: [citation.id],
    );
  }

  // Delete a citation by id
  Future<void> deleteCitation(int id) async {
    final db = await database;
    await db.delete(
      'citation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // utils/DBHandler.dart

// --- New CRUD Methods for 'accused_proceeding' Table ---

// 1. Insert into 'accused_proceeding'
  Future<int> insertAccusedProceeding(AccusedProceedingModel proceeding) async {
    final db = await database;
    return await db.insert(
      'accused_proceeding',
      proceeding.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// 2. Fetch all proceedings for an accused
  Future<List<AccusedProceedingModel>> fetchAccusedProceedings(int accusedId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accused_proceeding',
      where: 'accusedId = ?',
      whereArgs: [accusedId],
      orderBy: 'date DESC', // Optional: Order by date
    );
    return maps.map((map) => AccusedProceedingModel.fromMap(map)).toList();
  }

// 3. Update a proceeding
  Future<void> updateAccusedProceeding(AccusedProceedingModel proceeding) async {
    final db = await database;
    await db.update(
      'accused_proceeding',
      proceeding.toMap(),
      where: 'id = ?',
      whereArgs: [proceeding.id],
    );
  }

  Future<List<ModelClass>> searchCases(String query) async {
    final db = await database; // Your method to get the database instance
    final List<Map<String, dynamic>> maps = await db.query(
      'cases',
      where: 'CaseTitle LIKE ? OR CourtName LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    // Convert the List<Map<String, dynamic>> to List<ModelClass>
    return List.generate(maps.length, (index) {
      return ModelClass.fromMap(maps[index]); // Ensure you have a fromMap constructor in ModelClass
    });
  }


// 4. Delete a proceeding by id
  Future<void> deleteAccusedProceeding(int id) async {
    final db = await database;
    await db.delete(
      'accused_proceeding',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<ProceedingModel?> fetchLatestProceeding(int caseId) async {
    List<ProceedingModel> proceedings = await fetchProceedings(caseId);
    if (proceedings.isEmpty) return null;

    // Print proceedings before sorting for debugging
    proceedings.forEach((p) => print('Before sorting: ${p.data}'));

    // Sort to get the latest proceeding at the top
    proceedings.sort((a, b) {
      DateTime dateA = _parseDate(a.data);
      DateTime dateB = _parseDate(b.data);
      return dateB.compareTo(dateA);
    });

    return proceedings.first; // Return the latest proceeding
  }
// Insert into 'causelist'
  Future<int> insertCauselist(Causelist causelist) async {
    final db = await database;
    return await db.insert(
      'causelist',
      causelist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all causelist entries from the database
  Future<List<Causelist>> fetchCauselist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('causelist');

    // Convert the List<Map<String, dynamic>> to List<Causelist>
    return List.generate(maps.length, (index) {
      return Causelist.fromMap(maps[index]);
    });
  }

  // Update a causelist entry in the database by id
  Future<void> updateCauselist(int caseId, int number) async {
    final db = await database;
    await db.update(
      'causelist',
      {'number': number},
      where: 'id = ?', // Assuming 'id' is the primary key column
      whereArgs: [caseId],
    );
  }

  dbpath() async {
    String dbspath = await getDatabasesPath();
    print('===================databasePath $dbspath');
    Directory? expath = await getExternalStorageDirectory();
    print('===================databasePath $expath');
  }




}
