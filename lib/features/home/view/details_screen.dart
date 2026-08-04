import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                Row(
                  children: [
                    Text('Truffle Temptation Extravaganza',
                     style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
                ),
                    ),
                    Text('Truffle Temptation Extravaganza',
                     style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
                ),
                    ),
                ],
                )
              ],
              )
            ),
          ],
        ),
      ),
    );
  }
}