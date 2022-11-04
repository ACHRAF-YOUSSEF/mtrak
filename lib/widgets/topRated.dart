import 'package:flutter/material.dart';
import 'package:mtrak/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';

class TopRated extends StatelessWidget {
  final List topRated;

  const TopRated({super.key, required this.topRated});

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
                    onTap: () {},
                    child: Container(
                      width: 140.0,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500' +
                                        topRated[index]['poster_path']),
                              ),
                            ),
                          ),
                          Container(
                            child: modified_text(
                              text: topRated[index]['title'] ?? "Loading...!",
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
