import 'package:flutter/material.dart';
import 'package:votacao_mobile/pages/candidate_page.dart';
import 'package:votacao_mobile/pages/voting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'candidates',
      routes: {
        'candidates': (context) => const CandidatePage(),
        'voting': (context) => const VotingPage()
      },
    );
  }
}
