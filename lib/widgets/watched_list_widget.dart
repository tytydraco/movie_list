import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/widgets/movie_widget.dart';
import 'package:movie_list/widgets/watched_widget.dart';

class WatchedListWidget extends StatefulWidget {
  final List<MovieModel> movieList;
  final Future<void> Function() onRefresh;
  final Function(MovieModel) onUnwatched;

  const WatchedListWidget({
    Key? key,
    required this.movieList,
    required this.onRefresh,
    required this.onUnwatched,
  }) : super(key: key);

  @override
  State<WatchedListWidget> createState() => _WatchedListWidgetState();
}

class _WatchedListWidgetState extends State<WatchedListWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.movieList.length,
        itemBuilder: (context, index) {
          final movie = widget.movieList[index];
          return WatchedWidget(
            movie: movie.movie,
            onUnwatched: () => widget.onUnwatched(movie),
          );
        },
      ),
    );
  }
}
