import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizzaria_app/features/auth/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizzaria_app/features/home/view/details_screen.dart';


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
              SizedBox(width: 8,),
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
            onPressed: () {

            },
            icon: Icon(CupertinoIcons.cart),
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 9/16,
          ),
          itemCount: 8,
          itemBuilder: (context, int i ) {
            return Material(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap:() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailsScreen(),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/1.png',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:4, horizontal: 8),
                              child: Text(
                              "NOM-VEG",
                              style: TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              )
                              ),
                            )
                          ),
                          const SizedBox(width: 8,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:4, horizontal: 8),
                              child: Text(
                              "🌶️BALANCE",
                              style: TextStyle(
                                color:Colors.green,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              )
                              ),
                            )
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Cheesy Marvel",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Crafting joy: your pizza, your rules, best taste!",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                            "\$12.99",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                            const SizedBox(width: 5,),
                            Text(
                            "\$15.00",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.lineThrough,
                                ),
                              ),                        
                            ],
                          ),
                          IconButton (
                            onPressed: () {},
                            icon: Icon(CupertinoIcons.add_circled_solid),
                          )
                        ],
                      )
                    )
                  ]
                ),
              ),
            );
          }
        ),
      )
    );
  }
}

