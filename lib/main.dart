import 'package:flutter/material.dart';
import 'package:mtrak/utils/text.dart';
import 'package:mtrak/widgets/trending.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.grey),
          ),
        ),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List tv = [];

  final String API_KEY = "9e22c17297722ec031db2f1415424f11";
  final String READ_ACCESS_TOKEN =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZTIyYzE3Mjk3NzIyZWMwMzFkYjJmMTQxNTQyNGYxMSIsInN1YiI6IjYzNjUwODBjZDhkMzI5MDA3YTRmOTMwMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XevStwfTlt9lAci9p2CbbgoKJSnQRvXS-Y-PGTtocYc";

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPopular();

    setState(() {
      trendingMovies = trendingResult['results'];
      topRatedMovies = topRatedResult['results'];
      tv = tvResult['results'];
    });

    debugPrint("$trendingMovies");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const modified_text(
          text: "MTRAK❤️",
          color: Colors.white,
          size: 26.0,
        ),
      ),
      body: ListView(
        children: [
          TrendingMovies(trending: trendingMovies)
        ],
      ),
    );
  }
}