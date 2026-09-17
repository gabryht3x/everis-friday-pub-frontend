import 'package:flutter/material.dart';
import 'models/pubs.dart';

class PubCard extends StatelessWidget {
  final Pubs pub;

  const PubCard(this.pub, {super.key});

  @override
  Widget build(BuildContext context) {
    final immagine = NetworkImage(
      'http://192.168.1.34:1337${pub.picture.url}',
    );

    final avatar = CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.transparent,
      backgroundImage: immagine,
    );

    final titolo = Text(pub.name, textAlign: TextAlign.justify);
    final sottotitolo = Text(pub.address);
    final prezzo = Text(pub.avgPrice.toString());

    return Card(
      child: ListTile(
        leading: avatar,
        title: titolo,
        subtitle: sottotitolo,
        trailing: prezzo,
      ),
    );
  }
}