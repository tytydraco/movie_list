import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_list_widget.dart';
import 'package:movie_list/widgets/movie_widget.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
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

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              final data = snapshot.data as List<MovieModel>;
              return Expanded(
                child: MovieListWidget(
                  movieList: data,
                  onDelete: (movie) => deleteMovie(movie.movie),
                  onRefresh: refresh,
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}