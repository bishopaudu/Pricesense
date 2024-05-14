import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricesense/components/summary.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> gridItems = [
    Summary(),
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "15",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade200,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Commodities Data',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(child: Text("Item 3")),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Center(child: Text("Item 4")),
    ),
    // Add more grid items as needed
  ];

  Future<void> _refreshGrid() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Update the grid items or fetch new data here
      gridItems.shuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "AGENT NAME",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AgentDetails()));
          },
          icon:  Icon(Icons.supervised_user_circle, size: 35, color: Colors.teal.shade200),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon:  Icon(Icons.notifications, size: 35, color: Colors.teal.shade200),
          ),
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade200, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark, // Ensure the status bar text is dark
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade200,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CollectionScreen()),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.place, color: Colors.teal.shade200),
                    SizedBox(width: 8),
                    Text(
                      "UYO, AKWA IBOM STATE, NIGERIA",
                      style: TextStyle(fontSize: 16, color: Colors.black87)
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("AGENT ID: ",style: TextStyle(fontSize: 16, color: Colors.black87)),
                    Text("74838939944",style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: _refreshGrid,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) {
                    return gridItems[index];
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



