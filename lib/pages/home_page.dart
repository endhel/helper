import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:helper/animations/growTransition.dart';
import 'package:helper/functionsJson/functions.dart';
import 'package:helper/pages/class_info_page.dart';
import 'package:helper/pages/class_page.dart';
import 'package:helper/widgets/homePage/emptyList.widget.dart';
import 'package:helper/widgets/homePage/information.widget.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;
  List _toDoList = [];
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _changeStatusBar();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.elasticOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          controller.reverse();
        else if (status == AnimationStatus.dismissed) controller.forward();
      });

    controller.forward();

    readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Image.asset(
            "images/logo.png",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showClassPage();
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "images/background.jpg",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: _toDoList.isEmpty
            ? GrowTransition(
                child: EmptyList(),
                animation: animation,
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 100.0),
                itemBuilder: _buildItem,
                itemCount: _toDoList.length,
              ),
      ),
    );
  }

  Widget _buildItem(context, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassInfoPage(
              toDoClass: _toDoList[index],
              toDoList: _toDoList,
              index: index,
            ),
          ),
        );
      },
      child: Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red.withOpacity(0.8),
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red.withOpacity(0.8),
          child: Align(
            alignment: Alignment(0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        direction: DismissDirection.horizontal,
        child: Card(
          elevation: 0.0,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Information(
                  info: _toDoList[index]["class"],
                  color: Colors.green,
                  icon: Icons.school,
                  isClassField: true,
                ),
                Information(
                  info: _toDoList[index]["professor"] != ""
                      ? _toDoList[index]["professor"]
                      : "--",
                  color: Colors.red,
                  icon: Icons.person_pin,
                  isClassField: false,
                ),
                Information(
                  info: _toDoList[index]["classRom"] != ""
                      ? _toDoList[index]["classRom"]
                      : "--",
                  color: Colors.yellow,
                  icon: Icons.class_,
                  isClassField: false,
                ),
                Information(
                  info: _toDoList[index]["firstHour"] != ""
                      ? _toDoList[index]["firstHour"]
                      : "--",
                  color: Colors.black,
                  icon: Icons.watch_later,
                  isClassField: false,
                ),
                Information(
                  info: _toDoList[index]["secondHour"] != ""
                      ? _toDoList[index]["secondHour"]
                      : "--",
                  color: Colors.purple,
                  icon: Icons.watch_later,
                  isClassField: false,
                ),
              ],
            ),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _lastRemoved = Map.from(_toDoList[index]);
            _lastRemovedPos = index;
            _toDoList.removeAt(index);

            saveData(_toDoList);

            final snack = SnackBar(
              content:
                  Text("Disciplina \"${_lastRemoved['class']}\" removida!"),
              action: SnackBarAction(
                label: "Desfazer",
                textColor: Colors.blue[800],
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    saveData(_toDoList);
                  });
                },
              ),
              duration: Duration(seconds: 2),
            );

            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(snack);
          });
        },
      ),
    );
  }

  void _showClassPage() async {
    final recList = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassPage()),
    );

    if (recList != null) _toDoList = recList;
  }
}
