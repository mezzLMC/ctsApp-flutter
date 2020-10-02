import 'package:flutter/material.dart'; //ignore: unused_import
import 'package:flutter/services.dart' show rootBundle; //ignore: unused_import
import 'package:http/http.dart' as http; //ignore: unused_import
//import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert'; //ignore: unused_import
import 'dart:async'; //ignore: unused_import
import 'dart:io'; //ignore: unused_import

String token = "14df45e6-40b1-4d94-bce2-0535fcdb1c42";

String capitalize(str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
}

String formatTime(hours, minutes) {
  var now = new DateTime.now();
  var date = now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString();
  String str;
  str = date + "T" + hours + "%3A" + minutes + "%3A00%2B01%3A00";
  return str;
}                                                                               


class Minutes {
  String build() {
    var minutes = new DateTime.now().minute.toString();
    if (minutes.length != 2) {
      minutes = "0" + minutes;
    }
    return minutes;
  }
}

class Hours {
  String build() {
    var heure = new DateTime.now().hour.toString();
    if (heure.length != 2) {
      heure = "0" + heure;
    }
    return heure;
  }
}

var subColor = const Color(0xff68EDAC);

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  FocusNode arretInputFocus;
  bool isSearching = true;
  bool isfocusable = true;
  var occurenceList = [];
  var hour = Hours().build();
  var minutes = Minutes().build();
  var background = const Color(0xff22222D);
  var now = new DateTime.now();
  final data = {};
  final minutesData = TextEditingController();
  final heuresData = TextEditingController();
  final arretData = TextEditingController();
  var bottomBorder = new Border(
      top: BorderSide(width: 0.0, color: Colors.transparent),
      left: BorderSide(width: 0.0, color: Colors.transparent),
      right: BorderSide(width: 0.0, color: Colors.transparent),
      bottom: BorderSide(width: 3.0, color: subColor));

  var arretLabel = Text("choisir un arrêt:",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 20.0, color: Colors.white));

  void initState() {
    super.initState();
    arretInputFocus = FocusNode();
  }

  _onValidation() {
    String choosenHour;
    String choosenMinute;
    String arret = arretData.text;
    if (heuresData.text != "") {
      choosenHour = heuresData.text;
    } else {
      choosenHour = hour;
    }
    if (minutesData.text != "") {
      choosenMinute = minutesData.text;
    } else {
      choosenMinute = minutes;
    }
    rootBundle.loadString("assets/StopNames.json").then((value) {
      var json = jsonDecode(value);
      var stopCode = json[arret];
      var time = formatTime(choosenHour, choosenMinute);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(time),
              content: Text(stopCode.toString()),
            );
          },
        );
      String link = "https://api.cts-strasbourg.eu/v1/siri/2.0/stop-monitoring?MonitoringRef="+stopCode+"&MonitoringRef=&StartTime="+time;
      http.get(link,headers:{HttpHeaders.authorizationHeader: "Basic MTRkZjQ1ZTYtNDBiMS00ZDk0LWJjZTItMDUzNWZjZGIxYzQy"}).then((response) {
      print(response.body);
      });
    });
  }

  _onStopNameUpdate() {
    List newL = [];
    rootBundle.loadString("assets/StopNames.json").then((value) {
      var json = jsonDecode(value);
      var l = json.keys.toList();
      for (var prop in l) {
        if (prop.contains(arretData.text)) {
          newL.add(prop);
        }
      }
      setState(() {
        occurenceList = newL;
      });
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
  Widget build(BuildContext context) {
    arretData.addListener(_onStopNameUpdate);
    var arretInput = Expanded(child: Container(decoration: BoxDecoration(border: bottomBorder),
          child: TextField(
              controller: arretData,
              focusNode: arretInputFocus,
              onTap: _onSearch,
              onSubmitted: _noSearch,
              decoration: InputDecoration(hintText: "Entrez une arrêt...",hintStyle: TextStyle(color: Colors.white)),
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.left,
            )));

    var hourInput = Expanded(
        child: Container(decoration: BoxDecoration(border: bottomBorder),
            child: TextField(
              controller: heuresData,
              decoration: InputDecoration(hintText: hour, hintStyle: TextStyle(color: Colors.white)),
              style: TextStyle(fontSize: 35.0, color: Colors.white),
              textAlign: TextAlign.center,
            )));

    var doublePoint = Container(child:Text(":", style: TextStyle(fontSize: 35.0, color: Colors.white)));

    var minutInput = Expanded(child: Container(decoration: BoxDecoration(border: bottomBorder),
      child: TextField(
          controller: minutesData,
          decoration: InputDecoration(hintText: minutes, hintStyle: TextStyle(color: Colors.white)),
          style: TextStyle(fontSize: 35.0),
          textAlign: TextAlign.center),
    ));

    var validerButton = RaisedButton(
        onPressed: _onValidation,
        color: subColor,
        child: Container(child: Text("Valider",style: TextStyle(fontSize: 30.0, color: Colors.white))
    ));

    var occurenceWidget = ListView.builder(
      itemCount: occurenceList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => RaisedButton(child: Text(occurenceList[index],style: TextStyle(color: Colors.white, backgroundColor: background)),
        onPressed: () {
          arretData.text = occurenceList[index];
          arretInputFocus.unfocus();
          _noSearch("");
        },
      ),
    );

    var menu = Container(
      decoration: BoxDecoration(color: Color(0xff1d1d24)),
      child: Column(children: [
        Visibility(child: SizedBox(height: 20.0), visible: isSearching),
        Visibility(child: Row(children: [SizedBox(width: 10.0), arretLabel]),visible: isSearching),
        Row(children: [SizedBox(height: 15.0)]),
        Row(children: [SizedBox(width: 15.0),arretInput,SizedBox(width: 15.0)]),
        Visibility(child: Expanded(child: occurenceWidget), visible: !isSearching),
        Row(children: [SizedBox(height: 100.0)]),
        Visibility(visible: isSearching,child: Row(children: [SizedBox(width: 80.0), hourInput,SizedBox(width: 20.0),doublePoint,SizedBox(width: 20.0),minutInput,SizedBox(width: 80.0)])),
        Visibility(child: SizedBox(height: 30.0), visible: isSearching),
        Visibility(child: validerButton, visible: isSearching),
      ]),
    );
    var result = ListView.builder(
      itemCount: occurenceList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => RaisedButton(child: Text(occurenceList[index],style: TextStyle(color: Colors.white, backgroundColor: background)),
        onPressed: () {
          arretData.text = occurenceList[index];
          arretInputFocus.unfocus();
          _noSearch("");
        },
      ),
    );

    return menu;
  }
}
/*
showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text("My title"),content: Text(l),);
      },
    );
*/
