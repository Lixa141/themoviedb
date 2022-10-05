import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';
import 'package:provider/provider.dart';

import 'movie_details_main_info.dart';
import 'movie_details_main_screen_cast.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    // Future.microtask(
    //   () => context.read<MovieDetailsModel>().setupLocale(context, locale);
    //
    //
    //   context.read<MovieDetailsModel>().setupLocale(context),
    // );

    context.read<MovieDetailsModel>().setupLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
          color: Color.fromRGBO(31, 11, 11, 1), child: _BodyWidget()),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsModel model) => model.data.title);
    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((MovieDetailsModel model) => model.data.isLoading);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: const [
        MovieDetailsMainInfoWidget(),
        MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}
