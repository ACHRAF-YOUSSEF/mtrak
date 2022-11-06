import 'package:flutter/material.dart';
import 'package:mtrak/tvDescription.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TV extends StatelessWidget {
  const TV({super.key, required this.tv});

  final List tv;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const modified_text(
            text: "Popular TV Shows",
            size: 26.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 200.0,
            child: ListView.builder(
              itemCount: tv.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TVDescription(
                          tvShowId: tv[index]['id'],
                          name: tv[index]['original_name'],
                          description: tv[index]['overview'],
                          bannerurl: 'https://image.tmdb.org/t/p/w500' +
                              tv[index]['backdrop_path'],
                          posterurl: 'https://image.tmdb.org/t/p/w500' +
                              tv[index]['poster_path'],
                          vote: tv[index]['vote_average'].toString(),
                          lanch_on: tv[index]['first_air_date'],
                        ),
                      ),
                    );
                  },
                  child: tv[index]['original_name'] != null
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
                                          tv[index]['backdrop_path'],
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
                                  text: tv[index]['original_name'] ??
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
