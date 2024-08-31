import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/services/movie_api.dart';
import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';
import 'package:cinemabooking/domain/data_request/home/movie_id_request.dart';
import 'package:cinemabooking/domain/data_request/home/movie_name_request.dart';
import 'package:cinemabooking/domain/repo_interface/movie_repo_interface.dart';

class MovieRepository implements IMovieRepository {
  final MovieApi movieApi = MovieApi();

  @override
  Future<List<MovieResponse>?> getAllMovies(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await movieApi.getAllMovies(
        baseUrl: serverUrl,
        path:
            "/movie/getAllMovie?page=$page&limit=$limit&orderby='desc'&option='today'",
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 200) {
          var list = responseData['data'] as List;
          if (list.isNotEmpty) {
            List<MovieResponse> moviesList = [];
            for (var i = 0; i < (list.length - 1); i++) {
              moviesList.add(MovieResponse.fromJson(list[i]));
            }
            return moviesList;
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<List<MovieResponse>?> search(MovieRequestByName movieRequestDTO,
      {int page = 1, int limit = 10}) async {
    try {
      final response = await movieApi.search(
        baseUrl: serverUrl,
        path: "/movie/searchMovie",
        data: movieRequestDTO.toJson(),
      );

      if (response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['status'] == 201) {
          var list = responseData['data'] as List;
          if (list.isNotEmpty) {
            List<MovieResponse> moviesList =
                list.map((i) => MovieResponse.fromJson(i)).toList();
            return moviesList;
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<MovieResponse?> getMovieById(
      MovieRequestById movieRequestByIdDto) async {
    try {
      final response = await movieApi.getMovieById(
        baseUrl: serverUrl,
        path: "/movie/getMovieId/${movieRequestByIdDto.movieId}",
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        var movieResponseDto = MovieResponse.fromJson(responseData['data']);
        return movieResponseDto;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<List<DateTime>?> getDailyDate() async {
    try {
      final response = await movieApi.getDailyDates(
        baseUrl: serverUrl,
        path: "/movie/getDailyDates",
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        var list = responseData['data'] as List;
        if (list.isNotEmpty) {
          List<DateTime> listDatetime = list
              .map((i) => DateTime.parse((i as String).substring(0, 10)))
              .toList();
          return listDatetime;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
