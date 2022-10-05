import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/entity/movie.dart';
import 'package:flutter_themoviedb/domain/services/movie_service.dart';
import 'package:flutter_themoviedb/library/paginator.dart';
import 'package:flutter_themoviedb/library/widgets/localized_model.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';
import 'package:intl/intl.dart';

class MovieListRowData {
  final int id;
  final String posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieListViewModel extends ChangeNotifier {
  final _movieService = MovieService();
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchedMoviePaginator;
  final  _localeStorage = LocalizedModelStorage();
  // String _locale = '';
  Timer? searchDebounce;

  var _movies = <MovieListRowData>[];
  String? _searchQuery;

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieListViewModel() {
    _popularMoviePaginator = Paginator<Movie>((pageNumber) async {
      final result = await _movieService.getPopularMovies(
        pageNumber,
        _localeStorage.localTag,
      );
      return PaginatorLoadResult<Movie>(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });

    _searchedMoviePaginator = Paginator<Movie>((pageNumber) async {
      final result = await _movieService.getSearchedMovies(
        pageNumber,
        _localeStorage.localTag,
        _searchQuery ?? '',
      );
      return PaginatorLoadResult<Movie>(
        data: result.movies,
        currentPage: result.page,
        totalPage: result.totalPages,
      );
    });
  }

  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localTag);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchedMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchedMoviePaginator.loadNextPage();
      _movies = _searchedMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final posterPath = movie.posterPath ?? '';
    final formatReleaseDate =
    releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
        id: movie.id,
        title: movie.title,
        releaseDate: formatReleaseDate,
        posterPath: posterPath,
        overview: movie.overview);
  }

  void onMovieTap(BuildContext context, int index) {
    final id = movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchedMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
