import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<Flashcard> _flashcards;

  ResultsScreen(this._flashcards);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You answered ${_getAppliesCount()} questions as "Applies to me" and ${_getDoesNotApplyCount()} questions as "Does not apply to me".',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Add some space between the text and the button
            ElevatedButton(
                child: Text('Go to Home'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Assuming HomeScreen is your home screen
                    (Route<dynamic> route) => false,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  int _getAppliesCount() {
    return _flashcards.where((flashcard) => flashcard.applies).length;
  }

  int _getDoesNotApplyCount() {
    return _flashcards.where((flashcard) =>!flashcard.applies).length;
  }
}