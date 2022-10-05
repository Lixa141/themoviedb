import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/clients/image_url_maker.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/widgets/depricated/widget.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: _SummaryWidget(),
        ),
        _SloganWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: _DescriptionWidget(),
        ),
        _CrewWidget(),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);
    if (overview.isNotEmpty) {
      return Text(
        overview,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Overview',
      style: TextStyle(color: Colors.white, fontSize: 21),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final topPosterData =
        context.select((MovieDetailsModel model) => model.data.topPosterData);
    final backdropPath = topPosterData.backdropPath;
    final posterPath = topPosterData.posterPath;

    return Stack(
      children: [
        if (backdropPath != null)
          AspectRatio(
            aspectRatio: 390 / 219,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: NetworkImage(ImageUrlMaker.imageUrl(backdropPath)),
                ),
              ),
            ),
          ),
        if (posterPath != null)
          Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(ImageUrlMaker.imageUrl(posterPath))),
        Positioned(
            top: 10,
            right: 20,
            child: IconButton(
              icon: Icon(topPosterData.favoriteIcon),
              onPressed: () => model.toggleIsFavorite(context),
            ))
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieNameData =
        context.select((MovieDetailsModel model) => model.data.movieNameData);
    final modelTitle = movieNameData.title;
    var year = movieNameData.year;
    return Container(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
              text: modelTitle,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
          TextSpan(
              text: year,
              style: const TextStyle(color: Colors.grey, fontSize: 18)),
        ]),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreData =
        context.select((MovieDetailsModel model) => model.data.scoreData);

    final videoKey = scoreData.videoKey;
    final voteAverage = scoreData.voteAverage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RadialPercentWidget(
                    percent: voteAverage / 100,
                    fillColor: const Color.fromARGB(255, 10, 23, 25),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineWidth: 3,
                    child: Text(voteAverage.toStringAsFixed(0)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('User Score'),
              ],
            )),
        if (videoKey != null)
          Row(
            children: [
              Container(
                width: 1,
                height: 15,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.movieTrailer,
                    arguments: videoKey),
                child: Row(
                  children: const [
                    Icon(Icons.play_arrow),
                    Text('Play Trailer'),
                  ],
                ),
              )
            ],
          ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summaryData =
        context.select((MovieDetailsModel model) => model.data.summaryData);
    final certification = summaryData.certification;
    final summary = summaryData.summary;
    final genres = summaryData.genres;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (certification.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 7),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.6))),
                child: Text(
                  certification,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromRGBO(255, 255, 255, 0.6)),
                ),
              ),
            Text(
              summary,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        if (genres != null)
          Text(
            genres,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
      ],
    );
  }
}

class _SloganWidget extends StatelessWidget {
  const _SloganWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagline =
        context.select((MovieDetailsModel model) => model.data.tagline);
    if (tagline.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          tagline,
          style: const TextStyle(
              fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 18),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _CrewWidget extends StatelessWidget {
  const _CrewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crew = context.select((MovieDetailsModel model) => model.data.crewData);

    if (crew.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            _CrewWidgetRow(crew: crew.sublist(0, 3)),
            if (crew.length > 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _CrewWidgetRow(crew: crew.sublist(2)),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _CrewWidgetRow extends StatelessWidget {
  final List<MovieDetailsCrewData> crew;

  const _CrewWidgetRow({Key? key, required this.crew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CrewWidgetRowItem(person: crew[0]),
        if (crew.length > 1) _CrewWidgetRowItem(person: crew[1])
      ],
    );
  }
}

class _CrewWidgetRowItem extends StatelessWidget {
  const _CrewWidgetRowItem({Key? key, required this.person})
      : super(key: key);

  final MovieDetailsCrewData person;

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );

    const jobStyle = TextStyle(
      fontSize: 14,
      color: Colors.white,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(person.name, style: nameStyle),
          Text(person.job, style: jobStyle),
        ],
      ),
    );
  }
}
