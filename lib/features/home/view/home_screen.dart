import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children:[
            Image.asset(
              'assets/8.png',
              scale: 14,
              ),
              SizedBox(width: 5,),
            Text(
              'PIZZA',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30, 
              ),
            ),
          ]
        ),
        actions:[
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ]
      ),
    );
  }
}

