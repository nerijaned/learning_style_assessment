import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuizScreen extends StatefulWidget {
  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _newQuestion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('flashcards').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              return ListView.builder(
                itemCount: snapshot.data!.docs.length + 1,
                itemBuilder: (context, index) {
                  if (index == snapshot.data!.docs.length) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddQuestionDialog();
                        },
                        child: Text('Add Question'),
                      ),
                    );
                  }

                  DocumentSnapshot document = snapshot.data!.docs[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(document['question']),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _showEditQuestionDialog(document);
                                },
                                child: Text('Edit'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _deleteQuestion(document.id);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }

  void _showAddQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Question'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
              onSaved: (value) => _newQuestion = value!,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addQuestion(_newQuestion);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditQuestionDialog(DocumentSnapshot document) {
  String _editedQuestion = document['question'];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Question'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: _editedQuestion,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a question';
              }
              return null;
            },
            onSaved: (value) => _editedQuestion = value!,
            decoration: InputDecoration(
              labelText: 'Question',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _editQuestion(document.id, _editedQuestion);
                Navigator.of(context).pop();
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

  void _addQuestion(String question) {
    _firestore.collection('flashcards').add({'question': question});
  }

  void _editQuestion(String id, String question) {
  _firestore.collection('flashcards').doc(id).update({'question': question}).then((value) => print('Question updated'));
}

  void _deleteQuestion(String id) {
    _firestore.collection('flashcards').doc(id).delete();
  }
}