import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudweb/main.dart';
import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
  final String? documentID;
  const EditForm({required this.documentID, super.key});

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
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
      home: Scaffold(
        appBar: AppBar(
          title: Text("Edit Form"),
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
                  onPressed: () async {
                    _formKey.currentState?.save();
                    _isFavorite = _isFavorite ?? false;
                    // Save form data
                    await FirebaseFirestore.instance
                        .collection('event_details')
                        .doc(widget.documentID)
                        .update({
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
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
