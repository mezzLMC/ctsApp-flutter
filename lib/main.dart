import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:http/http.dart' as http;
import 'SchedulePage.dart';
import 'FavoritesPage.dart';

void main() => runApp(MyApp());
var subColor = const Color(0xff68EDAC); 

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

double getWidth(context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}

double getHeight(context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var background = const Color(0xff1d1d24);
  static List<Widget> _widgetOptions = <Widget>[
    FavoritesPage(),
    SchedulePage(),
    Container(color: Color(0xff1d1d24))
  ];
  static List _moreOptions = [
    {"gérer favoris","","paramètres"},
    {"diff. heure","","paramètres"},
    {"changer domicile","","paramètres"},
  ];

  static List names = ["Favoris", "Horaires", "Chemin"];
  static List appBarNames = ["Favoris", "Horaires", "Chemin"];
  static List titleList = [
    Container(height: 0.0),
    Text(names[1], style: TextStyle(color: Colors.white)),
    Text(names[2], style: TextStyle(color: Colors.white))
  ];

  static List iconSize = [34.0, 24.0, 24.0];
  static List icons = [
    Icon(Icons.star, size: iconSize[0], color: Colors.white),
    Icon(Icons.access_time, size: iconSize[1], color: Colors.white),
    Icon(Icons.merge_type, size: iconSize[2], color: Colors.white)
  ];

  void _onItemTapped(int index) {
    setState(() {
      names = ["Favoris", "Horaires", "Chemin"];

      iconSize = [24.0, 24.0, 24.0];
      iconSize[index] = 34.0;
      names[index] = "";
      titleList = [
        Text(names[0], style: TextStyle(color: Colors.white)),
        Text(names[1], style: TextStyle(color: Colors.white)),
        Text(names[2], style: TextStyle(color: Colors.white))
      ];
      titleList[index] = Container(height: 0.0);
      icons = [
        Icon(Icons.star, size: iconSize[0], color: Colors.white),
        Icon(Icons.access_time, size: iconSize[1], color: Colors.white),
        Icon(Icons.merge_type, size: iconSize[2], color: Colors.white)
      ];
      _selectedIndex = index;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onOptionChoosed(String index) {
    _showMyDialog();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(appBarNames.elementAt(_selectedIndex),
            textAlign: TextAlign.left),
        backgroundColor: Color(0xff131317),
        actions: [
          //Icon(Icons.star, color: Colors.white),
          //Icon(Icons.more_vert, color: Colors.white),
          PopupMenuButton<String>(
            onSelected: _onOptionChoosed,
            itemBuilder: (BuildContext context) {
              return _moreOptions.elementAt(_selectedIndex).map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: icons[0], title: titleList[0]),
          BottomNavigationBarItem(icon: icons[1], title: titleList[1]),
          BottomNavigationBarItem(icon: icons[2], title: titleList[2]),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xff131317),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: MyHomePage(),
    );
  }
}
