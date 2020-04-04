import 'package:covid19/screens/summary_screen.dart';
import 'package:covid19/screens/test.dart';
import 'package:flutter/material.dart'; 


void main() => runApp(MyApp()); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Covid-19",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, 
        primaryColor: Colors.purple[800],
        accentColor: Colors.cyan[600]
      ),
      initialRoute: SummaryScreen.id,
      routes: {
        SummaryScreen.id: (context) => SummaryScreen(), 
        Test.id: (context) => Test(),
      },
    );
  }
  
}
