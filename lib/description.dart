import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

final String API_KEY = "9e22c17297722ec031db2f1415424f11";
final String READ_ACCESS_TOKEN =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZTIyYzE3Mjk3NzIyZWMwMzFkYjJmMTQxNTQyNGYxMSIsInN1YiI6IjYzNjUwODBjZDhkMzI5MDA3YTRmOTMwMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XevStwfTlt9lAci9p2CbbgoKJSnQRvXS-Y-PGTtocYc";

const apiKey = 'AIzaSyA52mXdJDehIBVfMkR7QE4QavRIRMnmAjY';
const projectId = 'mtrak-ebf6b';

class Description extends StatefulWidget {
  Description({
    super.key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.lanch_on,
    required this.movieId,
  });

  final String name, description, bannerurl, posterurl, vote, lanch_on;
  final int movieId;

  @override
  State<Description> createState() => _DescriptionState(this.movieId);
}

class _DescriptionState extends State<Description> {
  _DescriptionState(this.movieId);

  CollectionReference bookmarkCollection =
      Firestore.instance.collection("bookmark");

  int movieId = 0;
  List similarMovies = [];
  List<dynamic> bookmarkedMovies = [];
  String? currentMovieId;
  bool bookmarked = false;

  @override
  void initState() {
    getSimilar(movieId);
    super.initState();
  }

  addToBookMarks() async {
    await bookmarkCollection.add({
      "id": movieId,
      "isMovie": true,
    });
  }

  deleteFromBookMarks() async {
    await bookmarkCollection.document(currentMovieId!).delete();
  }

  getBookMarks() async {
    List<Document> bookmarks = await bookmarkCollection.get();

    for (Document bookmark in bookmarks) {
      try {
        if (bookmark["isMovie"] == true) {
          Map tv = await getMovieDetail(bookmark['id']);
          String? id = bookmark.id;
          Map movie = {'data': tv, 'id': id};
          if (bookmarkedMovies.contains(movie) == false) {
            bookmarkedMovies.add(movie);
          }
        }
      } catch (e) {}
    }

    for (Map bookMark in bookmarkedMovies) {
      try {
        if (bookMark['data']['id'] == movieId) {
          currentMovieId = bookMark['id'];
          bookmarked = true;
        }
      } catch (e) {}
    }
  }

  getMovieDetail(movieId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    try {
      Map results = await tmdbWithCustomLogs.v3.movies.getDetails(movieId);

      return results;
    } catch (e) {}
  }

  getSimilar(movieId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    try {
      Map similar = await tmdbWithCustomLogs.v3.movies.getSimilar(movieId);

      setState(() {
        similarMovies = similar['results'];
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.bannerurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: modified_text(
                      text: "⭐Average Rating - " + widget.vote,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: modified_text(
                      text: widget.name,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    tooltip: "bookmark",
                    onPressed: () {
                      setState(() {
                        if (currentMovieId != null) {
                          deleteFromBookMarks();
                        } else {
                          addToBookMarks();
                        }
                      });
                    },
                    icon: Icon(
                      (currentMovieId != null && bookmarked)
                          ? Icons.bookmark_added
                          : Icons.bookmark_add,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: modified_text(
                text: "Releasing On - " + widget.lanch_on,
                color: Colors.white,
                size: 14,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 200,
                  width: 100,
                  child: Image.network(widget.posterurl),
                ),
                Flexible(
                  child: Container(
                    child: modified_text(
                      text: widget.description,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const modified_text(
                    text: "Similar Movies",
                    size: 26.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 300.0,
                    child: ListView.builder(
                      itemCount: similarMovies.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Description(
                                  movieId: similarMovies[index]['id'],
                                  name: similarMovies[index]['title'],
                                  description: similarMovies[index]['overview'],
                                  bannerurl: 'https://image.tmdb.org/t/p/w500' +
                                      similarMovies[index]['backdrop_path'],
                                  posterurl: 'https://image.tmdb.org/t/p/w500' +
                                      similarMovies[index]['poster_path'],
                                  vote: similarMovies[index]['vote_average']
                                      .toString(),
                                  lanch_on: similarMovies[index]
                                      ['release_date'],
                                ),
                              ),
                            );
                          },
                          child: similarMovies[index]['title'] != null
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 140.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'https://image.tmdb.org/t/p/w500' +
                                                  similarMovies[index]
                                                      ['poster_path'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: modified_text(
                                          text: similarMovies[index]['title'] ??
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
