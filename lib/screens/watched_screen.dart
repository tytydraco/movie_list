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
  @override
  Widget build(BuildContext context) {
    return WatchedListWidget(
      listId: widget.listId,
    );
  }
}
