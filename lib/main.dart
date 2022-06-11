import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/firebase_options.dart';
import 'package:movie_list/movie_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final addMovieController = TextEditingController();

  Future<List<String>> getMovies() async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').get();
    final movies = query.docs.map((e) => e.data()['movie'] as String).toList();
    movies.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return movies;
  }

  Future addMovie() async {
    final text = addMovieController.text;
    addMovieController.clear();
    final db = FirebaseFirestore.instance;
    await db.collection('movies').add({'movie': text});
    setState(() {});
  }

  Future deleteMovie(String name) async {
    final db = FirebaseFirestore.instance;
    final query = await db.collection('movies').where('movie', isEqualTo: name).get();
    for (var element in query.docs) {
      await db.collection('movies').doc(element.id).delete();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: getMovies,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: addMovieController,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => addMovie(),
                decoration: InputDecoration(
                  hintText: 'Add movie',
                  suffixIcon: IconButton(
                    onPressed: addMovie,
                    icon: const Icon(Icons.add),
                  )
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: getMovies(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<String>;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return MovieWidget(
                      movie: item,
                      onDelete: () => deleteMovie(item),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
