import 'package:flutter/material.dart';
import 'package:mera_munshi/Components/ads.dart';
import 'package:mera_munshi/utils/DBHandler.dart';
import '../models/CaseModel.dart'; // Adjust this to your actual model file

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<ModelClass> filteredCases = []; // Ensure this is of type ModelClass
  DBHandler dbHelper = DBHandler();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
    _fetchCases();
    searchController.addListener(_filterCases);
  }

  // Fetch all cases from the database
  Future<void> _fetchCases() async {
    List<ModelClass> cases = await dbHelper.fetchCases(); // Ensure this returns List<ModelClass>
    setState(() {
      filteredCases = cases; // Store the fetched cases
    });
  }

  void _filterCases() async {
    String query = searchController.text;
    if (query.isEmpty) {
      _fetchCases(); // Reset to all cases if the query is empty
    } else {
      List<ModelClass> cases = await dbHelper.searchCases(query); // Ensure this returns List<ModelClass>
      setState(() {
        filteredCases = cases; // Directly assign the filtered cases
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: TextField(
          focusNode: searchFocusNode,
          style: TextStyle(fontFamily: 'Eina',color: Colors.grey[600]),
          controller: searchController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[400]!
              )
            ),
              prefixIcon: Icon(Icons.search,color: Colors.grey[600],),
              hintText: 'search...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none
          ),
        ),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[400],
      ),
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
            itemCount: filteredCases.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredCases[index].casetitle), // Use the property from ModelClass
                subtitle: Text(filteredCases[index].courtname),
                trailing: Text(filteredCases[index].cpnumber!),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CaseDetailsPage(caseItem: filteredCases[index]),));
                },// Use the property from ModelClass
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ),
    );
  }
}
