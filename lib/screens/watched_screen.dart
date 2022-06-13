import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/watched_list_widget.dart';

class WatchedScreen extends StatefulWidget {
  const WatchedScreen({Key? key}) : super(key: key);

  @override
  State<WatchedScreen> createState() => _WatchedScreenState();
}

class _WatchedScreenState extends State<WatchedScreen> {
  final database = Database();
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
    return Column(
      children: [
        FutureBuilder(
          future: database.getMovies(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<MovieModel>;
              final onlyWatched = data.where((element) => element.watched)
                  .toList();
              return Expanded(
                child: WatchedListWidget(
                  movieList: onlyWatched,
                  onRefresh: refresh,
                  onUnwatched: (movie) => unwatchedMovie(movie),
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
