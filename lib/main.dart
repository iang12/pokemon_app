import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';
import 'package:meetup_rest_apis/splash.dart';
import 'model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeDeck listaPokemons;
  @override
  void initState() {
    super.initState();
    buscarPokemons();
  }

  buscarPokemons() async {
    http.Response response = await http.get(
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json');
    var decodedJson = jsonDecode(response.body);
    listaPokemons = PokeDeck.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Pokemon Deck"),
        backgroundColor: Colors.redAccent,
        leading: Icon(Icons.menu),
      ),
      body: listaPokemons == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: listaPokemons.pokemon
                  .map(
                    (poke) => Padding(
                        padding: EdgeInsets.all(2.0),
                        child: gridViewPokemons(poke)),
                  )
                  .toList(),
            ),
    );
  }

  gridViewPokemons(Pokemon poke) {
    return Card(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(poke.img),
              )),
            ),
            Text(
              poke.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
    );
  }
}
