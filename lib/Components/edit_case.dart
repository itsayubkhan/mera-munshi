// EditCasePage.dart
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/CaseController.dart';
import '../models/CaseModel.dart';
import '../utils/DBHandler.dart';
import 'myTextfield.dart';

class EditCasePage extends StatefulWidget {
  final ModelClass caseItem;

  EditCasePage({Key? key, required this.caseItem}) : super(key: key);

  @override
  _EditCasePageState createState() => _EditCasePageState();
}

class _EditCasePageState extends State<EditCasePage> {
  final CaseController caseController = Get.find(); // Get the existing controller

  TextEditingController courtNameController = TextEditingController();
  TextEditingController caseTitleController = TextEditingController();
  TextEditingController forController = TextEditingController();
  TextEditingController provisionsController = TextEditingController();
  TextEditingController natureController = TextEditingController();

  final List<String> caseTypes = [
    'Civil Case',
    'Criminal Case',
    'Family Case',
    'Service Tribunal',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing case data
    caseTitleController.text = widget.caseItem.casetitle;
    courtNameController.text = widget.caseItem.courtname;
    forController.text = widget.caseItem.casefor;
    provisionsController.text = widget.caseItem.provisions;
    natureController.text = widget.caseItem.nature;

    // Initialize the controller's selectedCaseType
    caseController.setSelectedCaseType(widget.caseItem.selectedcasetype);
  }

  Future<void> _saveChanges() async {
    if (courtNameController.text.isNotEmpty &&
        caseTitleController.text.isNotEmpty &&
        forController.text.isNotEmpty &&
        provisionsController.text.isNotEmpty &&
        (caseController.selectedCaseType.isNotEmpty || natureController.text.isNotEmpty)) {

      final updatedCase = ModelClass(
          id: widget.caseItem.id,
          casetitle: caseTitleController.text,
          courtname: courtNameController.text,
          casefor: forController.text,
          provisions: provisionsController.text,
          selectedcasetype: caseController.selectedCaseType,
          nature: natureController.text.trim()
      );
      print(caseController.selectedCaseType);

      await DBHandler().updateCase(updatedCase);
      Navigator.pop(context, true); // Indicate to refresh
      Get.snackbar('Success', 'Case successfully updated', snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Error', 'Please fill all the fields', snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[400],
        title: Text('Edit Case',style: TextStyle(color: Colors.grey[700],fontFamily: 'Eina'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Court Name Input
            MyTextField(
              label: 'Court Name',
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: courtNameController,
              hintText: '',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // Case Title Input
            MyTextField(
              label: 'Case Title',
              controller: caseTitleController,
              hintText: '',
              obscureText: false,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            const SizedBox(height: 10),
            // Plaintiff/Defendan/Complainant/Appellant Input
            MyTextField(
              label: 'Plaintiff/Defendan/Complainant/Appellant',
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: forController,
              hintText: '',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            // Provissions Input
            MyTextField(
              label: 'Provissions',
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: provisionsController,
              hintText: '',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GetBuilder<CaseController>(
                builder: (controller) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontFamily: 'Eina', color: Colors.grey[500]),
                      hintText: 'Select Case Type',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintStyle: const TextStyle(fontFamily: "Eina"),
                    ),
                    child: Container(
                      height: 25,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedCaseType.isEmpty
                              ? null
                              : controller.selectedCaseType,
                          isExpanded: true,
                          items: caseTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                style: const TextStyle(
                                    fontFamily: 'Eina', color: Colors.grey),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setSelectedCaseType(newValue);
                            }
                          },
                          hint: const Text('Select Case Type',
                              style: TextStyle(
                                  fontFamily: 'Eina',
                                  color: Colors.grey)), // Hint text
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Conditionally show "Nature" field if 'Other' is selected
            GetBuilder<CaseController>(
              builder: (controller) {
                return controller.selectedCaseType == 'Other'
                    ? MyTextField(
                  label: 'Nature',
                  controller: natureController,
                  hintText: '',
                  obscureText: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                )
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 30),
            // "Edit" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 125),
              child: GestureDetector(
                onTap: _saveChanges,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 55,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Eina',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
