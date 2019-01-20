import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  final String gmail, note, title;
  final index;
  final DateTime dueDate;
  EditTask({this.gmail, this.note, this.title, this.dueDate, this.index});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  DateTime dateTime = DateTime.now();
  String dateText = "";
  String newTask;
  String newNote;

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
    dateTime = widget.dueDate;

    controller1 = TextEditingController(text: widget.title);
    controller2 = TextEditingController(text: widget.note);

    newTask = widget.title;
    newNote = widget.note;
  }

  void _updateData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
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
                    Icons.edit,
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
              controller: controller1,
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
                hintText: "Edit Todo",
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
              controller: controller2,
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
                    _updateData();
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
