// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pricesense/screens/category_selection.dart';
import 'package:pricesense/screens/home_screen.dart';
import 'package:pricesense/utils/colors.dart';

class CollectionComplete extends StatefulWidget {
  const CollectionComplete({super.key});

  @override
  _CollectionCompleteState createState() => _CollectionCompleteState();
}

class _CollectionCompleteState extends State<CollectionComplete>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _opacityController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_opacityController);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _opacityController.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
    );
  }

  void goHome(){
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/assets/progressAnim.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
              controller: _controller,
              repeat: false,
              animate: true,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _opacityAnimation,
              child: const Text(
                'Successfully Submitted',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: goBack,
                  style: ElevatedButton.styleFrom(
                    //minimumSize: const Size(200, 45), 
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: const Size(300, 45), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                   backgroundColor:mainColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text("New Collection", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      
                       borderRadius: BorderRadius.circular(8),
                color:  Colors.white,
                border: Border.all(
                  color:primaryColor,
                  width: 1,
                ),
                    ),
                    child: ElevatedButton(
                    onPressed: goHome,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(300, 45), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text("Go Home", style: TextStyle(color:primaryColor)),
                                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
