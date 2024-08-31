import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';

abstract class MovieDetailState {}

class MovieDetailInitialState extends MovieDetailState {}

class MovieDetailLoadingState extends MovieDetailState {}

class MovieDetailSuccessState extends MovieDetailState {
  final MovieResponse movie;

  MovieDetailSuccessState({required this.movie});
}

class MovieDetailErrorState extends MovieDetailState {
  final String errorMessage;
  MovieDetailErrorState(this.errorMessage);
}
