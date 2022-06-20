import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/watched_list_widget.dart';

class WatchedScreen extends StatefulWidget {
  final String listId;

  const WatchedScreen({
    Key? key,
    required this.listId,
  }) : super(key: key);

  @override
  State<WatchedScreen> createState() => _WatchedScreenState();
}

class _WatchedScreenState extends State<WatchedScreen> {
  late final database = Database(widget.listId);
  final addMovieController = TextEditingController();

  Future refresh() async {
    setState(() {});
  }

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
            return WatchedListWidget(
              movieList: onlyWatched,
              onRefresh: refresh,
              onUnwatched: (movie) => unwatchedMovie(movie),
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
