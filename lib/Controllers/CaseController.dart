// controllers/case_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/CaseModel.dart';
import '../utils/DBHandler.dart';

class CaseController extends GetxController {
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController caseTitleController = TextEditingController();
  final TextEditingController forController = TextEditingController();
  final TextEditingController provisionsController = TextEditingController();
  final TextEditingController natureController = TextEditingController();
  final TextEditingController cpnumber = TextEditingController();

  String selectedCaseType = '';

  // Save case to SQLite database
  Future<void> saveCase(BuildContext context) async {
    if (courtNameController.text.isNotEmpty &&
        caseTitleController.text.isNotEmpty &&
        forController.text.isNotEmpty &&
        provisionsController.text.isNotEmpty &&
        (selectedCaseType.isNotEmpty || natureController.text.isNotEmpty)) {


      await DBHandler().insertCase(ModelClass(
        cpnumber: cpnumber.text,
          casetitle: caseTitleController.text,
          courtname: courtNameController.text,
          casefor: forController.text,
        provisions: provisionsController.text,
        selectedcasetype: selectedCaseType,
        nature: natureController.text.trim(),
      )
      );

      // Reset fields after savings
      resetData();
      Navigator.pop(context);

      Get.snackbar('Success', 'Case added to diary', snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Warning', 'Please fill in all fields.', snackPosition: SnackPosition.TOP,);
    }
  }


  void setSelectedCaseType(String caseType) {
    selectedCaseType = caseType;
    update(); // Update UI when case type changes
  }

  void resetData() {
    courtNameController.clear();
    caseTitleController.clear();
    forController.clear();
    provisionsController.clear();
    natureController.clear();
    cpnumber.clear();
    selectedCaseType = '';
    update(); // Update UI to reflect cleared data
  }
}
