// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maintenance/services/auth.dart';
import 'package:maintenance/services/database.dart';

class RatingBarCustom extends StatelessWidget {
  const RatingBarCustom({Key? key, required this.to, required this.other})
      : super(key: key);
  final String to;
  final bool other;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('SPRate').doc(to).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(
                child: Row(
              children: [
                const Icon(Icons.error),
                Text(snapshot.error.toString(), maxLines: 3)
              ],
            ));
          }
          if (snapshot.hasData) {
            return RatingBar.builder(
              initialRating: snapshot.data!['rate'] / 1.0,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.white,
                    );
                }
              },
              onRatingUpdate: (rating) {
                if (other) {
                  setRating(rating, to);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Autenticate()));
                }
                debugPrint(rating.toString());
              },
            );
          }
          return const Center(
            child: LinearProgressIndicator(),
          );
        });
  }
}
