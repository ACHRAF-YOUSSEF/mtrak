import 'package:firedart/firedart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtrak/description.dart';
import 'package:mtrak/tvDescription.dart';
import 'package:mtrak/utils/text.dart';
import 'package:mtrak/widgets/nowPlayingPage.dart';
import 'package:mtrak/widgets/topRated.dart';
import 'package:mtrak/widgets/moviesPage.dart';
import 'package:mtrak/widgets/topRatedTvShowsPage.dart';
import 'package:mtrak/widgets/trending.dart';
import 'package:mtrak/widgets/trendingPage.dart';
import 'package:mtrak/widgets/tv.dart';
import 'package:mtrak/widgets/tvPage.dart';
import 'package:mtrak/widgets/upcomingMoviesPage.dart';
import 'package:tmdb_api/tmdb_api.dart';

final String API_KEY = "9e22c17297722ec031db2f1415424f11";
final String READ_ACCESS_TOKEN =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZTIyYzE3Mjk3NzIyZWMwMzFkYjJmMTQxNTQyNGYxMSIsInN1YiI6IjYzNjUwODBjZDhkMzI5MDA3YTRmOTMwMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XevStwfTlt9lAci9p2CbbgoKJSnQRvXS-Y-PGTtocYc";

const apiKey = 'AIzaSyA52mXdJDehIBVfMkR7QE4QavRIRMnmAjY';
const projectId = 'mtrak-ebf6b';

