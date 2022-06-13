import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/widgets/movie_widget.dart';

class MovieListWidget extends StatefulWidget {
  final List<MovieModel> movieList;
  final Function(MovieModel) onDelete;
  final Future<void> Function() onRefresh;

  const MovieListWidget({
    Key? key,
    required this.movieList,
    required this.onDelete,
    required this.onRefresh,
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
        shrinkWrap: true,
        itemCount: widget.movieList.length,
        itemBuilder: (context, index) {
          final movie = widget.movieList[index];
          return MovieWidget(
            movie: movie.movie,
            onDelete: () => widget.onDelete(movie),
          );
        },
      ),
    );
  }
}
