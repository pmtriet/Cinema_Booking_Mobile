import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeMoviesState extends HomeState {
  final List<MovieResponse> movies;
  final bool isLoadingMore;
  HomeMoviesState({
    required this.movies,
    this.isLoadingMore = false,
  });
}

class HomeEmptyMovieState extends HomeState {}

class HomeSearchErrorState extends HomeState {
  final String errorMessage;
  HomeSearchErrorState(this.errorMessage);
}
