import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mera_munshi/Components/ads.dart';
import '../models/CauseListModel.dart';
import '../models/ProceedingModel.dart';
import '../models/CaseModel.dart';
import '../utils/DBHandler.dart';

class CauseListPage extends StatefulWidget {
  final DateTime? initialDate; // Add this line
  const CauseListPage({Key? key, this.initialDate}) : super(key: key);

  @override
  _CauseListPageState createState() => _CauseListPageState();
}

class _CauseListPageState extends State<CauseListPage> {
  List<Causelist> causelistItems = []; // Stores all items from the database
  final DBHandler dbHandler = DBHandler();
  DateTime? _selectedDate;
  List<ProceedingModel> _proceedings = [];
  List<ModelClass> _cases = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _fetchProceedingsForDate(widget.initialDate!);
    }
    loadCauselist(); // Load causelist on init
  }

  // Load causelist data from the database
  Future<void> loadCauselist() async {
    causelistItems = await dbHandler.fetchCauselist();
    setState(() {});
  }

  // Function to add or edit a serial number
  Future<void> addOrEditSerialNumber(Causelist item) async {
    final isNumberSet = item.number != 0; // Assuming 0 means not set
    final initialText = isNumberSet ? item.number.toString() : '';

    // Show dialog to insert or edit serial number
    final newNumber = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController Srcontroller =
            TextEditingController(text: initialText);

        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            isNumberSet ? 'Edit Serial Number' : 'Insert Serial Number',
            style: TextStyle(
              fontFamily: 'Eina',
              fontSize: 25,
              color: Colors.grey[700],
            ),
          ),
          content: TextField(
            controller: Srcontroller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
              labelText: 'Enter Serial Number',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
                side: MaterialStateProperty.all(BorderSide(
                  color: Colors.grey[600]!,
                  width: 2,
                  style: BorderStyle.solid,
                )),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String serial = Srcontroller.text.trim();
                if (serial.isNotEmpty) {
                  Navigator.of(context).pop(int.tryParse(Srcontroller.text));
                  Get.snackbar('Success', 'Serial added successfully', snackPosition: SnackPosition.TOP);
                  setState(() {}); // Refresh UI
                } else {
                  Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP);
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        );
      },
    );

    if (newNumber != null) {
      if (isNumberSet) {
        // Edit mode: Update existing serial number
        await dbHandler.updateCauselist(item.id!, newNumber);
      } else {
        await dbHandler
            .insertCauselist(Causelist(id: item.id, number: newNumber));
      }
      loadCauselist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Cause List',
          style: TextStyle(color: Colors.grey[700], fontFamily: 'Eina'),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: _selectedDate == null
                  ? Center(
                      child: Text(
                        'Please select a date to view the Cause List.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Eina',
                        ),
                      ),
                    )
                  : _proceedings.isEmpty
                      ? Center(
                          child: Text(
                            'No Proceedings available on this date.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontFamily: 'Eina',
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey[400]!),
                            columnWidths: const {
                              0: FixedColumnWidth(40), // "No" column
                              1: FlexColumnWidth(4), // "Case" column, wider
                              2: FixedColumnWidth(60), // "SR" column
                            },
                            children: [
                              // Header row
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[350]),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        fontFamily: 'Eina',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Case',
                                        style: TextStyle(
                                          fontFamily: 'Eina',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Sr.No',
                                      style: TextStyle(
                                        fontFamily: 'Eina',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),

                              // Data rows
                              ..._cases.asMap().entries.map((entry) {
                                int index = entry.key;
                                final caseItem = entry.value;
                                final proceeding = _proceedings[index];
                                final causelistItem = causelistItems.firstWhere(
                                  (item) => item.id == proceeding.id,
                                  orElse: () =>
                                      Causelist(id: proceeding.id, number: 0),
                                );

                                return TableRow(
                                  children: [
                                    // No column
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(fontFamily: 'Eina'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    // Case column
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CaseDetailsPage(
                                                    caseItem: caseItem),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              caseItem.casetitle,
                                              style: TextStyle(
                                                fontFamily: 'Eina',
                                                color: Colors.grey[700],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '(${caseItem.courtname})',
                                              style: TextStyle(
                                                fontFamily: 'Eina',
                                                color: Colors.grey[700],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                      ),
                                    ),

                                    // SR column with edit functionality
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => addOrEditSerialNumber(
                                            causelistItem),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1)),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Center(
                                            child: Text('${causelistItem.number}',
                                              style:
                                                  TextStyle(fontFamily: 'Eina'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  // Function to fetch proceedings for the selected date
// Function to fetch proceedings for the selected date
  Future<void> _fetchProceedingsForDate(DateTime date) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    try {
      List<ProceedingModel> proceedings =
      await dbHandler.fetchProceedingsByDate(formattedDate);

      // Create a Set to hold unique case IDs
      Set<int> uniqueCaseIds = {};

      List<ModelClass> cases = [];
      for (var proc in proceedings) {
        // Check if the case ID is already added to the Set
        if (!uniqueCaseIds.contains(proc.caseId)) {
          uniqueCaseIds.add(proc.caseId);

          // Fetch the case details for the unique caseId
          ModelClass? caseItem = await dbHandler.fetchCaseById(proc.caseId);
          if (caseItem != null) {
            cases.add(caseItem);
          }
        }
      }

      setState(() {
        _proceedings = proceedings;
        _cases = cases;
      });
    } catch (e) {
      print('Error fetching proceedings: $e');
      setState(() {
        _proceedings = [];
        _cases = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching proceedings: $e')),
      );
    }
  }
}
