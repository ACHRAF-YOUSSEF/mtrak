import 'package:flutter/material.dart';
import 'package:mtrak/description.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TrendingMovies extends StatelessWidget {
  const TrendingMovies({super.key, required this.trending});

  final List trending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const modified_text(
            text: "Trending Movies",
            size: 26.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 270.0,
            child: ListView.builder(
              itemCount: trending.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          movieId: trending[index]['id'],
                          name: trending[index]["title"],
                          description: trending[index]['overview'],
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              trending[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              trending[index]['poster_path'],
                          vote: trending[index]['vote_average'].toString(),
                          lanch_on: trending[index]['release_date'],
                        ),
                      ),
                    );
                  },
                  child: trending[index]["title"] != null
                      ? Container(
                          width: 140.0,
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' +
                                          trending[index]['poster_path'],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: modified_text(
                                  text:
                                      trending[index]['title'] ?? "Loading...!",
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
    );
  }
}
