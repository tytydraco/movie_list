import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_widget.dart';

class MovieListWidget extends StatefulWidget {
  final String listId;

  const MovieListWidget({
    Key? key,
    required this.listId,
  }) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  late final database = Database(widget.listId);

  void addMovie() async {
    final nameController = TextEditingController();

    void _addMovie() {
      database.addMovie(nameController.text).whenComplete(() {
        Navigator.of(context).pop();
        setState(() {});
      });
    }

    final dialog = AlertDialog(
      title: const Text('Add movie'),
      content: TextField(
        controller: nameController,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _addMovie,
        decoration: const InputDecoration(
          hintText: 'Movie title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _addMovie,
          child: const Text('Add'),
        ),
      ],
    );

    await showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  void deleteMovie(MovieModel movie) async {
    final dialog = AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure you want to delete this movie?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            database.deleteMovie(movie.movie).whenComplete(() {
              Navigator.of(context).pop();
              setState(() {});
            });
          },
          child: const Text('Delete'),
        ),
      ],
    );

    await showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  void watchedMovie(MovieModel movie) async {
    await database.updateMovie(movie.movie, {'watched': true});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addMovie,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: FutureBuilder(
          future: database.getMovies(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<MovieModel>;
              final onlyUnwatched = data.where((element) => !element.watched).toList();
              return RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: ListView.builder(
                  itemCount: onlyUnwatched.length,
                  itemBuilder: (context, index) {
                    final movie = onlyUnwatched[index];
                    return MovieWidget(
                      movie: movie.movie,
                      onDelete: () => deleteMovie(movie),
                      onWatched: () => watchedMovie(movie),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
