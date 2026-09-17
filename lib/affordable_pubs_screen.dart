import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/pubs.dart';
import 'pub_card.dart';

class AffordablePubsScreen extends StatefulWidget {
  const AffordablePubsScreen({super.key});

  @override
  _AffordablePubsScreenState createState() {
    return _AffordablePubsScreenState();
  }
}

class _AffordablePubsScreenState extends State<AffordablePubsScreen> {
  List<Pubs> pubEconomici = [];
  bool staCaricando = true;

  @override
  void initState() {
    super.initState();
    caricaPubEconomici();
  }

  Future<void> caricaPubEconomici() async {
    const int maxPrice = 15;
    final String indirizzo = 
        'http://192.168.1.34:1337/api/pubs/affordable?maxPrice=$maxPrice';

    final http.Response risposta = await http.get(Uri.parse(indirizzo));

    if (risposta.statusCode == 200) {
      final List<dynamic> dati = json.decode(risposta.body);

      List<Pubs> convertiti = [];
      for (int i = 0; i < dati.length; i++) {
        convertiti.add(Pubs.fromJson(dati[i]));
      }

      setState(() {
        pubEconomici = convertiti;
        staCaricando = false;
      });
    } else {
      setState(() {
        staCaricando = false;
      });
      print("Errore nel caricamento: ${risposta.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pub Economici')),
      body: staCaricando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pubEconomici.length,
              itemBuilder: (context, indice) {
                final Pubs pub = pubEconomici[indice];
                return PubCard(pub);
              },
            ),
    );
  }
}