import 'package:flutter/material.dart';

class WatchedWidget extends StatelessWidget {
  final String movie;
  final Function onUnwatched;

  const WatchedWidget({
    Key? key,
    required this.movie,
    required this.onUnwatched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(movie),
            ),
          ),
          IconButton(
            onPressed: () => onUnwatched(),
            icon: const Icon(Icons.visibility_off),
          ),
        ],
      ),
    );
  }
}
