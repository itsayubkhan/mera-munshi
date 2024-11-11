import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mera_munshi/Components/PrivacyAndPolicy.dart';
import 'package:mera_munshi/Components/ads.dart';
import 'package:mera_munshi/Controllers/homepageController.dart';
import 'package:mera_munshi/utils/DBHandler.dart';
import '../Components/CaseLaw.dart';
import '../Components/Searchbar.dart';
import '../Components/edit_case.dart';
import '../Components/mybutton.dart';
import '../Controllers/CaseController.dart';
import '../models/CaseModel.dart';
import '../utils/auth_service.dart';
import '../Navigations/animation_navigator.dart';
import 'MakeNewCauselist.dart';
import 'loginpage2.dart';

class Homepage extends StatefulWidget {
  final User? user;
  const Homepage({super.key, this.user});
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  DBHandler dbHelper = DBHandler();
  DateTime? _selectedDate;
  final CaseController caseController = Get.put(CaseController());
  final AuthService _authService = AuthService();
  final GetStorage store = GetStorage();
  DateTime? selectedDate;
  List<Map<String, dynamic>> cases = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshCase();
    print('ayub');
    _onPageFirstLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if this page is the current top page when coming back
    if (ModalRoute.of(context)!.isCurrent) {
      _onEveryPageVisit(); // This function runs every time you visit the page
    }
  }

  void _onPageFirstLoad() {
    print("Page loaded for the first time!");
    loadCases();
  }

  void _onEveryPageVisit() {
    loadCases();
    print("Page visited!");
    // Add any logic you want to run on each visit here
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


  @override
  void dispose() {
    super.dispose();
    _refreshCase();
    print('ayub');
  }

  void _refreshList() {
    setState(() {
      loadCases(); // Refresh cases from the database
      print('ayub');
    });
  }

  void _fetchCases() async {
    cases = (await DBHandler().fetchCases()).cast<Map<String, dynamic>>();
    setState(() {});
  }

  Future<void> _refreshCase() async {
    // Simulate a network call or data refresh
    await Future.delayed(const Duration(seconds: 2));
    loadCases(); // Reload cases after refresh
  }

  void loadCases() async {
    List<ModelClass> storedCases = await DBHandler().fetchCases();
    setState(() {
      cases = storedCases.map((e) => {
        'id': e.id,
        'casetitle': e.casetitle,
        'courtname': e.courtname,
        'casefor': e.casefor,
        'provisions': e.provisions,
        'selectedcasetype': e.selectedcasetype,
        'nature': e.nature,
        'cpnumber':e.cpnumber,
        // Add other properties as needed
      })
          .toList();
    });
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
                  Navigator.of(context).pop();
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

  Future<void> _pickDate(BuildContext context) async {
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

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.grey[300],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                accountName: Text(
                  '${widget.user?.displayName}',
                  style: TextStyle(fontFamily: 'Eina', color: Colors.grey[700]),
                ),
                accountEmail: Text('${widget.user?.email}',
                    style:
                    TextStyle(fontFamily: 'Eina', color: Colors.grey[700])),
                currentAccountPicture: Container(
                  height: 40, // Container height
                  width: 40, // Container width
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: widget.user?.photoURL != null
                        ? DecorationImage(
                      image: NetworkImage(widget.user?.photoURL ??
                          'https://via.placeholder.com/150'),
                      fit: BoxFit
                          .cover, // Ensures the image fits within the circle
                    )
                        : null, // No image decoration if photoURL is null
                  ),
                  child: widget.user?.photoURL == null
                      ? Icon(Icons.person,
                      size: 52,
                      color: Colors.grey[400]) // Smaller icon to fit
                      : null, // No icon if there's a photoURL
                ),
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  onTap: () {
                    _pickDate(context);
                  },
                  leading: Icon(
                    Icons.list,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Cause List',
                    style:
                    TextStyle(fontFamily: 'Eina', color: Colors.grey[700]),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  leading: widget.user?.displayName != null
                      ? const Icon(
                    Icons.logout,
                    color: Colors.grey,
                  )
                      : const Icon(
                    Icons.login,
                    color: Colors.grey,
                  ),
                  title: widget.user?.displayName != null
                      ? Text(
                    'log out',
                    style: TextStyle(
                        fontFamily: 'Eina', color: Colors.grey[700]),
                  )
                      : Text(
                    'log in',
                    style: TextStyle(
                        fontFamily: 'Eina', color: Colors.grey[700]),
                  ),
                  onTap: () async {
                    if (widget.user?.photoURL != null) {
                      bool? shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[300],
                            title: const Text(
                              'Log out',
                              style: TextStyle(fontFamily: 'Eina'),
                            ),
                            content: const Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(fontFamily: 'Eina'),
                            ),
                            actions: <Widget>[
                              MyButton(
                                ontap: () {
                                  Navigator.of(context).pop(true);
                                },
                                text: 'Log out',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyButton(
                                ontap: () {
                                  Navigator.of(context).pop(false);
                                },
                                text: 'Cancel',
                              ),
                            ],
                          );
                        },
                      );

                      // If the user confirmed, proceed with sign-out
                      if (shouldLogout == true) {
                        await _authService
                            .signOut(); // Call the sign-out method
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  loginpage2()), // Navigate to login page after sign-out
                        );
                      }
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                loginpage2()), // Navigate to login page after sign-out
                      );
                    }
                  },
                ),
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.grey[200],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.health_and_safety_sharp,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Privacy and Policy',
                    style:
                    TextStyle(fontFamily: 'Eina', color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      height: 40, // Increased size for better visibility
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        image: widget.user?.photoURL != null
                            ? DecorationImage(
                          image: NetworkImage(widget.user?.photoURL ??
                              'https://via.placeholder.com/150'),
                          fit: BoxFit
                              .cover, // Ensures the image fits within the circle
                        )
                            : null,
                      ),
                      child: widget.user?.photoURL == null
                          ? Icon(Icons.person,
                          size: 28,
                          color: Colors.grey[400]) // Smaller icon to fit
                          : null,
                    ),
                  ),
                ),
          ),
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () async {
                  // Navigate to SearchPage and wait for the result
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );

                  if (result != null) {
                    print('Selected case: $result');
                  }
                },
                icon: Icon(Icons.search, color: Colors.grey[700], size: 25),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[400],
          foregroundColor: Colors.white,
          title: Text(
            'Mera Munshi',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'Eina',
              color: Colors.grey[600],
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.grey[700],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            displacement: 5,
            edgeOffset: 15,
            backgroundColor: Colors.grey[400],
            color: Colors.grey[700],
            key: _refreshIndicatorKey,
            onRefresh: _refreshCase,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FutureBuilder<List<ModelClass>>(
                  future: DBHandler().fetchCases(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ModelClass>> snapshot) {
                    // 1. Handle loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // 2. Handle error state
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // 3. Handle data state
                    if (snapshot.hasData) {
                      final cases = snapshot.data!;
                      if (cases.isEmpty) {
                        return Center(child: Text('No cases found',
                          style: TextStyle(
                              fontFamily: 'Eina', color: Colors.grey[700]),));
                      }

                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 50),
                        itemCount: cases.length,
                        itemBuilder: (context, index) {
                          final caseItem = cases[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: ListTile(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CaseDetailsPage(
                                              caseItem: caseItem,),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    caseItem.casetitle,
                                    style: TextStyle(
                                      fontFamily: 'Eina',
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  subtitle: Text(
                                    '(${caseItem.courtname})',
                                    style: TextStyle(
                                      fontFamily: 'Eina',
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon:
                                        Icon(Icons.edit, color: Colors.grey),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditCasePage(
                                                      caseItem: caseItem),
                                            ),
                                          ).then((shouldReload) {
                                            if (shouldReload == true) {
                                              loadCases(); // Reload cases if the data was updated
                                            }
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.grey),
                                        onPressed: () =>
                                            deleteCase(context, caseItem.id!),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    // 6. Handle the case where snapshot.hasData is false
                    return Center(child: Text('No data available'));
                  },
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _pickDate(context);
                    dbHelper.dbpath();
                  },
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[500],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    // Navigate to MakeCauseList and wait for the result
                    bool? shouldReload =
                    await NavigationHelper.navigateWithEaseIn(
                        context,
                        MakeCauseList(
                          index: -1,
                          refresh: (){
                            _refreshCase();
                          },
                        ));
                    if (shouldReload == true) {
                      loadCases();
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(
                        bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