void main() {
  Firestore.initialize(projectId);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.black),
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
  CollectionReference bookmarkCollection =
      Firestore.instance.collection("bookmark");

  List<dynamic> bookmarkedMovies = [];
  List<dynamic> bookmarkedTVShows = [];
  List nowPlayingMovies = [];
  List popularTv = [];
  List topRatedMovies = [];
  List topRatedTvShows = [];
  List trendingMovies = [];
  List upcomingMovies = [];

  @override
  void initState() {
    getBookMarks();
    loadMovies();
    super.initState();
  }

  getBookMarks() async {
    List<Document> bookmarks = await bookmarkCollection.orderBy('id').get();

    for (Document bookmark in bookmarks) {
      try {
        if (bookmark["isMovie"] == true) {
          Map movie = await getMovieDetail(bookmark['id']);
          String? id = bookmark.id;
          Map moviE = {'data': movie, 'id': id};
          if (bookmarkedMovies.contains(moviE) == false) {
            bookmarkedMovies.add(moviE);
          }
        } else {
          Map tv = await getTvShowDetail(bookmark['id']);
          String? id = bookmark.id;
          Map tvShow = {'data': tv, 'id': id};
          if (bookmarkedTVShows.contains(tvShow) == false) {
            bookmarkedTVShows.add(tvShow);
          }
        }
      } catch (e) {}
    }
  }

  getTvShowDetail(tvShowId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    try {
      Map results = await tmdbWithCustomLogs.v3.tv.getDetails(tvShowId);

      return results;
    } catch (e) {}
  }

  getMovieDetail(movieId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    try {
      Map results = await tmdbWithCustomLogs.v3.movies.getDetails(movieId);

      return results;
    } catch (e) {}
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map upcomingMoviesResult = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    Map nowPlayingMoviesResult =
        await tmdbWithCustomLogs.v3.movies.getNowPlaying();
    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map popularTvResult = await tmdbWithCustomLogs.v3.tv.getPopular();
    Map topRatedTvShowsResult = await tmdbWithCustomLogs.v3.tv.getTopRated();

    setState(() {
      nowPlayingMovies = nowPlayingMoviesResult['results'];
      upcomingMovies = upcomingMoviesResult['results'];
      trendingMovies = trendingResult['results'];
      topRatedMovies = topRatedResult['results'];
      popularTv = popularTvResult['results'];
      topRatedTvShows = topRatedTvShowsResult['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const modified_text(
            text: "MTRAK❤️",
            color: Colors.white,
            size: 26.0,
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.black,
          width: 250.0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
            child: Column(
              children: [
                const Flexible(
                  flex: 5,
                  child: SizedBox(
                    height: 100.0,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(backgroundColor: Colors.black),
                            backgroundColor: Colors.black,
                            body: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                NowPlayingMovies(
                                  nowPlayingMovies: nowPlayingMovies,
                                ),
                                UpcomingMovies(
                                  upcomingMovies: upcomingMovies,
                                ),
                                TopRated(
                                  topRated: topRatedMovies,
                                ),
                                TrendingMovies(
                                  trending: trendingMovies,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.movie),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text("Movies"),
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(backgroundColor: Colors.black),
                            backgroundColor: Colors.black,
                            body: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                TVPage(
                                  tv: popularTv,
                                ),
                                TopRatedTvShowsPage(
                                  tv: topRatedTvShows,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.tv),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text("TV Shows"),
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const modified_text(
                                    text: "BookMarked Movies",
                                    size: 26.0,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      height: 250,
                                      child: ListView.builder(
                                        itemCount: bookmarkedMovies.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: ((context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Description(
                                                    movieId:
                                                        bookmarkedMovies[index]
                                                            ['data']['id'],
                                                    name:
                                                        bookmarkedMovies[index]
                                                            ['data']["title"],
                                                    description:
                                                        bookmarkedMovies[index]
                                                                ['data']
                                                            ['overview'],
                                                    bannerurl:
                                                        'https://image.tmdb.org/t/p/w500' +
                                                            bookmarkedMovies[
                                                                        index]
                                                                    ['data'][
                                                                'backdrop_path'],
                                                    posterurl:
                                                        'https://image.tmdb.org/t/p/w500' +
                                                            bookmarkedMovies[
                                                                        index]
                                                                    ['data']
                                                                ['poster_path'],
                                                    vote:
                                                        bookmarkedMovies[index]
                                                                    ['data']
                                                                ['vote_average']
                                                            .toString(),
                                                    lanch_on:
                                                        bookmarkedMovies[index]
                                                                ['data']
                                                            ['release_date'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: bookmarkedMovies[index]
                                                        ['data']["title"] !=
                                                    null
                                                ? Container(
                                                    width: 140.0,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                'https://image.tmdb.org/t/p/w500' +
                                                                    bookmarkedMovies[index]
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'poster_path'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: modified_text(
                                                            text: bookmarkedMovies[
                                                                            index]
                                                                        ['data']
                                                                    ['title'] ??
                                                                "Loading...!",
                                                            size: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  const modified_text(
                                    text: "BookMarked TV Shows",
                                    size: 26.0,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    child: Container(
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: bookmarkedTVShows.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: ((context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TVDescription(
                                                    tvShowId:
                                                        bookmarkedTVShows[index]
                                                            ['data']['id'],
                                                    name:
                                                        bookmarkedTVShows[index]
                                                                ['data']
                                                            ["original_name"],
                                                    description:
                                                        bookmarkedTVShows[index]
                                                                ['data']
                                                            ['overview'],
                                                    bannerurl:
                                                        'https://image.tmdb.org/t/p/w500' +
                                                            bookmarkedTVShows[
                                                                        index]
                                                                    ['data'][
                                                                'backdrop_path'],
                                                    posterurl:
                                                        'https://image.tmdb.org/t/p/w500' +
                                                            bookmarkedTVShows[
                                                                        index]
                                                                    ['data']
                                                                ['poster_path'],
                                                    vote:
                                                        bookmarkedTVShows[index]
                                                                    ['data']
                                                                ['vote_average']
                                                            .toString(),
                                                    lanch_on:
                                                        bookmarkedTVShows[index]
                                                                ['data']
                                                            ['first_air_date'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child:
                                                bookmarkedTVShows[index]['data']
                                                            ["original_name"] !=
                                                        null
                                                    ? Container(
                                                        width: 140.0,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 200,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    'https://image.tmdb.org/t/p/w500' +
                                                                        bookmarkedTVShows[index]['data']
                                                                            [
                                                                            'poster_path'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              child:
                                                                  modified_text(
                                                                text: bookmarkedTVShows[index]
                                                                            [
                                                                            'data']
                                                                        [
                                                                        'original_name'] ??
                                                                    "Loading...!",
                                                                size: 15,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.bookmarks_sharp),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text("Watchlist"),
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 10.0,
                  ),
                ),
                const Flexible(
                  flex: 40,
                  child: SizedBox.expand(),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(backgroundColor: Colors.black),
                            backgroundColor: Colors.black,
                            body: Container(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.settings),
                        SizedBox(
                          width: 50.0,
                        ),
                        Text("Settings"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            TV(tv: popularTv),
            TopRated(topRated: topRatedMovies),
            TrendingMovies(trending: trendingMovies),
          ],
        ),
      ),
    );
  }
}
