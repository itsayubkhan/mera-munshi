// lib/Components/AccusedDetailsPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../models/AccusedModel.dart';
import '../models/AccusedProceedingModel.dart';
import '../utils/DBHandler.dart';

class AccusedDetailsPage extends StatefulWidget {
  final AccusedModel accused;

  const AccusedDetailsPage({Key? key, required this.accused}) : super(key: key);

  @override
  _AccusedDetailsPageState createState() => _AccusedDetailsPageState();
}

class _AccusedDetailsPageState extends State<AccusedDetailsPage> {
  final DBHandler dbHandler = DBHandler();
  List<AccusedProceedingModel> proceedings = [];

  @override
  void initState() {
    super.initState();
    _fetchProceedings();
  }

  Future<void> _fetchProceedings() async {
    proceedings = await dbHandler.fetchAccusedProceedings(widget.accused.id!);
    setState(() {});
  }

  Future<void> _deleteProceeding(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Delete Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18, color: Colors.grey[600]),
          ),
          content: Text(
            'Are you sure you want to delete this proceeding?',
            style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
                side: MaterialStateProperty.all(BorderSide(
                  color: Colors.grey[600]!,
                  width: 2,
                  style: BorderStyle.solid,
                )),
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Return true when delete is confirmed
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed

    if (confirm) {
      await dbHandler.deleteAccusedProceeding(id); // Ensure you're passing the correct ID
      Get.snackbar('Success', 'Proceeding deleted successfully.', snackPosition: SnackPosition.TOP);
      _fetchProceedings(); // Refresh the list
    }
  }


  Future<void> _showAddProceedingDialog() async {
    TextEditingController dataController = TextEditingController();
    TextEditingController proceedingController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Add Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18, color: Colors.grey[600]),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date Picker Field
                  TextFormField(
                    controller: dataController,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.grey[300]!,
                                onPrimary: Colors.grey[700]!,
                                surface: Colors.grey,
                                onSurface: Colors.grey[700]!,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setState(() {
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          dataController.text = formattedDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                      labelText: 'Date',
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
                  SizedBox(height: 10),
                  // Proceeding Text Field
                  TextFormField(
                    maxLines: 2,
                    controller: proceedingController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                      labelText: 'Proceeding',
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
                side: MaterialStateProperty.all(BorderSide(
                  color: Colors.grey[600]!,
                  width: 2,
                  style: BorderStyle.solid,
                )),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = dataController.text.trim();
                String proceeding = proceedingController.text.trim();
                if (data.isNotEmpty && proceeding.isNotEmpty) {
                  AccusedProceedingModel newProceeding = AccusedProceedingModel(
                    accusedId: widget.accused.id!,
                    date: dataController.text,
                    proceeding: proceedingController.text,
                  );

                  // Insert into the database
                  await dbHandler.insertAccusedProceeding(newProceeding);
                  Get.snackbar('Success', 'Proceeding added successfully', snackPosition: SnackPosition.TOP);
                  Navigator.of(context).pop();

                  // Refresh the proceedings list
                  _fetchProceedings();
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
  }


  Future<void> _showEditProceedingDialog(AccusedProceedingModel proc) async {
    TextEditingController dataController = TextEditingController(text: proc.date);
    TextEditingController proceedingController = TextEditingController(text: proc.proceeding);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Edit Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18, color: Colors.grey[600]),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: dataController,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.grey[300]!,
                                onPrimary: Colors.grey[700]!,
                                surface: Colors.grey,
                                onSurface: Colors.grey[700]!,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setState(() {
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          dataController.text = formattedDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                      labelText: 'Date',
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
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: 2,
                    controller: proceedingController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                      labelText: 'Proceeding',
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
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _deleteProceeding(proc.id!);
                    },
                    child: Icon(Icons.delete),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width:5,),
                Expanded(
                  child: TextButton(
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
                ),
                SizedBox(width:5,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      String data = dataController.text.trim();
                      String proceeding = proceedingController.text.trim();
                      if (data.isNotEmpty && proceeding.isNotEmpty) {
                        AccusedProceedingModel updatedProceeding = AccusedProceedingModel(
                          id: proc.id,
                          accusedId: proc.accusedId,
                          date: dataController.text,
                          proceeding: proceedingController.text,
                        );

                        await dbHandler.updateAccusedProceeding(updatedProceeding);

                        Get.snackbar('Success', 'Proceeding updated successfully.', snackPosition: SnackPosition.TOP);

                        Navigator.of(context).pop();
                        _fetchProceedings();
                      }else{
                        Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP,);
                      }
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.accused.profile,style: TextStyle(fontFamily: 'Eina',color: Colors.grey[700]),),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder<List<AccusedProceedingModel>>(
            future: DBHandler().fetchAccusedProceedings(widget.accused.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching proceedings: ${snapshot.error}'),
                );
              } else {
                final proceeding = snapshot.data!;

                proceedings.sort((a, b) {
                  DateTime dateA = _parseDate(a.date); // Use custom parse function
                  DateTime dateB = _parseDate(b.date); // Use custom parse function
                  return dateA.compareTo(dateB); // Ascending order: latest at the bottom
                });
                if (proceeding.isEmpty) {
                  return Center(
                    child: Text(
                      'No Proceedings available',
                      style: TextStyle(
                        fontFamily: 'Eina',
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey[400]!),
                        columnWidths: const {
                          0: FlexColumnWidth(2), // Date
                          1: FlexColumnWidth(4), // Proceeding
                          2: FlexColumnWidth(1), // Actions
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    fontFamily: 'Eina',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Proceeding',
                                  style: TextStyle(
                                    fontFamily: 'Eina',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontFamily: 'Eina',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ...proceedings.map((proc) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    proc.date, // Assuming 'data' holds the date
                                    style: TextStyle(fontFamily: 'Eina'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    proc.proceeding,
                                    style: TextStyle(fontFamily: 'Eina'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(Icons.edit, color: Colors.grey),
                                    onPressed: () => _showEditProceedingDialog(proc),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      SizedBox(height: 100,)
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProceedingDialog,
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.black,
        tooltip: 'Add Proceeding',
      ),
    );
  }
}
