import 'package:flutter/material.dart';
import 'package:mtrak/description.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TopRated extends StatelessWidget {
  const TopRated({super.key, required this.topRated});

  final List topRated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const modified_text(
            text: "Top Rated Movies",
            size: 26.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 270.0,
            child: ListView.builder(
              itemCount: topRated.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          movieId: topRated[index]['id'],
                          name: topRated[index]["title"],
                          description: topRated[index]['overview'],
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              topRated[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              topRated[index]['poster_path'],
                          vote: topRated[index]['vote_average'].toString(),
                          lanch_on: topRated[index]['release_date'],
                        ),
                      ),
                    );
                  },
                  child: topRated[index]['title'] != null
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
                                          topRated[index]['poster_path'],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: modified_text(
                                  text:
                                      topRated[index]['title'] ?? "Loading...!",
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
