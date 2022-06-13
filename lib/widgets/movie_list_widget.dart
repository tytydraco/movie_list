import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/widgets/movie_widget.dart';

class MovieListWidget extends StatefulWidget {
  final List<MovieModel> movieList;
  final Future<void> Function() onRefresh;
  final Function(MovieModel) onDelete;
  final Function(MovieModel) onWatched;

  const MovieListWidget({
    Key? key,
    required this.movieList,
    required this.onRefresh,
    required this.onDelete,
    required this.onWatched,
  }) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        itemCount: widget.movieList.length,
        itemBuilder: (context, index) {
          final movie = widget.movieList[index];
          return MovieWidget(
            movie: movie.movie,
            onDelete: () => widget.onDelete(movie),
            onWatched: () => widget.onWatched(movie),
          );
        },
      ),
    );
  }
}
