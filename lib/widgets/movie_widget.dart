import 'package:flutter/material.dart';

class MovieWidget extends StatelessWidget {
  final String movie;
  final Function onDelete;
  final Function onWatched;

  const MovieWidget({
    Key? key,
    required this.movie,
    required this.onDelete,
    required this.onWatched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: InkWell(
        onLongPress: () => onDelete(),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(movie),
              ),
            ),
            IconButton(
              onPressed: () => onWatched(),
              icon: const Icon(Icons.visibility),
            ),
          ],
        ),
      ),
    );
  }
}
