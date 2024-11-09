// Import necessary packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mera_munshi/Components/AccusedNameProceeding.dart';
import 'package:mera_munshi/models/CaseModel.dart';
import 'package:mera_munshi/models/AccusedModel.dart';
import 'package:mera_munshi/models/ProceedingModel.dart';
import 'package:mera_munshi/models/CitationModel.dart';
import 'package:mera_munshi/utils/DBHandler.dart';
import '../models/BailModel.dart';
import 'myTextfield.dart';

class CaseDetailsPage extends StatefulWidget {
  final ModelClass caseItem;

  const CaseDetailsPage({Key? key, required this.caseItem}) : super(key: key);

  @override
  _CaseDetailsPageState createState() => _CaseDetailsPageState();
}

class _CaseDetailsPageState extends State<CaseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DBHandler dbHandler = DBHandler();

  @override
  void initState() {
    super.initState();
    int tabCount = (widget.caseItem.selectedcasetype == 'Criminal Case') ? 4 : 2;
    int tabinitialindex = (widget.caseItem.selectedcasetype == 'Criminal Case') ? 2 : 0;
    _tabController = TabController(length: tabCount, vsync: this, initialIndex: tabinitialindex );
  }

  // Dispose of the TabController
  @override
  void dispose() {
    _tabController.dispose();
    dbHandler.close();
    super.dispose();
  }

  // Helper method to show SnackBar messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _addAccused() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Add Accused',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
              labelText: 'Accused name',
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String profile = controller.text.trim();
                if (profile.isNotEmpty) {
                  AccusedModel newAccused = AccusedModel(
                    caseId: widget.caseItem.id!,
                    profile: profile,
                  );
                  await dbHandler.insertAccused(newAccused);
                  Navigator.pop(context);
                  _showSnackBar('Accused added successfully');
                  setState(() {});
                } else {
                  Get.snackbar('Warning', 'Please enter a profile name.', snackPosition: SnackPosition.TOP);
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


  Future<void> _editAccused(AccusedModel accused) async {
    TextEditingController controller = TextEditingController(text: accused.profile);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Edit Accused',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
              labelText: 'Accused name',
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String updatedProfile = controller.text.trim();
                if (updatedProfile.isNotEmpty) {
                  AccusedModel updatedAccused = AccusedModel(
                    id: accused.id,
                    caseId: accused.caseId,
                    profile: updatedProfile,
                  );
                  await dbHandler.updateAccused(updatedAccused);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Accused updated successfully.', snackPosition: SnackPosition.TOP);
                  setState(() {}); // Refresh UI
                } else {
                  Get.snackbar('Warning', 'Please enter a profile name.', snackPosition: SnackPosition.TOP);
                }
              },
              child: Text('Save'),
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

  Future<void> _deleteAccused(AccusedModel accused) async {
    bool confirm = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Delete Accused',
            style: TextStyle(fontFamily: 'Eina', fontSize: 22,),
          ),
          content: Text(
            'Are you sure you want to delete "${accused.profile}"?',
            style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
          ),
          actions: [
            OutlinedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
                side: MaterialStateProperty.all(BorderSide(
                  color: Colors.grey[600]!,
                  width: 2,
                  style: BorderStyle.solid,
                )),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
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
    );

    if (confirm) {
      await dbHandler.deleteAccused(accused.id!);
      Get.snackbar('Success', 'Accused Deleted successfully.', snackPosition: SnackPosition.TOP);
      setState(() {}); // Refresh UI
    }
  }


  // 2. Bail Proceeding CRUD Operations

  Future<void> _addBailProceeding() async {
    TextEditingController dataController = TextEditingController();
    TextEditingController proceedingController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text('Add Bail Proceeding',style: TextStyle(fontFamily: 'Eina',fontSize: 18),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            TextFormField(
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
                          primary: Colors.grey[300]!, // Header background color
                          onPrimary: Colors.grey[700]!,
                          surface: Colors.grey, // Header text color
                          onSurface: Colors.grey[700]!, // Body text color
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedDate != null) {
                  setState(() {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    dataController.text = formattedDate; // Your date controller
                  });
                }
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                labelText: 'Date',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                hintText: '',
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
              controller: dataController, // Use a controller for the date
            ),
            SizedBox(height: 10,),
            MyTextField(
              maxlines: 2, // Allow text to wrap
              label: 'Proceeding',
              controller: proceedingController, // Your bail proceeding controller
              hintText: '',
              obscureText: false,
            ),
            ],
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = dataController.text.trim();
                String proceeding = proceedingController.text.trim();
                if (data.isNotEmpty && proceeding.isNotEmpty) {
                  BailProceedingModel newBailProceeding =
                  BailProceedingModel(
                    caseId: widget.caseItem.id!,
                    data: data,
                    proceeding: proceeding,
                  );
                  await dbHandler.insertBailProceeding(newBailProceeding);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Proceeding added successfully', snackPosition: SnackPosition.TOP,);
                  setState(() {}); // Refresh UI
                }else{
                  Get.snackbar(  'Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP,);
                }
              },
              child: Text('Save'),
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

  Future<void> _editBailProceeding(BailProceedingModel bailProceeding) async {
    TextEditingController dataController =
    TextEditingController(text: bailProceeding.data);
    TextEditingController proceedingController =
    TextEditingController(text: bailProceeding.proceeding);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Edit Bail Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: Column(
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
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      dataController.text = formattedDate;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                  labelText: 'Data',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: '',
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
              MyTextField(
                maxlines: 2, // Allow text to wrap
                label: 'Proceeding',
                controller: proceedingController,
                hintText: '',
                obscureText: false,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                _deleteBailProceeding(bailProceeding);
              },
              child: Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
            ),
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
                String updatedData = dataController.text.trim();
                String updatedProceeding = proceedingController.text.trim();
                if (updatedData.isNotEmpty && updatedProceeding.isNotEmpty) {
                  BailProceedingModel updatedBailProceeding =
                  BailProceedingModel(
                    id: bailProceeding.id,
                    caseId: bailProceeding.caseId,
                    data: updatedData,
                    proceeding: updatedProceeding,
                  );
                  await dbHandler.updateBailProceeding(updatedBailProceeding);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Proceeding updated successfully', snackPosition: SnackPosition.TOP,);
                  setState(() {}); // Refresh UI
                }else{
                  Get.snackbar(  'Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP,);
                }
              },
              child: Text('Save'),
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


  Future<void> _deleteBailProceeding(BailProceedingModel bailProceeding) async {
    bool confirm = false;

    await showDialog(
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
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
    );

    if (confirm) {
      await dbHandler.deleteBailProceeding(bailProceeding.id!);
      Get.snackbar('Success', 'Bail Deleted successfully.', snackPosition: SnackPosition.TOP);
      setState(() {}); // Refresh UI
    }
  }


  Future<void> _addProceeding() async {
    TextEditingController dataController = TextEditingController();
    TextEditingController proceedingController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Add Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: Container(
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
                              primary: Colors.grey[300]!, // Header background color
                              onPrimary: Colors.grey[700]!,
                              surface: Colors.grey, // Header text color
                              onSurface: Colors.grey[700]!, // Body text color
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      setState(() {
                        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                        dataController.text = formattedDate; // Update the date controller
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                    labelText: 'Date',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    hintText: '',
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
                MyTextField(
                  maxlines: 2, // Allow text to wrap
                  label: 'Proceeding',
                  controller: proceedingController,
                  hintText: '',
                  obscureText: false,
                ),
              ],
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String data = dataController.text.trim();
                String proceeding = proceedingController.text.trim();
                if (data.isNotEmpty && proceeding.isNotEmpty) {
                  ProceedingModel newProceeding = ProceedingModel(
                    caseId: widget.caseItem.id!,
                    data: data,
                    proceeding: proceeding,
                  );
                  await dbHandler.insertProceeding(newProceeding);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Proceeding added successfully', snackPosition: SnackPosition.TOP,);
                  setState(() {}); // Refresh UI
                }else{
                  Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP,);
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


  Future<void> _editProceeding(ProceedingModel proceeding) async {
    TextEditingController dataController =
    TextEditingController(text: proceeding.data);
    TextEditingController proceedingController =
    TextEditingController(text: proceeding.proceeding);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Edit Proceeding',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: Container(
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
                              primary: Colors.grey[300]!, // Header background color
                              onPrimary: Colors.grey[700]!,
                              surface: Colors.grey, // Header text color
                              onSurface: Colors.grey[700]!, // Body text color
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      setState(() {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        dataController.text = formattedDate; // Update the date controller
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                    labelText: 'Date',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    hintText: '',
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
                MyTextField(
                  maxlines: 2, // Allow text to wrap
                  label: 'Proceeding',
                  controller: proceedingController,
                  hintText: '',
                  obscureText: false,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _deleteProceeding(proceeding);
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
                      String updatedData = dataController.text.trim();
                      String updatedProceeding = proceedingController.text.trim();
                      if (updatedData.isNotEmpty && updatedProceeding.isNotEmpty) {
                        ProceedingModel updatedProceedingModel = ProceedingModel(
                          id: proceeding.id,
                          caseId: proceeding.caseId,
                          data: updatedData,
                          proceeding: updatedProceeding,
                        );
                        await dbHandler.updateProceeding(updatedProceedingModel);
                        Navigator.pop(context);
                        Get.snackbar('Success', 'Proceeding updated successfully', snackPosition: SnackPosition.TOP);
                        setState(() {}); // Refresh UI
                      } else {
                        Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP);
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




  Future<void> _deleteProceeding(ProceedingModel proceeding) async {
    bool confirm = false;

    await showDialog(
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
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
    );

    if (confirm) {
      await dbHandler.deleteProceeding(proceeding.id!);
      Get.snackbar('Success', 'Proceeding deleted successfully.', snackPosition: SnackPosition.TOP);
      setState(() {}); // Refresh UI
    }
  }


  Future<void> _addCitation() async {
    TextEditingController citationController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Add Citation',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: Container(
            width: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: citationController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                    labelText: 'Citation',
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
                TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                    labelText: 'Description',
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String citation = citationController.text.trim();
                String description = descriptionController.text.trim();
                if (citation.isNotEmpty && description.isNotEmpty) {
                  CitationModel newCitation = CitationModel(
                    caseId: widget.caseItem.id!,
                    citation: citation,
                    description: description,
                  );
                  await dbHandler.insertCitation(newCitation);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Citation added successfully', snackPosition: SnackPosition.TOP);
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
  }



  Future<void> _editCitation(CitationModel citation) async {
    TextEditingController citationController =
    TextEditingController(text: citation.citation);
    TextEditingController descriptionController =
    TextEditingController(text: citation.description);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Edit Citation',
            style: TextStyle(fontFamily: 'Eina', fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: citationController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                  labelText: 'Citation',
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
              TextFormField(
                controller: descriptionController,
                maxLines: 2, // Allow text to wrap
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
                  labelText: 'Description',
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String updatedCitation = citationController.text.trim();
                String updatedDescription = descriptionController.text.trim();
                if (updatedCitation.isNotEmpty && updatedDescription.isNotEmpty) {
                  CitationModel updatedCitationModel = CitationModel(
                    id: citation.id,
                    caseId: citation.caseId,
                    citation: updatedCitation,
                    description: updatedDescription,
                  );
                  await dbHandler.updateCitation(updatedCitationModel);
                  Navigator.pop(context);
                  Get.snackbar('Success', 'Citation updated successfully', snackPosition: SnackPosition.TOP);
                  setState(() {});
                } else {
                  Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP);
                }
              },
              child: Text('Save'),
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

  Future<void> _deleteCitation(CitationModel citation) async {
    bool confirm = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Delete Citation',
            style: TextStyle(fontFamily: 'Eina', fontSize: 22),
          ),
          content: Text(
            'Are you sure you want to delete "${citation.citation}"?',
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

              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
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
    );

    if (confirm) {
      await dbHandler.deleteCitation(citation.id!);
      Get.snackbar('Success', 'Accused Deleted successfully.', snackPosition: SnackPosition.TOP);
      setState(() {}); // Refresh UI
    }
  }


  // -------------------- UI for Each Tab --------------------

  // 1. Accused Tab
  Widget _buildAccusedTab() {
    return FutureBuilder<List<AccusedModel>>(
      future: dbHandler.fetchAccused(widget.caseItem.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error fetching accused: ${snapshot.error}'),
          );
        } else {
          final accusedList = snapshot.data!;
          if (accusedList.isEmpty) {
            return Center(
              child: Text(
                'No Accused List available',
                style: TextStyle(
                  fontFamily: 'Eina',
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            itemCount: accusedList.length,
            itemBuilder: (context, index) {
              final accused = accusedList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey[200],
                child: ListTile(
                  title: Text(
                    accused.profile,
                    style: TextStyle(fontFamily: 'Eina'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => _editAccused(accused),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _deleteAccused(accused),
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccusedDetailsPage(accused: accused),));
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  DateTime _parseDate(String date) {
    // Split the date string into components
    List<String> parts = date.split('-');
    // Check if parts length is 3 (day, month, year)
    if (parts.length == 3) {
      // Return a DateTime object using the parsed components (day, month, year)
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    }
    // If parsing fails, throw an error
    throw FormatException('Invalid date format');
  }


  // 3. Proceedings Tab
  Widget _buildProceedingsTab() {
    return FutureBuilder<List<ProceedingModel>>(
      future: dbHandler.fetchProceedings(widget.caseItem.id!),
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
          final proceedings = snapshot.data!;


          if (proceedings.isEmpty) {
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

          proceedings.sort((a, b) {
            // Parse the date strings into DateTime objects
            DateTime dateA = _parseDate(a.data); // Assuming 'data' is a date string
            DateTime dateB = _parseDate(b.data); // Assuming 'data' is a date string

            // Compare the dates in ascending order (oldest date first)
            return dateA.compareTo(dateB); // Ascending order (oldest first)
          });


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
                              proc.data, // Assuming 'data' holds the date
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
                              onPressed: () => _editProceeding(proc),
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
    );
  }

  // 4. Citations Tab
  Widget _buildCitationsTab() {
    return FutureBuilder<List<CitationModel>>(
      future: dbHandler.fetchCitations(widget.caseItem.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error fetching citations: ${snapshot.error}'),
          );
        } else {
          final citations = snapshot.data!;
          if (citations.isEmpty) {
            return Center(
              child: Text(
                'No Citations available',
                style: TextStyle(
                  fontFamily: 'Eina',
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: citations.map((citation) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.grey[200],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width - 32,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                width: double.infinity,
                                // Remove the fixed height and use padding instead
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                child: Center(
                                  child: Text(
                                    citation.citation,
                                    style: TextStyle(
                                      fontFamily: 'Eina',
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center, // Center the text horizontally
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
                                  children: [
                                    Text(
                                      citation.description,
                                      style: TextStyle(
                                        fontFamily: 'Eina',
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Spacer(),
                                        IconButton(
                                          onPressed: () => _editCitation(citation),
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        IconButton(
                                          onPressed: () => _deleteCitation(citation),
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 100,)
              ],
            ),
          );
        }
      },
    );
  }

  // -------------------- Floating Action Button --------------------

  void _onFabPressed() {
    if(widget.caseItem.selectedcasetype == 'Criminal Case'){
      switch (_tabController.index) {
        case 0:
          _addAccused();
          break;
        case 1:
          _addProceeding();
          break;
        case 2:
          _addCitation();
          break;
        default:
          break;
      }
    }else{
      switch (_tabController.index) {
        case 0:
          _addProceeding();
          break;
        case 1:
          _addCitation();
          break;
        default:
          break;
      }
    }
  }

  // -------------------- Build Method --------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Column(
          children: [
            // Custom Header Container
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 5,
                      runSpacing: 3,
                      children: [
                        Text(
                          widget.caseItem.casetitle,
                          style: TextStyle(
                            fontFamily: 'Eina',
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '(${widget.caseItem.courtname})',
                          style: TextStyle(
                            fontFamily: 'Eina',
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    if (widget.caseItem.cpnumber != null && widget.caseItem.cpnumber!.isNotEmpty) ...[
                      Text('CP No : ${widget.caseItem.cpnumber}',style: TextStyle(
                        fontFamily: 'Eina',
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(height: 3),
                    ],
                    Wrap(
                      spacing: 10,
                      runSpacing: 3,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'For: ',
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: widget.caseItem.casefor,
                                style: TextStyle(
                                  fontFamily: 'Eina',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<ProceedingModel?>(
                          future: dbHandler.fetchLatestProceeding(widget.caseItem.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontFamily: 'Eina',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error loading date',
                                style: TextStyle(
                                  fontFamily: 'Eina',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              );
                            } else if (!snapshot.hasData) {
                              return Text(
                                'Not available',
                                style: TextStyle(
                                  fontFamily: 'Eina',
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              );
                            } else {
                              final proceeding = snapshot.data!;
                              return RichText(
                                text: TextSpan(
                                  text: 'Next Hearing: ',
                                  style: TextStyle(
                                    fontFamily: 'Eina',
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: proceeding.data, // Date of the latest proceeding
                                      style: TextStyle(
                                        fontFamily: 'Eina',
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Proceeding
                    FutureBuilder<ProceedingModel?>(
                      future: dbHandler.fetchLatestProceeding(widget.caseItem.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            'Loading proceeding...',
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading proceeding',
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return Text(
                            'Proceeding: Not available',
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          );
                        } else {
                          final proceeding = snapshot.data!;
                          return RichText(
                            text: TextSpan(
                              text: 'Proceeding: ',
                              style: TextStyle(
                                fontFamily: 'Eina',
                                color: Colors.grey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: proceeding.proceeding,
                                  style: TextStyle(
                                    fontFamily: 'Eina',
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                    // Nature
                    RichText(
                      text: TextSpan(
                        text: 'Nature: ',
                        style: TextStyle(
                          fontFamily: 'Eina',
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: widget.caseItem.selectedcasetype == 'Other'
                                ? widget.caseItem.nature
                                : widget.caseItem.selectedcasetype,
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Provision
                    RichText(
                      text: TextSpan(
                        text: 'Provision: ',
                        style: TextStyle(
                          fontFamily: 'Eina',
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: widget.caseItem.provisions,
                            style: TextStyle(
                              fontFamily: 'Eina',
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    // TabBar
                    Container(
                      color: Colors.grey[300],
                      child: TabBar(
                        controller: _tabController,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        tabs: [
                          if (widget.caseItem.selectedcasetype == 'Criminal Case') ...[
                            const Tab(
                              child: Text(
                                'Accused Bails',
                                style: TextStyle(fontSize: 10, fontFamily: 'Eina'),
                              ),
                            ),
                          ],
                          const Tab(
                            child: Text(
                              'Proceedings',
                              style: TextStyle(fontSize: 10, fontFamily: 'Eina'),
                            ),
                          ),
                          const Tab(
                            child: Text(
                              'Citations',
                              style: TextStyle(fontSize: 10, fontFamily: 'Eina'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TabBarView
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          if (widget.caseItem.selectedcasetype == 'Criminal Case') ...[
                            _buildAccusedTab(),
                          ],
                          _buildProceedingsTab(),
                          _buildCitationsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: _onFabPressed,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
