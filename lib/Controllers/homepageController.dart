import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Components/CaseLaw.dart';
import '../models/CaseModel.dart';
import '../models/ProceedingModel.dart';
import '../pages/MakeNewCauselist.dart';
import '../utils/DBHandler.dart';
import '../utils/auth_service.dart';
import 'CaseController.dart';

class homepageController extends GetxController{
  DBHandler dbHelper = DBHandler();
  final CaseController caseController = Get.put(CaseController());
  final AuthService authService = AuthService();
  final GetStorage store = GetStorage();
  DateTime? selectedDate;
  List<Map<String, dynamic>> cases = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    super.dispose();
    refreshCase();
    print('ayub');
  }

  void _refreshList() {
      loadCases(); // Refresh cases from the database
      print('ayub');
  }

  Future<void> refreshCase() async {
    loadCases(); // Reload cases after refresh
  }

  void loadCases() async {
    List<ModelClass> storedCases = await DBHandler().fetchCases();
      cases = storedCases
          .map((e) =>
      {
        'id': e.id,
        'casetitle': e.casetitle,
        'courtname': e.courtname,
        'casefor': e.casefor,
        'provisions': e.provisions,
        'selectedcasetype': e.selectedcasetype,
        'nature': e.nature,
        // Add other properties as needed
      })
          .toList();
  }

  void deleteCase(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.grey[300],
            title: Text(
              'Delete Case',
              style: TextStyle(
                fontFamily: 'Eina',
                fontSize: 25,
                color: Colors.grey[700],
              ),
            ),
            content: Text(
              'Are you sure you want to delete this case?',
              style: TextStyle(
                fontFamily: 'Eina',
                color: Colors.grey[700],
              ),
            ),
            actions: [
              const SizedBox(height: 10),
              // Cancel Button
              OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color: Colors.grey[600]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
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
                  await DBHandler().deleteCase(id);
                  Navigator.of(context).pop(); // Dismiss the dialog
                  _refreshList(); // Refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Case deleted successfully')),
                  );
                },
                child: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
    );
  }

  void editCase(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakeCauseList(index: index),
      ),
    );
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(6000),
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

    if (selectedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CauseListPage(initialDate: selectedDate),
        ),
      );
    }
  }

}