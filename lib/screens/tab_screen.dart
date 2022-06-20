import 'package:flutter/material.dart';
import 'package:movie_list/screens/movies_screen.dart';
import 'package:movie_list/screens/watched_screen.dart';

class TabScreen extends StatefulWidget {
  final String listId;

  const TabScreen({
    Key? key,
    required this.listId,
  }) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie List'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
              ),
              Tab(
                icon: Icon(Icons.visibility),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MoviesScreen(listId: widget.listId),
            WatchedScreen(listId: widget.listId),
          ],
        ),
      ),
    );
  }
}
