import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}
late AnimationController controller;
late Animation animation;
late Animation colorAnimation;

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    colorAnimation = ColorTween(begin: Colors.white, end: Colors.red).animate(controller);
    animation = Tween<double>(begin: 70, end: 140).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));


    controller.addStatusListener((status) {
      if(status == AnimationStatus.forward){
        setState(() => isExpanded = true);
      }
      if(status == AnimationStatus.reverse){
        setState(() => isExpanded = false);
      }
    });
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Test'),
      ),
      body: Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, widget){
              return InkWell(
                onTap: (){
                  isExpanded ? controller.reverse() : controller.forward();
                },
                child: Container(
                  width: animation.value,
                  height: animation.value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colorAnimation.value
                  ),
                ),
              );
            },
          ),
      ),
    );
  }
}
