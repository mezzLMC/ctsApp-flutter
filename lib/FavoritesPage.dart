import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //ignore: unused_import
import 'package:http/http.dart' as http; //ignore: unused_import
var subColor = const Color(0xff68EDAC);
class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            SizedBox(height: 280.0),
            Text("Pas de favoris!",
                style: TextStyle(fontSize: 22, color: Colors.white)),
            Text(
                "Ajoutez des arrêts à vos favoris à l'aide d'une recherche ou dans l'onglet Horaires",
                style: TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center)
          ],
        ),
        decoration: BoxDecoration(color: Color(0xff1d1d24)));
  }
}