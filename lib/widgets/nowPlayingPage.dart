import 'package:flutter/material.dart';
import 'package:mtrak/description.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class NowPlayingMovies extends StatelessWidget {
  const NowPlayingMovies({super.key, required this.nowPlayingMovies});

  final List nowPlayingMovies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const modified_text(
            text: "Now Playing Movies",
            size: 26.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 200.0,
            child: ListView.builder(
              itemCount: nowPlayingMovies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          movieId: nowPlayingMovies[index]['id'],
                          name: nowPlayingMovies[index]['title'],
                          description: nowPlayingMovies[index]['overview'],
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              nowPlayingMovies[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              nowPlayingMovies[index]['poster_path'],
                          vote: nowPlayingMovies[index]['vote_average']
                              .toString(),
                          lanch_on: nowPlayingMovies[index]['release_date'],
                        ),
                      ),
                    );
                  },
                  child: nowPlayingMovies[index]['title'] != null
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          width: 250.0,
                          child: Column(
                            children: [
                              Container(
                                width: 250,
                                height: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' +
                                          nowPlayingMovies[index]
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
                                  text: nowPlayingMovies[index]['title'] ??
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
    );
  }
}
