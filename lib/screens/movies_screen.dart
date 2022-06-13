import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_list_widget.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final database = Database();
  final addMovieController = TextEditingController();

  void addMovie() async {
    final text = addMovieController.text;
    addMovieController.clear();
    await database.addMovie(text);
    setState(() {});
  }

  Future refresh() async {
    setState(() {});
  }

  void deleteMovie(MovieModel movie) async {
    await database.deleteMovie(movie.movie);
    setState(() {});
  }

  void watchedMovie(MovieModel movie) async {
    await database.updateMovie(movie.movie, {'watched': true});
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
              final onlyUnwatched = data.where((element) => !element.watched).toList();
              return Expanded(
                child: MovieListWidget(
                  movieList: onlyUnwatched,
                  onRefresh: refresh,
                  onDelete: (movie) => deleteMovie(movie),
                  onWatched: (movie) => watchedMovie(movie),
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