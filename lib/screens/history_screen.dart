// ignore_for_file: library_private_types_in_public_api

/*import 'package:flutter/material.dart';
import 'package:pricesense/screens/home_screen.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final searchController = TextEditingController();

  final List<Map<String, String>> dummyData = List.generate(
    20,
    (index) => {
      "title": "Item $index",
      "subtitle": "Details for item $index",
      "date": "2023-05-21"
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        elevation: 0,
        backgroundColor:  Color.fromRGBO(76, 194, 201, 1),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(76, 194, 201, 1),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color:  Color.fromRGBO(76, 194, 201, 1)),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(Icons.cancel, color:  Color.fromRGBO(76, 194, 201, 1)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyData.length,
              itemBuilder: (context, index) {
                final item = dummyData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade200,
                    child: Text(
                      item['title']!.substring(0, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(item['title']!),
                  subtitle: Text(item['subtitle']!),
                  trailing: Text(item['date']!),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:pricesense/screens/details.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> surveyHistory = [
    {
      "title": "Survey 1",
      "subtitle": "Details for survey 1",
      "date": "2023-05-21"
    },
    {
      "title": "Survey 2",
      "subtitle": "Details for survey 2",
      "date": "2023-05-20"
    },
    {
      "title": "Survey 3",
      "subtitle": "Details for survey 3",
      "date": "2023-05-19"
    },
    {
      "title": "Survey 4",
      "subtitle": "Details for survey 4",
      "date": "2023-05-18"
    },
    {
      "title": "Survey 5",
      "subtitle": "Details for survey 5",
      "date": "2023-05-17"
    },
    {
      "title": "Survey 6",
      "subtitle": "Details for survey 6",
      "date": "2023-05-16"
    },
    {
      "title": "Survey 7",
      "subtitle": "Details for survey 7",
      "date": "2023-05-15"
    },
    {
      "title": "Survey 8",
      "subtitle": "Details for survey 8",
      "date": "2023-05-14"
    },
    {
      "title": "Survey 9",
      "subtitle": "Details for survey 9",
      "date": "2023-05-13"
    },
    {
      "title": "Survey 10",
      "subtitle": "Details for survey 10",
      "date": "2023-05-12"
    },
    {
      "title": "Survey 11",
      "subtitle": "Details for survey 11",
      "date": "2023-05-11"
    },
    {
      "title": "Survey 12",
      "subtitle": "Details for survey 12",
      "date": "2023-05-10"
    },
  ];

  late List<Map<String, String>> filteredSurveyHistory;

  @override
  void initState() {
    super.initState();
    filteredSurveyHistory = surveyHistory;
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSurveyHistory = surveyHistory;
      });
      return;
    }
    

    List<Map<String, String>> filteredList = surveyHistory
        .where((survey) =>
            survey['title']!.toLowerCase().contains(query.toLowerCase()) ||
            survey['subtitle']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredSurveyHistory = filteredList;
    });
  }
  Future<void> refreshPage() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
       /* actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],*/
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(76, 194, 201, 1),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  
                ),
                hintText: "Search",
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromRGBO(76, 194, 201, 1),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    _filterSearchResults('');
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Color.fromRGBO(76, 194, 201, 1),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSurveyHistory.length,
              itemBuilder: (context, index) {
                final item = filteredSurveyHistory[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade200,
                    child: Text(
                      item['title']!.substring(0, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(item['title']!),
                  subtitle: Text(item['subtitle']!),
                  trailing: Text(item['date']!),
                  onTap: () {
                    // Handle item tap
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
