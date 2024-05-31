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
      "title": "Coordinator 3",
      "subtitle": "Details for Ariria Market Survey",
      "date": "2023-05-21"
    },
    {
      "title": "Coordinator 12",
      "subtitle": "Details for Itam Market Survey",
      "date": "2023-05-20"
    },
    {
      "title": "Corordinator 3",
      "subtitle": "Details for Small Market(Uyo) Survey",
      "date": "2023-05-19"
    },
    {
      "title": "Coordinator 4",
      "subtitle": "Deyails for Watt Market Survey",
      "date": "2023-05-18"
    },
    {
      "title": "Coordinator 13",
      "subtitle": "Details for West Market Survey",
      "date": "2023-05-17"
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: _filterSearchResults,
                decoration: InputDecoration(
                   focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(76, 194, 201, 1),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
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
