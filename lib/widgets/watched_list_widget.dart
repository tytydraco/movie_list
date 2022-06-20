import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_widget.dart';
import 'package:movie_list/widgets/watched_widget.dart';

class WatchedListWidget extends StatefulWidget {
  final String listId;

  const WatchedListWidget({
    Key? key,
    required this.listId,
  }) : super(key: key);

  @override
  State<WatchedListWidget> createState() => _WatchedListWidgetState();
}

class _WatchedListWidgetState extends State<WatchedListWidget> {
  late final database = Database(widget.listId);

  void unwatchedMovie(MovieModel movie) async {
    await database.updateMovie(movie.movie, {'watched': false});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: database.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<MovieModel>;
            final onlyWatched = data.where((element) => element.watched).toList();
            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.builder(
                itemCount: onlyWatched.length,
                itemBuilder: (context, index) {
                  final movie = onlyWatched[index];
                  return WatchedWidget(
                    movie: movie.movie,
                    onUnwatched: () => unwatchedMovie(movie),
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
    );
  }
}
