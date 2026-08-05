import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzaria_app/components/macro.dart';

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Truffle Temptation Extravaganza',
                         style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold
                                        ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: 
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                              '\$12,00',
                               style: TextStyle(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              ),
                              ),
                              Text(
                              '\$15,00',
                               style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  ),
                  SizedBox(height: 12,),
                  Row(
                    children: [
                      MyMacroWidget(),
                      SizedBox(width: 10,),
                      MyMacroWidget(),
                      SizedBox(width: 10,),
                      MyMacroWidget(),
                      SizedBox(width: 10,),
                      MyMacroWidget(),
                  ],
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}