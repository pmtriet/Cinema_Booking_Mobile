import 'package:cinemabooking/domain/data_request/home/movie_id_request.dart';
import 'package:cinemabooking/domain/repo_interface/movie_repo_interface.dart';
import 'package:cinemabooking/presentation/states/detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final IMovieRepository movieRepository;

  MovieDetailCubit({required this.movieRepository})
      : super(MovieDetailLoadingState());

  Future<void> getMovieById(int movieId) async {
    try {
      var movieRequestDTO = MovieRequestById(movieId: movieId);
      final result = await movieRepository.getMovieById(movieRequestDTO);
      if (result != null) {
        emit(MovieDetailSuccessState(movie: result));
      } else {
        emit(MovieDetailErrorState('Fail to get movie'));
      }
    } catch (e) {
      emit(MovieDetailErrorState("Failed to get movies: ${e.toString()}"));
    }
  }
}
