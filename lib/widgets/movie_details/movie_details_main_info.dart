import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/api_client/api_client.dart';
import 'package:flutter_themoviedb/domain/entity/movie_details_credits.dart';
import 'package:flutter_themoviedb/library/widgets/inherited/provider.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/widgets/depricated/widget.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';

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
        _PeopleWidget(),
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    final overview = model.movieDetails?.overview;
    if (overview != null && overview.isNotEmpty) {
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return Stack(
      children: [
        backdropPath != null
            ? AspectRatio(
                aspectRatio: 390 / 219,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: NetworkImage(ApiClient.imageUrl(backdropPath)),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        posterPath != null
            ? Positioned(
                top: 20,
                left: 20,
                bottom: 20,
                child: Image.network(ApiClient.imageUrl(posterPath)))
            : const SizedBox.shrink(),
        Positioned(
            top: 10,
            right: 20,
            child: IconButton(
              icon: Icon(model?.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_outline),
              onPressed: model?.toggleIsFavorite,
            ))
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Container(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        text: TextSpan(children: [
          TextSpan(
              text: model?.movieDetails?.title ?? '',
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final videos = model?.movieDetails?.videos.results;
    final video = videos != null && videos.isNotEmpty ? videos.first : null;
    final videoKey = video?.key;
    var voteAverage = model?.movieDetails?.voteAverage ?? 0;
    voteAverage *= 10;
    final userScore = voteAverage.toInt();
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
                    child: Text(userScore.toString()),
                    percent: userScore / 100,
                    fillColor: const Color.fromARGB(255, 10, 23, 25),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineWidth: 3,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('User Score'),
              ],
            )),
        videoKey != null
            ? Row(
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
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    var text = '';
    final certification = model.certificate;

    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      text += model.stringFromDate(releaseDate) + ' ';
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      text += '(${productionCountries.first.iso}) ';
    }
    final runTime = model.runTime;
    runTime != null ? text += '• ' + runTime + ' ' : null;
    final genres = model.genres;


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            certification != null && certification.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(right: 7),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(255, 255, 255, 0.6))),
                    child: Text(
                      certification,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(255, 255, 255, 0.6)),
                    ),
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        genres != null
            ? Text(
                genres,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _SloganWidget extends StatelessWidget {
  const _SloganWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    final tagline = model.movieDetails?.tagline;
    if (tagline != null && tagline.isNotEmpty) {
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

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();

    final crew = model.filteredCrew;

    if (crew != null && crew.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            _PeopleWidgetRow(crew: crew.sublist(0, 3)),
            // SizedBox(height: 20),
            crew.length > 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _PeopleWidgetRow(crew: crew.sublist(2)),
                  )
                : const SizedBox.shrink()
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Crew> crew;

  const _PeopleWidgetRow({Key? key, required this.crew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _PeopleWidgetRowItem(person: crew[0]),
        crew.length > 1
            ? _PeopleWidgetRowItem(person: crew[1])
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  const _PeopleWidgetRowItem({Key? key, required this.person})
      : super(key: key);

  final Crew person;

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
