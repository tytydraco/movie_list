import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_list/models/movie_model.dart';

class Database {
  Future<List<MovieModel>> getMovies() async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').get();
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
    await db.collection('movies').add({
      'movie': movieTitle,
      'watched': false,
    });
  }

  Future deleteMovie(String name) async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').where('movie', isEqualTo: name).get();
    for (var element in query.docs) {
      await db.collection('movies').doc(element.id).delete();
    }
  }
}