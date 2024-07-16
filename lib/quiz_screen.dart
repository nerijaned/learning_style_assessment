import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with RouteAware {

  List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    _getFlashcards();
  }
  _getFlashcards() async {
    final flashcardsRef = _firestore.collection('flashcards');
    final querySnapshot = await flashcardsRef.get();
    setState(() {
      _flashcards = querySnapshot.docs.map((doc) => Flashcard(
        question: doc['question'],
        applies: false,
      )).toList();
    });
  }

  @override
  void didPush() {
    _currentIndex = 0; 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _flashcards.isEmpty
       ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Hang tight, retrieving quiz questions...'),
            ],
          ),
        )
        : Column(
          children: [
            Text(
              _flashcards[_currentIndex].question,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _flashcards[_currentIndex].applies = true;
                      if (_currentIndex >= _flashcards.length -1) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ResultsScreen(_flashcards)), 
                          (Route<dynamic> route) => false
                          );
                      }else{
                        _currentIndex++;
                      }
                    });
                  },
                  child: Text('Applies to me'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _flashcards[_currentIndex].applies = false;                      
                      if (_currentIndex >= _flashcards.length -1) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ResultsScreen(_flashcards)), 
                          (Route<dynamic> route) => false
                          );
                      }else{
                        _currentIndex++;
                      }
                    });
                  },
                  child: Text('Does not apply to me'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Flashcard {
  String question;
  bool applies;

  Flashcard({required this.question, this.applies = false});
}