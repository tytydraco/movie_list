import 'package:flutter/material.dart';

class MovieWidget extends StatelessWidget {
  final String movie;
  final Function onDelete;

  const MovieWidget({
    Key? key,
    required this.movie,
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(movie),
              ),
            ),
            IconButton(
              onPressed: () => onDelete(),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
