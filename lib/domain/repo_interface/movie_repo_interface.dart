import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';
import 'package:cinemabooking/domain/data_request/home/movie_id_request.dart';
import 'package:cinemabooking/domain/data_request/home/movie_name_request.dart';

abstract class IMovieRepository {
  Future<List<MovieResponse>?> search(MovieRequestByName movieRequestDTO);
  Future<List<MovieResponse>?> getAllMovies({int page = 1, int limit = 10});
  Future<MovieResponse?> getMovieById(MovieRequestById movieRequestByIdDto);
  Future<List<DateTime>?> getDailyDate();
}
