import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:sqflite/sqflite.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'dart:io' as fa;
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openDatabaseInstance();
  runApp(const MyApp());
}

late Database db; // Sqflite database instance

Future<void> openDatabaseInstance() async {
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = p.join(dir.path, 'Munshi.db');
  db = await openDatabase(dbPath, version: 1, onCreate: (db, version) {
    // Define table creation here
    db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT)');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'How to upload sqflite database to Google Drive',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String fileId = ""; // Stores the file ID created on Google Drive
  final serverClientId = "880922774134-009v7hv211udamlh4u6f2mdd6u85b89c.apps.googleusercontent.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: ElevatedButton(
                onPressed: () {
                  uploadToGoogleDrive();
                },
                child: const Text("Upload Sqflite DB to Google Drive")),
          )),
    );
  }

  uploadToGoogleDrive() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: serverClientId, scopes: [ga.DriveApi.driveFileScope]);

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final auth.AuthClient? client =
        await googleSignIn.authenticatedClient();

        final dir = await getApplicationDocumentsDirectory();
        final dbPath = p.join(dir.path, 'Munshi.db');

        fa.File file = fa.File(dbPath);

        if (!file.existsSync()) {
          throw Exception("Database file does not exist.");
        }

        // Prepare file metadata for Google Drive
        ga.File fileToUpload = ga.File();
        DateTime now = DateTime.now();
        fileToUpload.name = "${now.toIso8601String()}_${p.basename(file.path)}";

        final drive = ga.DriveApi(client!);

        ga.File x = await drive.files.create(
          fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
        );

        if (x.id != null) {
          print(x.id!); // Print the ID of the created file on Google Drive
          setState(() {
            fileId = x.id!; // Save the ID to the fileId variable
          });
        }

        // Optionally delete the local backup file after upload
        if (file.existsSync()) {
          file.deleteSync();
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to sign in")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // Download database from Google Drive
  downloadFromGoogleDrive() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: serverClientId,
        scopes: <String>[ga.DriveApi.driveFileScope],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final auth.AuthClient? client =
        await googleSignIn.authenticatedClient();

        final dir = await getApplicationDocumentsDirectory();
        var drive = ga.DriveApi(client!);

        // Fetch file from Google Drive using its ID
        final downloadedFile = await drive.files.get(
          fileId,
          downloadOptions: ga.DownloadOptions.fullMedia,
        ) as ga.Media;

        final List<List<int>> chunks = [];

        await for (List<int> chunk in downloadedFile.stream) {
          chunks.add(chunk);
        }

        final List<int> bytes = chunks.expand((chunk) => chunk).toList();

        // Close the current database before replacing it
        await db.close();

        // Define the path to save the downloaded database
        final dbFile = fa.File('${dir.path}/Munshi.db');
        await dbFile.writeAsBytes(bytes);

        if (await dbFile.exists()) {
          // Reopen the database after replacement
          db = await openDatabase(dbFile.path);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to log in")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
