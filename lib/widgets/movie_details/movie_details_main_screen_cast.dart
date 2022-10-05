import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/clients/image_url_maker.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

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
            const CastListWidget(),
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

class CastListWidget extends StatelessWidget {
  const CastListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cast =
        context.select((MovieDetailsModel model) => model.data.castData);

    if (cast.isNotEmpty) {
      final itemCount = cast.length > 9 ? 9 : cast.length;
      return Scrollbar(
        child: SizedBox(
          height: 265,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: itemCount,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _CrewListItemWidget(itemCount: itemCount, index: index);
              }),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _CrewListItemWidget extends StatelessWidget {
  const _CrewListItemWidget({
    Key? key,
    required this.index,
    required this.itemCount,
  }) : super(key: key);

  final int itemCount;
  final int index;

  @override
  Widget build(BuildContext context) {
    final actor = context.read<MovieDetailsModel>().data.castData[index];
    final profilePath = actor.profilePath;
    final name = actor.name;
    final character = actor.character;

    return Row(
      children: [
        SizedBox(
          width: 130,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profilePath != null)
                    Image.network(
                      ImageUrlMaker.imageUrl(profilePath),
                      height: 140,
                      width: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
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
        if (index != itemCount - 1) const SizedBox(width: 10)
      ],
    );
  }
}
