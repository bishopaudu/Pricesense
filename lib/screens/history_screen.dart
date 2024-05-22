import 'package:flutter/material.dart';

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
        backgroundColor: Colors.teal,
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
}

