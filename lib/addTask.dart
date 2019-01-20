import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final String gmail;
  AddTask({this.gmail});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime dateTime = DateTime.now();
  String dateText = "";
  String newTask = "";
  String newNote = "";

  Future<Null> seletDateTime(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2019),
      lastDate: DateTime(2080),
    );

    if (picked != null) {
      setState(() {
        dateTime = picked;
        dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    dateText = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  void _addData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection("task");
      await reference.add({
        "email": widget.gmail,
        "title": newTask,
        "duedate": dateTime,
        "note": newNote,
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Todo App",
                  style: TextStyle(
                    fontSize: 60.0,
                    fontFamily: 'Oxygen',
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Icon(
                    Icons.add_circle,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.view_list,
                  size: 30.0,
                ),
                hintText: "Add Todo",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Icon(Icons.calendar_today),
                ),
                Expanded(
                    child: Text(
                  "Due Date",
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
                FlatButton(
                  onPressed: () => seletDateTime(context),
                  child: Text(
                    dateText,
                    style: TextStyle(fontSize: 22.0, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  newNote = str;
                });
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.note_add,
                  size: 30.0,
                ),
                hintText: "Note",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _addData();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
