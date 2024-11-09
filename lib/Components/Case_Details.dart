// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
//
// import '../models/ProceedingModel.dart';
// import '../models/CaseModel.dart';
// import '../utils/DBHandler.dart';
// import 'myTextfield.dart';
// import 'mybutton.dart';
//
// class CaseDetailsPage extends StatefulWidget {
//   final ModelClass caseItem;
//
//   const CaseDetailsPage({super.key, required this.caseItem});
//
//   @override
//   State<CaseDetailsPage> createState() => _CaseDetailsPageState();
// }
//
// class _CaseDetailsPageState extends State<CaseDetailsPage>
//     with TickerProviderStateMixin {
//   TextEditingController dateController = TextEditingController();
//   TextEditingController npController = TextEditingController();
//   TextEditingController citationController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController bailProceedingController = TextEditingController();
//   TextEditingController bailDateController = TextEditingController();
//   TextEditingController proceedingDateController = TextEditingController();
//   TextEditingController proceedingDescriptionController =
//       TextEditingController();
//   TextEditingController accusedController = TextEditingController();
//
//   final storage = GetStorage(); // Create a storage instance
//
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // void addBailProceeding() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       backgroundColor: Colors.grey[300],
//   //       title: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Text('Add New Bail',style: TextStyle(fontFamily: 'Eina',fontSize: 25,color: Colors.grey[600]),),
//   //           SizedBox(height: 10,),
//   //           TextFormField(
//   //             readOnly: true,
//   //             onTap: () async {
//   //               final DateTime? pickedDate = await showDatePicker(
//   //                 context: context,
//   //                 initialDate: DateTime.now(),
//   //                 firstDate: DateTime(2000),
//   //                 lastDate: DateTime(3000),
//   //                 builder: (context, child) {
//   //                   return Theme(
//   //                     data: ThemeData().copyWith(
//   //                       colorScheme: ColorScheme.dark(
//   //                         primary: Colors.grey[300]!, // Header background color
//   //                         onPrimary: Colors.grey[700]!,
//   //                         surface: Colors.grey, // Header text color
//   //                         onSurface: Colors.grey[700]!, // Body text color
//   //                       ),
//   //                     ),
//   //                     child: child!,
//   //                   );
//   //                 },
//   //               );
//   //
//   //               if (pickedDate != null) {
//   //                 setState(() {
//   //                   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//   //                   bailDateController.text = formattedDate; // Your date controller
//   //                 });
//   //               }
//   //             },
//   //             decoration: InputDecoration(
//   //               labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //               labelText: 'Date',
//   //               floatingLabelBehavior: FloatingLabelBehavior.auto,
//   //               hintText: '',
//   //               enabledBorder: OutlineInputBorder(
//   //                 borderRadius: BorderRadius.circular(10),
//   //                 borderSide: const BorderSide(color: Colors.white),
//   //               ),
//   //               focusedBorder: OutlineInputBorder(
//   //                 borderRadius: BorderRadius.circular(10),
//   //                 borderSide: BorderSide(color: Colors.grey.shade400),
//   //               ),
//   //               fillColor: Colors.grey.shade200,
//   //               filled: true,
//   //               hintStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //             ),
//   //             controller: bailDateController, // Use a controller for the date
//   //           ),
//   //           SizedBox(height: 10,),
//   //           MyTextField(
//   //             maxlines: 2, // Allow text to wrap
//   //             label: 'Proceeding',
//   //             controller: bailProceedingController, // Your bail proceeding controller
//   //             hintText: '',
//   //             obscureText: false,
//   //           ),
//   //           SizedBox(height: 20,),
//   //           MyButton(
//   //             ontap: () {
//   //               if (bailDateController.text.isNotEmpty &&
//   //                   bailProceedingController.text.isNotEmpty) {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Added to Bail Proceedings'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //                 setState(() {
//   //                   bailProceedings.add({
//   //                     'date': bailDateController.text,
//   //                     'proceeding': bailProceedingController.text,
//   //                   });
//   //
//   //                   // Save bail proceedings to GetStorage
//   //                   storage.write(
//   //                     '${widget.caseData['CaseTitle']}_bailProceedings',
//   //                     bailProceedings,
//   //                   );
//   //
//   //                   // Clear the text fields
//   //                   bailDateController.clear();
//   //                   bailProceedingController.clear();
//   //                 });
//   //
//   //                 Navigator.of(context).pop();
//   //               } else {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text(
//   //                     'Fill in the blanks',
//   //                     style: TextStyle(fontFamily: 'Eina', color: Colors.black),
//   //                   ),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //               }
//   //             },
//   //             text: 'Add Bail',
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   // void _editBailProceeding(int index) {
//   //   // Save the original date before showing the date picker
//   //   String originalDate = bailProceedings[index]['date'] ?? '';
//   //
//   //   bailDateController.text = originalDate.isNotEmpty
//   //       ? originalDate
//   //       : DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //   bailProceedingController.text = bailProceedings[index]['proceeding']!;
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         backgroundColor: Colors.grey[300],
//   //         title: Text(
//   //           'Edit Bail Proceeding',
//   //           style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
//   //         ),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             TextField(
//   //               readOnly: true,
//   //               controller: bailDateController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Date',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //               onTap: () async {
//   //                 // Show the date picker when the field is tapped
//   //                 DateTime? pickedDate = await showDatePicker(
//   //                   context: context,
//   //                   initialDate: bailDateController.text.isNotEmpty
//   //                       ? DateTime.tryParse(bailDateController.text) ?? DateTime.now()
//   //                       : DateTime.now(),
//   //                   firstDate: DateTime(2000),
//   //                   lastDate: DateTime(2101),
//   //                   builder: (context, child) {
//   //                     return Theme(
//   //                       data: ThemeData().copyWith(
//   //                         colorScheme: ColorScheme.dark(
//   //                           primary: Colors.grey[300]!,
//   //                           onPrimary: Colors.grey[700]!,
//   //                           surface: Colors.grey,
//   //                           onSurface: Colors.grey[700]!,
//   //                         ),
//   //                       ),
//   //                       child: child!,
//   //                     );
//   //                   },
//   //                 );
//   //
//   //                 if (pickedDate != null) {
//   //                   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//   //                   setState(() {
//   //                     bailDateController.text = formattedDate;
//   //                   });
//   //                 } else {
//   //                   // Revert to original date if no date is picked
//   //                   setState(() {
//   //                     bailDateController.text = originalDate;
//   //                   });
//   //                 }
//   //               },
//   //             ),
//   //             const SizedBox(height: 10),
//   //             // Proceeding Input Field
//   //             TextField(
//   //               controller: bailProceedingController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Proceeding',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             style: ButtonStyle(
//   //               foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
//   //               side: MaterialStateProperty.all(BorderSide(
//   //                 color: Colors.grey[600]!,
//   //                 width: 2,
//   //                 style: BorderStyle.solid,
//   //               )),
//   //             ),
//   //             onPressed: () {
//   //               // Revert date to the original value and close dialog
//   //               setState(() {
//   //                 bailDateController.text = originalDate;
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Cancel'),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 bailProceedings[index] = {
//   //                   'date': bailDateController.text,
//   //                   'proceeding': bailProceedingController.text,
//   //                 };
//   //                 storage.write('${widget.caseData['CaseTitle']}_bailProceedings', bailProceedings);
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Save'),
//   //             style: ElevatedButton.styleFrom(
//   //               foregroundColor: Colors.white,
//   //               backgroundColor: Colors.black,
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   // void addAccused() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       backgroundColor: Colors.grey[300],
//   //       title: Column(
//   //         children: [
//   //           Text('Add New Profile',style: TextStyle(fontFamily: 'Eina',fontSize: 25,color: Colors.grey[600]),),
//   //           SizedBox(height: 10,),
//   //           MyTextField(
//   //             label: 'Accused',
//   //             controller: accusedController, // Your accused controller
//   //             hintText: 'Enter Accused Name',
//   //             obscureText: false,
//   //           ),
//   //           SizedBox(height: 20),
//   //           MyButton(
//   //             ontap: () {
//   //               if (accusedController.text.isNotEmpty) {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Added to Accused'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //                 setState(() {
//   //                   // Add new accused to the list
//   //                   accusedList.add(accusedController.text);
//   //                   // Save accused list to GetStorage
//   //                   storage.write(
//   //                       '${widget.caseData['CaseTitle']}_accused', accusedList);
//   //
//   //                   // Clear the text field
//   //                   accusedController.clear();
//   //                 });
//   //                 Navigator.of(context).pop(); // Close the dialog
//   //               } else {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: Text(
//   //                     'Fill all the blanks',
//   //                     style: TextStyle(fontFamily: 'Eina', color: Colors.grey[800]),
//   //                   ),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //               }
//   //             },
//   //             text: 'Add Accused',
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   // void _editAccused(int index) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       accusedController.text = accusedList[index];
//   //       return AlertDialog(
//   //         backgroundColor: Colors.grey[300],
//   //         title: Text('Edit Accused',style: TextStyle(fontFamily: 'Eina',color: Colors.grey[600]),),
//   //         content: Padding(
//   //           padding: const EdgeInsets.only(top: 10),
//   //           child: MyTextField(
//   //               label: 'Profile Name',
//   //               controller: accusedController,
//   //               hintText: '',
//   //               obscureText: false,
//   //           ),
//   //         ),
//   //         actions: [
//   //           OutlinedButton(
//   //             style: ButtonStyle(
//   //                 side: MaterialStateProperty.all(BorderSide(
//   //                     color: Colors.grey[600]!,
//   //                     width: 2,
//   //                     style: BorderStyle.solid))),
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Cancel',style: TextStyle(color: Colors.grey[600]),),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 accusedList[index] = accusedController.text;
//   //                 storage.write('${widget.caseData['CaseTitle']}_accused', accusedList);
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Save'),style: ElevatedButton.styleFrom(
//   //             foregroundColor: Colors.white,
//   //             backgroundColor: Colors.black
//   //           ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//   void _deleteAccused(int index) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.grey[300],
//         title: Text('Delete Case',
//             style: TextStyle(fontFamily: 'Eina', fontSize: 25,color: Colors.grey[600])),
//         content: Text('Are you sure you want to delete this Profile?',
//             style: TextStyle(fontFamily: 'Eina',color: Colors.grey[600])),
//         actions: [
//           OutlinedButton(
//             style: ButtonStyle(
//                 side: MaterialStateProperty.all(BorderSide(
//                     color: Colors.grey[600]!,
//                     width: 2,
//                     style: BorderStyle.solid))),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel',style: TextStyle(color: Colors.grey[600]),),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 accusedList.removeAt(index);
//                 storage.write('${widget.caseData['CaseTitle']}_accused', accusedList);
//               });
//               Navigator.of(context).pop();
//             },
//             child: Text('Delete'),style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.black
//           ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // void addProceeding() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       backgroundColor: Colors.grey[300],
//   //       title: Column(
//   //         children: [
//   //           Text('Add New Proceeding',style: TextStyle(fontFamily: 'Eina',fontSize: 25,color: Colors.grey[600]),),
//   //           SizedBox(height: 10,),
//   //           TextFormField(
//   //             readOnly: true, // Make the field read-only to show date picker
//   //             onTap: () async {
//   //               final DateTime? pickedDate = await showDatePicker(
//   //                 context: context,
//   //                 initialDate: DateTime.now(),
//   //                 firstDate: DateTime(2000),
//   //                 lastDate: DateTime(3000),
//   //                 builder: (context, child) {
//   //                   return Theme(
//   //                     data: ThemeData().copyWith(
//   //                       colorScheme: ColorScheme.dark(
//   //                         primary: Colors.grey[300]!, // Header background color
//   //                         onPrimary: Colors.grey[700]!,
//   //                         surface: Colors.grey, // Header text color
//   //                         onSurface: Colors.grey[700]!, // Body text color
//   //                       ),
//   //                     ),
//   //                     child: child!,
//   //                   );
//   //                 },
//   //               );
//   //
//   //               if (pickedDate != null) {
//   //                 // Format the selected date
//   //                 String formattedDate =
//   //                     DateFormat('dd-MM-yyyy').format(pickedDate);
//   //
//   //                 // Update the Nexthearing controller with the formatted date
//   //                 setState(() {
//   //                   dateController.text = formattedDate;
//   //                 });
//   //               }
//   //             },
//   //             decoration: InputDecoration(
//   //                 labelStyle:
//   //                     TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 labelText: 'Date',
//   //                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//   //                 hintText: '',
//   //                 enabledBorder: OutlineInputBorder(
//   //                     borderRadius: BorderRadius.circular(10),
//   //                     borderSide: const BorderSide(color: Colors.white)),
//   //                 focusedBorder: OutlineInputBorder(
//   //                     borderRadius: BorderRadius.circular(10),
//   //                     borderSide: BorderSide(color: Colors.grey.shade400)),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //                 hintStyle:
//   //                     TextStyle(fontFamily: 'Eina', color: Colors.grey[500])),
//   //             controller: dateController,
//   //           ),
//   //           SizedBox(height: 10,),
//   //           MyTextField(
//   //             maxlines: 2,
//   //             label: 'Proceeding',
//   //             controller: npController,
//   //             hintText: 'Enter Proceeding',
//   //             obscureText: false,
//   //           ),
//   //           SizedBox(height: 20),
//   //           // Add Button
//   //           MyButton(
//   //             ontap: () {
//   //               if (dateController.text.isNotEmpty &&
//   //                   npController.text.isNotEmpty) {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Added to Proceedings'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //                 setState(() {
//   //                   // Add new proceeding to the list
//   //                   proceedings.add({
//   //                     'date': dateController.text,
//   //                     'proceeding': npController.text
//   //                   });
//   //
//   //                   // Save proceedings to GetStorage
//   //                   storage.write('${widget.caseData['CaseTitle']}_proceedings',
//   //                       proceedings);
//   //
//   //                   // Clear the text fields
//   //                   dateController.clear();
//   //                   npController.clear();
//   //                 });
//   //
//   //                 // Close the dialoga
//   //                 Navigator.of(context).pop();
//   //               } else {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Fill the blanks'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //               }
//   //             },
//   //             text: 'Add Proceeding',
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   // void _editProceeding(int index) {
//   //   // Save the original values before showing the dialog
//   //   String originalDate = proceedings[index]['date'] ?? '';
//   //   String originalProceeding = proceedings[index]['proceeding'] ?? '';
//   //
//   //   // Set the initial values for the new controllers
//   //   proceedingDateController.text = originalDate.isNotEmpty
//   //       ? originalDate
//   //       : DateFormat('dd-MM-yyyy').format(DateTime.now());
//   //   proceedingDescriptionController.text = originalProceeding;
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         backgroundColor: Colors.grey[300],
//   //         title: Text(
//   //           'Edit Proceeding',
//   //           style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
//   //         ),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             // Date Input Field
//   //             TextField(
//   //               readOnly: true, // Make the date field read-only
//   //               controller: proceedingDateController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Date',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //               onTap: () async {
//   //                 // Show the date picker when the field is tapped
//   //                 DateTime? pickedDate = await showDatePicker(
//   //                   context: context,
//   //                   initialDate: proceedingDateController.text.isNotEmpty
//   //                       ? DateTime.tryParse(proceedingDateController.text) ?? DateTime.now()
//   //                       : DateTime.now(),
//   //                   firstDate: DateTime(2000),
//   //                   lastDate: DateTime(2101),
//   //                   builder: (context, child) {
//   //                     return Theme(
//   //                       data: ThemeData().copyWith(
//   //                         colorScheme: ColorScheme.dark(
//   //                           primary: Colors.grey[300]!,
//   //                           onPrimary: Colors.grey[700]!,
//   //                           surface: Colors.grey,
//   //                           onSurface: Colors.grey[700]!,
//   //                         ),
//   //                       ),
//   //                       child: child!,
//   //                     );
//   //                   },
//   //                 );
//   //
//   //                 if (pickedDate != null) {
//   //                   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//   //                   setState(() {
//   //                     proceedingDateController.text = formattedDate; // Update the text field with the selected date
//   //                   });
//   //                 } else {
//   //                   // Revert to original date if no date is picked
//   //                   setState(() {
//   //                     proceedingDateController.text = originalDate;
//   //                   });
//   //                 }
//   //               },
//   //             ),
//   //             const SizedBox(height: 10),
//   //             // Proceeding Input Field
//   //             TextField(
//   //               controller: proceedingDescriptionController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Proceeding',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           // Cancel Button
//   //           TextButton(
//   //             style: ButtonStyle(
//   //               foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
//   //               side: MaterialStateProperty.all(BorderSide(
//   //                 color: Colors.grey[600]!,
//   //                 width: 2,
//   //                 style: BorderStyle.solid,
//   //               )),
//   //             ),
//   //             onPressed: () {
//   //               // Revert field to the original values and close dialog
//   //               setState(() {
//   //                 proceedingDateController.text = originalDate; // Restore original date on cancel
//   //                 proceedingDescriptionController.text = originalProceeding; // Restore original proceeding text
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Cancel'),
//   //           ),
//   //           // Save Button
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 proceedings[index] = {
//   //                   'date': proceedingDateController.text, // Save the new date
//   //                   'proceeding': proceedingDescriptionController.text, // Save the new proceeding text
//   //                 };
//   //                 storage.write('${widget.caseData['CaseTitle']}_proceedings', proceedings);
//   //               });
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Save'),
//   //             style: ElevatedButton.styleFrom(
//   //               foregroundColor: Colors.white,
//   //               backgroundColor: Colors.black,
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   // void addCitation() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       backgroundColor: Colors.grey[300],
//   //       title: Column(
//   //         mainAxisSize: MainAxisSize.min, // Ensure dialog size is minimized
//   //         children: [
//   //           Text('Add New Citation',style: TextStyle(fontFamily: 'Eina',fontSize: 25,color: Colors.grey[600]),),
//   //           SizedBox(height: 10,),
//   //           MyTextField(
//   //             label: 'Citation',
//   //             controller: citationController,
//   //             hintText: 'Enter Citation',
//   //             obscureText: false,
//   //           ),
//   //           const SizedBox(height: 10),
//   //           // Description Input Field
//   //           SingleChildScrollView(
//   //             child: TextField(
//   //               style: TextStyle(fontFamily: 'Eina', color: Colors.grey[700]),
//   //               decoration: InputDecoration(
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 labelText: 'Description',
//   //                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//   //                 hintText: '',
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: const BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //                 hintStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //               ),
//   //               controller: descriptionController,
//   //               obscureText: false,
//   //               maxLines: 2, // Allow text to wrap
//   //               keyboardType: TextInputType.multiline, // Allow multiline input
//   //             ),
//   //           ),
//   //
//   //           SizedBox(height: 20),
//   //           // Add Button
//   //           MyButton(
//   //             ontap: () {
//   //               if (citationController.text.isNotEmpty &&
//   //                   descriptionController.text.isNotEmpty) {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Added to CaseLaw'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //
//   //                 setState(() {
//   //                   // Add new citation to the list
//   //                   citations.add({
//   //                     'citation': citationController.text,
//   //                     'description': descriptionController.text
//   //                   });
//   //
//   //                   // Save citations to GetStorage
//   //                   storage.write(
//   //                       '${widget.caseData['CaseTitle']}_citations', citations);
//   //
//   //                   // Clear the text fields
//   //                   citationController.clear();
//   //                   descriptionController.clear();
//   //                 });
//   //
//   //                 // Close the dialog
//   //                 Navigator.of(context).pop();
//   //               } else {
//   //                 final snackBar = SnackBar(
//   //                   duration: const Duration(seconds: 2),
//   //                   backgroundColor: Colors.grey[500],
//   //                   content: const Text('Fill all the blanks'),
//   //                 );
//   //                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   //               }
//   //             },
//   //             text: 'Add Citation',
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   // void _editCitation(int index) {
//   //   citationController.text = citations[index]['citation'] ?? '';
//   //   descriptionController.text = citations[index]['description'] ?? '';
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         backgroundColor: Colors.grey[300],
//   //         title: Text(
//   //           'Edit Citation',
//   //           style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
//   //         ),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             // Citation Input Field
//   //             TextField(
//   //               controller: citationController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Citation',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 10),
//   //             // Description Input Field
//   //             TextField(
//   //               controller: descriptionController,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Description',
//   //                 labelStyle: TextStyle(fontFamily: 'Eina', color: Colors.grey[500]),
//   //                 enabledBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.white),
//   //                 ),
//   //                 focusedBorder: OutlineInputBorder(
//   //                   borderRadius: BorderRadius.circular(10),
//   //                   borderSide: BorderSide(color: Colors.grey.shade400),
//   //                 ),
//   //                 fillColor: Colors.grey.shade200,
//   //                 filled: true,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           // Cancel Button
//   //           TextButton(
//   //             style: ButtonStyle(
//   //               foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
//   //               side: MaterialStateProperty.all(BorderSide(
//   //                 color: Colors.grey[600]!,
//   //                 width: 2,
//   //                 style: BorderStyle.solid,
//   //               )),
//   //             ),
//   //             onPressed: () {
//   //               Navigator.of(context).pop(); // Close the dialog
//   //             },
//   //             child: Text('Cancel'),
//   //           ),
//   //           // Save Button
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 citations[index] = {
//   //                   'citation': citationController.text, // Save the updated citation
//   //                   'description': descriptionController.text, // Save the updated description
//   //                 };
//   //                 storage.write('${widget.caseData['CaseTitle']}_citations', citations);
//   //               });
//   //               Navigator.of(context).pop(); // Close the dialog
//   //             },
//   //             child: Text('Save'),
//   //             style: ElevatedButton.styleFrom(
//   //               foregroundColor: Colors.white,
//   //               backgroundColor: Colors.black,
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//   // void _deleteCitation(int index) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         backgroundColor: Colors.grey[300],
//   //         title: Text(
//   //           'Delete Citation',
//   //           style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
//   //         ),
//   //         content: Text(
//   //           'Are you sure you want to delete this citation?',
//   //           style: TextStyle(fontFamily: 'Eina', color: Colors.grey[600]),
//   //         ),
//   //         actions: [
//   //           // Cancel Button
//   //           TextButton(
//   //             style: ButtonStyle(
//   //               foregroundColor: MaterialStateProperty.all(Colors.grey[600]),
//   //               side: MaterialStateProperty.all(BorderSide(
//   //                 color: Colors.grey[600]!,
//   //                 width: 2,
//   //                 style: BorderStyle.solid,
//   //               )),
//   //             ),
//   //             onPressed: () {
//   //               Navigator.of(context).pop(); // Close the dialog
//   //             },
//   //             child: Text('Cancel'),
//   //           ),
//   //           // Delete Button
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               setState(() {
//   //                 citations.removeAt(index); // Remove the citation from the list
//   //                 storage.write('${widget.caseData['CaseTitle']}_citations', citations);
//   //               });
//   //               Navigator.of(context).pop(); // Close the dialog
//   //             },
//   //             child: Text('Delete'),
//   //             style: ElevatedButton.styleFrom(
//   //               foregroundColor: Colors.white,
//   //               backgroundColor: Colors.black,
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // TextStyle tabTextStyle = widget.caseData['Nature'] == 'Criminal Case'
//     //     ? const TextStyle(fontSize: 10, fontFamily: 'Eina')
//     //     : const TextStyle(fontFamily: 'Eina'); // No fontSize if not a Criminal Case
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[400],
//         body: Column(
//           children: [
//             // Custom Container Header
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Wrap(
//                       spacing: 5,
//                       runSpacing: 3,
//                       children: [
//                         Text(
//                           '${widget.caseItem.casetitle}',
//                           style: TextStyle(
//                             fontFamily: 'Eina',
//                             color: Colors.grey[800],
//                             fontSize: 20,
//                           ),
//                         ),
//                         Text(
//                           '(${widget.caseItem.courtname})',
//                           style: TextStyle(
//                             fontFamily: 'Eina',
//                             color: Colors.grey[800],
//                             fontSize: 20,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 3),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 3,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             text: 'For: ', // Bold part
//                             style: TextStyle(
//                               fontFamily: 'Eina',
//                               color: Colors.grey[700],
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold, // Make 'For:' bold
//                             ),
//                             children: [
//                               TextSpan(
//                                 text:
//                                     '${widget.caseItem.casefor}', // Normal text
//                                 style: TextStyle(
//                                   fontFamily: 'Eina',
//                                   color: Colors.grey[700],
//                                   fontSize: 14,
//                                   fontWeight: FontWeight
//                                       .normal, // Regular weight for the rest of the text
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         RichText(
//                           text: TextSpan(
//                             text: 'Next Hearing: ', // Bold part
//                             style: TextStyle(
//                               fontFamily: 'Eina',
//                               color: Colors.grey[700],
//                               fontSize: 14,
//                               fontWeight:
//                                   FontWeight.bold, // Make 'Next Hearing:' bold
//                             ),
//                             children: [
//                               TextSpan(
//                                 // text: '${proceedings.isEmpty ? 'Not available' : proceedings.last['date']}',  // Normal text
//                                 style: TextStyle(
//                                   fontFamily: 'Eina',
//                                   color: Colors.grey[700],
//                                   fontSize: 14,
//                                   fontWeight: FontWeight
//                                       .normal, // Regular weight for the rest of the text
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Proceeding: ', // Bold part
//                         style: TextStyle(
//                           fontFamily: 'Eina',
//                           color: Colors.grey[700],
//                           fontSize: 14,
//                           fontWeight:
//                               FontWeight.bold, // Make 'Proceeding:' bold
//                         ),
//                         children: [
//                           TextSpan(
//                             // text: '${proceedings.isEmpty ? 'Not available' : proceedings.last['proceeding']}',  // Normal text
//                             style: TextStyle(
//                               fontFamily: 'Eina',
//                               color: Colors.grey[700],
//                               fontSize: 14,
//                               fontWeight: FontWeight
//                                   .normal, // Regular weight for the rest of the text
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Nature: ', // Bold part
//                         style: TextStyle(
//                           fontFamily: 'Eina',
//                           color: Colors.grey[700],
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold, // Make 'Nature:' bold
//                         ),
//                         children: [
//                           TextSpan(
//                             text:
//                                 '${widget.caseItem.nature?.isNotEmpty == true ? widget.caseItem.nature : widget.caseItem.selectedcasetype}',
//                             style: TextStyle(
//                               fontFamily: 'Eina',
//                               color: Colors.grey[700],
//                               fontSize: 14,
//                               fontWeight: FontWeight
//                                   .normal, // Regular weight for the rest of the text
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         text: 'Provission: ', // Bold part
//                         style: TextStyle(
//                           fontFamily: 'Eina',
//                           color: Colors.grey[700],
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold, // Make 'Nature:' bold
//                         ),
//                         children: [
//                           TextSpan(
//                             text:
//                                 '${widget.caseItem.provisions}', // Normal text
//                             style: TextStyle(
//                               fontFamily: 'Eina',
//                               color: Colors.grey[700],
//                               fontSize: 14,
//                               fontWeight: FontWeight
//                                   .normal, // Regular weight for the rest of the text
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(25),
//                             topRight: Radius.circular(25),
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             // TabBar
//                             Container(
//                               color: Colors.grey[300],
//                               child: TabBar(
//                                 controller: _tabController,
//                                 unselectedLabelColor: Colors.grey,
//                                 indicatorColor: Colors.black,
//                                 labelColor: Colors.black,
//                                 tabs: const [
//                                   Tab(text: 'Accused'),
//                                   Tab(text: 'Bail'),
//                                   Tab(text: 'Proceedings'),
//                                   Tab(text: 'Citations'),
//                                 ],
//                               ),
//                             ),
//                             // TabBarView
//                             Expanded(
//                               child: TabBarView(
//                                 controller: _tabController,
//                                 children: [
//                                   Center(child: Text('Accused Content')),
//                                   Center(child: Text('Bail Content')),
//                                   Center(child: Text('Proceedings Content')),
//                                   Center(child: Text('Citations Content')),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(25),
//                     topRight: Radius.circular(25),
//                   ),
//                 ),
//                 child: Scaffold(
//                   body: Column(
//                     children: [
//                       Container(
//                         color: Colors.grey[300],
//                         child: TabBar(
//                           unselectedLabelColor: Colors.grey,
//                           indicatorColor: Colors.black,
//                           labelColor: Colors.black,
//                           tabs: [
//                             const Tab(
//                               child: Text(
//                                 'Accused',
//                                 style:
//                                     TextStyle(fontSize: 10, fontFamily: 'Eina'),
//                               ),
//                             ),
//                             const Tab(
//                               child: Text(
//                                 'Bail',
//                                 style:
//                                     TextStyle(fontSize: 10, fontFamily: 'Eina'),
//                               ),
//                             ),
//                             Tab(
//                               child: Text(
//                                 'Proceedings',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontFamily: 'Eina',
//                                 ),
//                               ),
//                             ),
//                             Tab(
//                               child: Text(
//                                 'Citations',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontFamily: 'Eina',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 // CaseDetailModel proceeding = CaseDetailModel(
//                 //   caseId: 1,
//                 //   detailType: 'proceeding',
//                 //   proceedingData: 'Proceeding Data for Case 1',
//                 // );
//                 //
//                 // await DBHandler().insertCaseDetail(proceeding);
//                 // if (widget.caseData['Nature'] == 'Criminal Case'){
//                 //   switch (_tabController.index) {
//                 //     case 0:
//                 //       addAccused();
//                 //       break;
//                 //     case 1:
//                 //       addBailProceeding();
//                 //       break;
//                 //     case 2:
//                 //       addProceeding();
//                 //       break;
//                 //     case 3:
//                 //       addCitation();
//                 //       print('Before adding citation');
//                 //       break;
//                 //   }
//                 // }else{
//                 //   switch (_tabController.index) {
//                 //     case 0:
//                 //       addProceeding();
//                 //       break;
//                 //     case 1:
//                 //       addCitation();
//                 //       break;
//                 //   }
//                 // }
//               },
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 margin: const EdgeInsets.only(bottom: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.black,
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.add,
//                     size: 40,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
