import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mera_munshi/Controllers/homepageController.dart';
import 'package:mera_munshi/models/CaseModel.dart';
import 'package:mera_munshi/utils/DBHandler.dart';

import '../Components/myTextfield.dart';
import '../Controllers/CaseController.dart'; // Import GetX

class MakeCauseList extends StatefulWidget {
  final int? index;
  final Map<String, dynamic>? caseData;
  Function? refresh;

  MakeCauseList({super.key, this.index, this.refresh, this.caseData});

  @override
  _MakeCauseListState createState() => _MakeCauseListState();
}

class _MakeCauseListState extends State<MakeCauseList> {
  // Initialize the controller using GetX
  final CaseController caseController = Get.put(CaseController());
  final homepageController homepagecontroller = Get.put(homepageController());

  // List of case types
  final List<String> caseTypes = [
    'Civil Case',
    'Criminal Case',
    'Family Case',
    'Service Tribunal',
    'Other'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset the controller data when this widget is rebuilt
    caseController.resetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      true, // Automatically resize body to avoid keyboard
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Add a new Case',
          style: TextStyle(
            fontFamily: 'Eina',
            color: Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Court Name Input
                MyTextField(
                  label: 'Court Name',
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  controller: caseController.courtNameController,
                  hintText: '',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Case Title Input
                MyTextField(
                  label: 'Case Title',
                  controller: caseController.caseTitleController,
                  hintText: '',
                  obscureText: false,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                ),
                const SizedBox(height: 10),
                // Plaintiff/Defendan/Complainant/Appellant Input
                MyTextField(
                  label: 'CP No.',
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  controller: caseController.cpnumber,
                  hintText: '',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  label: 'Plaintiff/Defendant/Complainant/Appellant',
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  controller: caseController.forController,
                  hintText: '',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Provissions Input
                MyTextField(
                  label: 'Provissions',
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  controller: caseController.provisionsController,
                  hintText: '',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Dropdown for Case Type within GetBuilder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        child: SizedBox(
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
                // Conditionally show "Nature" field if 'Other' is selected within GetBuilder
                GetBuilder<CaseController>(
                  builder: (controller) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: controller.selectedCaseType == 'Other'
                          ? MyTextField(
                        label: 'Nature',
                        controller: caseController.natureController,
                        hintText: '',
                        obscureText: false,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 25),
                      )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(height: 30),
                // "Add to Diary" Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                      });
                      caseController.saveCase(context);
                      final data = await DBHandler().fetchCases();
                      print(data);
                      homepagecontroller.loadCases();
                      homepagecontroller.refreshCase();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 55,
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'Add to Diary',
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
        ),
      ),
    );
  }
}
