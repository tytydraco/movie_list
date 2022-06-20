import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_list/models/movie_model.dart';

class Database {
  final String listId;

  Database(this.listId);

  Future<List<MovieModel>> getMovies() async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection(listId).get();
    final movies = query.docs.map((e) {
      return MovieModel(
        e.data()['movie'] as String,
        e.data()['watched'] as bool? ?? false,
      );
    }).toList();
    movies.sort((a, b) => a.movie.toLowerCase().compareTo(b.movie.toLowerCase()));
    return movies;
  }

  Future addMovie(String movieTitle) async {
    final db = FirebaseFirestore.instance;
    await db.collection(listId).add({
      'movie': movieTitle,
      'watched': false,
    });
  }

  Future deleteMovie(String name) async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection(listId).where('movie', isEqualTo: name).get();
    final element = query.docs.first;
    await db.collection(listId).doc(element.id).delete();
  }

  Future updateMovie(String name, Map<String, Object?> newData) async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection(listId).where('movie', isEqualTo: name).get();
    final element = query.docs.first;
    await db.collection(listId).doc(element.id).update(newData);
  }

  Future deleteList() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection(listId);

    while (true) {
      final docBatch = await collection.limit(20).get();
      if (docBatch.size == 0) {
        break;
      }
      for (final doc in docBatch.docs) {
        await doc.reference.delete();
      }
    }
  }
}