import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http; //ignore: unused_import
import 'dart:convert'; //ignore: unused_import
import 'dart:async'; //ignore: unused_import
import 'dart:io'; //ignore: unused_import

var subColor = const Color(0xff68EDAC);

class OccurenceListView extends StatefulWidget {
  final String arretData;
  const OccurenceListView ({ Key key, this.arretData }): super(key: key);
  _OccurenceListViewState createState() => _OccurenceListViewState();
}

class _OccurenceListViewState extends State<OccurenceListView> {
  
  List<Widget> occurrence = [
    Text("pute")
  ]; 
  
  Widget build(BuildContext context, ) {

    rootBundle.loadString("assets/StopNames.json").then((value){
      var json = jsonDecode(value);
      var stopNames = json.keys.toList();
      for(var arret in stopNames){
        occurrence.add(arret);
      }
    });

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: occurrence,
    );
  }
}

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() => SchedulePageState();
}

  final arretData = TextEditingController();

class SchedulePageState extends State<SchedulePage> {
  var background = const Color(0xff22222D);
  var now = new DateTime.now();
  final data = {};
  final minutesData = TextEditingController();
  final heuresData = TextEditingController();
  var bottomBorder = new Border(
      top: BorderSide(width: 0.0, color: Colors.transparent),
      left: BorderSide(width: 0.0, color: Colors.transparent),
      right: BorderSide(width: 0.0, color: Colors.transparent),
      bottom: BorderSide(width: 3.0, color: subColor));

  List<Widget> occurrence = [
  ]; 

  var occurenceList;
  //rootBundle.loadString("StopNames.json")
  _onValidation() {
    rootBundle.loadString("assets/StopNames.json")
    .then((value) {
      var json = jsonDecode(value); 
      var l = json.keys.toList();
      for (var prop in l) { 
      occurrence.add(Text(prop));
   }
   setState(() {
     occurenceList = ListView(
      shrinkWrap: true,
      children: occurrence,
    );
   });
   l = occurrence.toString();
   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text("My title"),content: Text(l),);
      },
    );
    });
  }

  void _onSearch() {
    setState(() {
      isSearching = false;
    });
  }

  void _noSearch(String str) {
    setState(() {
      isSearching = true;
    });
  }

  bool isSearching = false;

  Widget build(BuildContext context) {
    arretData.addListener(_onValidation);
    var arretLabel = Text("choisir un arrêt:",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 20.0, color: Colors.white));
    var arretInput = Expanded(
        child: Container(
      decoration: BoxDecoration(border: bottomBorder),
      child: TextField(
        controller: arretData,
        onTap: _onSearch,
        onSubmitted: _noSearch,
        decoration: InputDecoration(
            hintText: "Entrez une arrêt...",
            hintStyle: TextStyle(color: Colors.white)),
        style: TextStyle(fontSize: 20.0),
        textAlign: TextAlign.left,
      ),
    ));

    var hour = now.hour.toString();
    var minutes = now.minute.toString();
    if (minutes.length != 2) {
      minutes = "0" + minutes;
    }
    if (hour.length != 2) {
      hour = "0" + hour;
    }

    var hourInput = Expanded(
        child: Container(
      decoration: BoxDecoration(border: bottomBorder),
      child: TextField(
        controller: heuresData,
        decoration: InputDecoration(
            hintText: hour, hintStyle: TextStyle(color: Colors.white)),
        style: TextStyle(fontSize: 35.0),
        textAlign: TextAlign.center,
      ),
    ));

    var doublePoint = Container(
        child:
            Text(":", style: TextStyle(fontSize: 35.0, color: Colors.white)));

    var minutInput = Expanded(
        child: Container(
      decoration: BoxDecoration(border: bottomBorder),
      child: TextField(
          controller: minutesData,
          decoration: InputDecoration(
              hintText: minutes, hintStyle: TextStyle(color: Colors.white)),
          style: TextStyle(fontSize: 35.0),
          textAlign: TextAlign.center),
    ));

    var validerButton = RaisedButton(
        onPressed: _onValidation,
        color: subColor,
        child: Container(
            child: Text("Valider",
                style: TextStyle(fontSize: 30.0, color: Colors.white))));

    return Container(
      decoration: BoxDecoration(color: Color(0xff1d1d24)),
      child: Column(children: [
        Visibility(child: SizedBox(height: 20.0),visible: isSearching,),
        Visibility(child: Row(children: [SizedBox(width: 10.0), arretLabel]),visible: isSearching,),
        Row(children: [SizedBox(height: 15.0)]),
        Row(children: [SizedBox(width: 15.0),arretInput,SizedBox(width: 15.0)]),
        Visibility(child: OccurenceListView(arretData: "Elm"),visible: !isSearching),
        Row(children: [SizedBox(height: 100.0)]),
        Visibility(
            visible: isSearching,
            child: Row(children: [
              SizedBox(width: 80.0),
              hourInput,
              SizedBox(width: 20.0),
              doublePoint,
              SizedBox(width: 20.0),
              minutInput,
              SizedBox(width: 80.0)
            ])),
        Visibility(
          child: SizedBox(height: 30.0),
          visible: isSearching,
        ),
        Visibility(
          child: validerButton,
          visible: !isSearching,
        ),
      ]),
    );
  }
}
/*
TODO
import stopNames
  string de fdp?
  Future de fdp?
scrollList/list view 
stopNames: includes arretData? => newList






showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text("My title"),content: Text(l),);
      },
    );
*/
