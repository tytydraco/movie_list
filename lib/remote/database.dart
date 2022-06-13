import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<List<String>> getMovies() async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').get();
    final movies = query.docs.map((e) => e.data()['movie'] as String).toList();
    movies.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return movies;
  }

  Future addMovie(String movieTitle) async {
    final db = FirebaseFirestore.instance;
    await db.collection('movies').add({'movie': movieTitle});
  }

  Future deleteMovie(String name) async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').where('movie', isEqualTo: name).get();
    for (var element in query.docs) {
      await db.collection('movies').doc(element.id).delete();
    }
  }
}