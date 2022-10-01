import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/library/widgets/inherited/provider.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Series cast',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            const MovieDetailsMainScreenScrollBar(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'Full cast & crew',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailsMainScreenScrollBar extends StatelessWidget {
  const MovieDetailsMainScreenScrollBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();

    final cast = model.movieDetails?.credits.cast;

    if (cast != null && cast.isNotEmpty) {
      final itemCount = cast.length > 9 ? 9 : cast.length;
      return Scrollbar(
        child: SizedBox(
          height: 265,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: itemCount,
              // itemExtent: 140,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final profilePath = cast[index].profilePath;
                final name = cast[index].name;
                final character = cast[index].character;

                return Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profilePath != null
                                  ? Image.network(
                                      ApiClient.imageUrl(profilePath),
                                      height: 140,
                                      width: 300,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : const SizedBox.shrink(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: Text(
                                  character,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    index != itemCount - 1
                        ? const SizedBox(width: 10)
                        : const SizedBox.shrink(),
                  ],
                );
              }),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
