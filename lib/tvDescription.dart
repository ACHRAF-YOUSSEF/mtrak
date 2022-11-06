import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

final String API_KEY = "9e22c17297722ec031db2f1415424f11";
final String READ_ACCESS_TOKEN =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZTIyYzE3Mjk3NzIyZWMwMzFkYjJmMTQxNTQyNGYxMSIsInN1YiI6IjYzNjUwODBjZDhkMzI5MDA3YTRmOTMwMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XevStwfTlt9lAci9p2CbbgoKJSnQRvXS-Y-PGTtocYc";

const apiKey = 'AIzaSyA52mXdJDehIBVfMkR7QE4QavRIRMnmAjY';
const projectId = 'mtrak-ebf6b';

class TVDescription extends StatefulWidget {
  TVDescription({
    super.key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.lanch_on,
    required this.tvShowId,
  });

  final String name, description, bannerurl, posterurl, vote, lanch_on;
  final int tvShowId;

  @override
  State<TVDescription> createState() => _TVDescriptionState(this.tvShowId);
}

class _TVDescriptionState extends State<TVDescription> {
  _TVDescriptionState(this.tvShowId);

  CollectionReference bookmarkCollection =
      Firestore.instance.collection("bookmark");

  int nb = 0;
  List similarTvShows = [];
  List<dynamic> bookmarkedTVShows = [];
  int tvShowId = 0;
  String? currentTvShowId;
  bool bookmarked = false;

  @override
  void initState() {
    getSimilar(tvShowId);
    getDetail(tvShowId);
    getBookMarks();
    super.initState();
  }

  addToBookMarks() async {
    await bookmarkCollection.add({
      "id": tvShowId,
      "isMovie": false,
    });
  }

  deleteFromBookMarks() async {
    await bookmarkCollection.document(currentTvShowId!).delete();
  }

  getBookMarks() async {
    List<Document> bookmarks = await bookmarkCollection.get();

    for (Document bookmark in bookmarks) {
      if (bookmark["isMovie"] == false) {
        Map tv = await getTvShowDetail(bookmark['id']);
        String? id = bookmark.id;
        Map tvShow = {'data': tv, 'id': id};
        if (bookmarkedTVShows.contains(tvShow) == false) {
          bookmarkedTVShows.add(tvShow);
        }
      }
    }

    for (Map bookMark in bookmarkedTVShows) {
      if (bookMark['data']['id'] == tvShowId) {
        currentTvShowId = bookMark['id'];
        bookmarked = true;
      }
    }
  }

  getTvShowDetail(tvShowId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map results = await tmdbWithCustomLogs.v3.tv.getDetails(tvShowId);

    return results;
  }

  getDetail(tvShowId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map results = await tmdbWithCustomLogs.v3.tv.getDetails(tvShowId);
    List result = results['seasons'];

    setState(() {
      nb = result.length;
    });
  }

  getSimilar(tvShowId) async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(API_KEY, READ_ACCESS_TOKEN),
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true));

    Map similar = await tmdbWithCustomLogs.v3.tv.getSimilar(tvShowId);

    setState(() {
      similarTvShows = similar['results'];
    });
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
                    flex: 4,
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
                        if (currentTvShowId != null) {
                          deleteFromBookMarks();
                        } else {
                          addToBookMarks();
                        }
                      });
                    },
                    icon: Icon(
                      (currentTvShowId != null && bookmarked)
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
                text: "Number of seasons : ${nb}",
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
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
                    text: "Similar TV Shows",
                    size: 26.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200.0,
                    child: ListView.builder(
                      itemCount: similarTvShows.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TVDescription(
                                  tvShowId: similarTvShows[index]['id'],
                                  name: similarTvShows[index]['original_name'],
                                  description: similarTvShows[index]
                                      ['overview'],
                                  bannerurl: 'https://image.tmdb.org/t/p/w500' +
                                      similarTvShows[index]['backdrop_path'],
                                  posterurl: 'https://image.tmdb.org/t/p/w500' +
                                      similarTvShows[index]['poster_path'],
                                  vote: similarTvShows[index]['vote_average']
                                      .toString(),
                                  lanch_on: similarTvShows[index]
                                      ['first_air_date'],
                                ),
                              ),
                            );
                          },
                          child: similarTvShows[index]['original_name'] != null
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 250.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 250.0,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'https://image.tmdb.org/t/p/w500' +
                                                  similarTvShows[index]
                                                      ['backdrop_path'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: modified_text(
                                          text: similarTvShows[index]
                                                  ['original_name'] ??
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
