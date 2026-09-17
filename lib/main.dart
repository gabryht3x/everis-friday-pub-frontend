import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/pubs.dart';
import 'pub_card.dart';
import 'affordable_pubs_screen.dart';

void main() => runApp(const EverisFridayApp());

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({super.key});

  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = <Pubs>[];
  late Future<String> futurePubs;

  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }

  Future<String> getPubs(List<Pubs> _listPubs) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:1337/api/pubs'),
    );

    if (response.statusCode == 200) {
      List<dynamic> pubsListRaw = jsonDecode(response.body);
      for (var i = 0; i < pubsListRaw.length; i++) {
        _listPubs.add(Pubs.fromJson(pubsListRaw[i]));
      }
      return "Success!";
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildPubs() {
    return FutureBuilder(
      future: futurePubs,
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            projectSnap.hasData == false) {
          return const Center(
            child: Text("Ups there is no data or connection"),
          );
        }
        return ListView.builder(
          itemCount: _listPubs.length,
          itemBuilder: (context, index) {
            return PubCard(_listPubs[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Everis Fridays Pub'),
          backgroundColor: const Color(0xff9aae04),
        ),
        body: Column(
          children: [
            Expanded(child: _buildPubs()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (innerContext) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        innerContext, 
                        MaterialPageRoute(
                          builder: (context) => const AffordablePubsScreen(),
                        ),
                      );
                    },
                    child: const Text('Pub Economici'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
