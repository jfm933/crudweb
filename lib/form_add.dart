import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudweb/main.dart';
import 'package:flutter/material.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  String? _date;
  String? _description;
  String? _endTime;
  bool? _isFavorite;
  String? _speaker;
  String? _startTime;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Container(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add form"),
          ),
          body: Material(
            type: MaterialType.transparency,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Date'),
                    onSaved: (value) => _date = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => _description = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'End Time'),
                    onSaved: (value) => _endTime = value,
                  ),
                  CheckboxListTile(
                    title: Text('Is Favorite'),
                    value: _isFavorite ?? false,
                    onChanged: (bool? value) =>
                        setState(() => _isFavorite = value),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Speaker'),
                    onSaved: (value) => _speaker = value,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Start Time'),
                      onSaved: (value) => _startTime = value,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      _isFavorite = _isFavorite ?? false;
                      // Save form data
                      FirebaseFirestore.instance
                          .collection('event_details')
                          .add({
                        'date': _date,
                        'description': _description,
                        'end_time': _endTime,
                        'is_favorite': _isFavorite,
                        'speaker': _speaker,
                        'start_time': _startTime,
                      });

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
