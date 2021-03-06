import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helper/functionsJson/functions.dart';
import 'package:helper/widgets/classPage/inputField.dart';

class ClassPage extends StatefulWidget {
  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final _classController = TextEditingController();
  final _professorController = TextEditingController();
  final _classRomController = TextEditingController();
  final _firstHourController = TextEditingController();
  final _secondHourController = TextEditingController();
  List _toDoList = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _classController.clear();

    readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["class"] = _classController.text;
      newToDo["professor"] = _professorController.text;
      newToDo["classRom"] = _classRomController.text;
      newToDo["firstHour"] = _firstHourController.text;
      newToDo["secondHour"] = _secondHourController.text;
      newToDo["absenses"] = 0;
      _toDoList.add(newToDo);
      saveData(_toDoList);
    });
  }

  void _cleanFields() {
    _classController.clear();
    _professorController.clear();
    _classRomController.clear();
    _firstHourController.clear();
    _secondHourController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Image.asset("images/logo.png"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _cleanFields();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _addToDo();
            Navigator.pop(context, _toDoList);
          }
        },
        backgroundColor: Colors.blue[600],
        child: Icon(
          Icons.save,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          children: <Widget>[
            InputField(
              hint: "Disciplina",
              icon: Icons.school,
              controller: _classController,
              message: "Informe o nome da Disciplina!",
            ),
            InputField(
              hint: "Professor",
              icon: Icons.person_outline,
              controller: _professorController,
            ),
            InputField(
              hint: "Sala",
              icon: Icons.class_,
              controller: _classRomController,
            ),
            InputField(
              hint: "1º Horário",
              icon: Icons.watch_later,
              controller: _firstHourController,
            ),
            InputField(
              hint: "2º Horário",
              icon: Icons.watch_later,
              controller: _secondHourController,
            ),
          ],
        ),
      ),
    );
  }
}
