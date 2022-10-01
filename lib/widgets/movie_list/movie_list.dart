import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/Theme/app_colors.dart';
import 'package:flutter_themoviedb/Theme/styles.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/library/widgets/inherited/provider.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list__model.dart';


class MovieList extends StatelessWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);
    if (model == null) return const SizedBox.shrink();
    return Stack(
      children: [
        ListView.builder(
            padding: const EdgeInsets.only(top: 70),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: model.movies.length,
            itemExtent: 170,
            itemBuilder: (BuildContext context, int index) {
              model.showedMovieAtIndex(index);
              final movie = model.movies[index];
              final posterPath = movie.posterPath;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.lightGrey,
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            // spreadRadius: 1,
                          )
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          posterPath != null
                              ? Image.network(
                                  ApiClient.imageUrl(posterPath),
                                  width: 95,
                                )
                              : const SizedBox.shrink(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: Styles.h2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    model.stringFromDate(movie.releaseDate),
                                    style: Styles.filmsDate,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    movie.overview,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.p,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        splashColor: Colors.red.withOpacity(0.1),
                        highlightColor: Colors.blue.withOpacity(0.1),
                        onTap: () => model.onMovieTap(context, index),
                      ),
                    )
                  ],
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: model.searchMovie,
            decoration: InputDecoration(
              labelText: 'Search',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
