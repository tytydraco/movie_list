import 'package:flutter/material.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/remote/database.dart';
import 'package:movie_list/widgets/movie_list_widget.dart';

class MoviesScreen extends StatefulWidget {
  final String listId;

  const MoviesScreen({
    Key? key,
    required this.listId
  }) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return MovieListWidget(
      listId: widget.listId,
    );
  }
}