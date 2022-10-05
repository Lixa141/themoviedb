import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/widgets/auth/authentification.dart';
import 'package:flutter_themoviedb/widgets/auth/authentification_model.dart';
import 'package:flutter_themoviedb/widgets/loader/loader.dart';
import 'package:flutter_themoviedb/widgets/loader/loader_model.dart';
import 'package:flutter_themoviedb/widgets/main_screen/main_screen.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details.dart';
import 'package:flutter_themoviedb/widgets/movie_details/movie_details_model.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list__model.dart';
import 'package:flutter_themoviedb/widgets/movie_trailer/movie_trailer.dart';
import 'package:flutter_themoviedb/widgets/news/news.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String videoKey) {
    return MovieTrailer(videoKey: videoKey);
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieList(),
    );
  }

  Widget makeNews() {
    return const News();
  }
}