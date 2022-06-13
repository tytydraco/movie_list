import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_widget.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final database = Database();
  final addMovieController = TextEditingController();

  void addMovie() {
    final text = addMovieController.text;
    addMovieController.clear();
    database.addMovie(text);
    setState(() {});
  }

  void deleteMovie(String name) {
    database.deleteMovie(name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: addMovieController,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => addMovie(),
                decoration: InputDecoration(
                    hintText: 'Add movie',
                    suffixIcon: IconButton(
                      onPressed: addMovie,
                      icon: const Icon(Icons.add),
                    )
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: database.getMovies(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<String>;
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final movie = data[index];
                      return MovieWidget(
                        movie: movie,
                        onDelete: () => deleteMovie(movie),
                      );
                    },
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}