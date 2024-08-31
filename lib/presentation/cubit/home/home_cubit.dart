import 'dart:async';

import 'package:cinemabooking/domain/data_request/home/movie_name_request.dart';
import 'package:cinemabooking/domain/repo_interface/movie_repo_interface.dart';
import 'package:cinemabooking/presentation/states/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeCubit extends Cubit<HomeState> {
  final IMovieRepository movieRepository;
  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;

  HomeCubit({required this.movieRepository}) : super(HomeLoadingState()) {
    debounce();
  }

  final debounceSubject = BehaviorSubject<String>();

  Future<void> getAllMovies({int page = 1}) async {
    if (isLoading) return;
    try {
      isLoading = true;
      final movies = await movieRepository.getAllMovies(page: page);
      if (movies != null) {
        if (page == 1) {
          emit(HomeMoviesState(movies: movies));
        } else {
          final currentState = state;
          if (currentState is HomeMoviesState) {
            emit(HomeMoviesState(
                movies: currentState.movies + movies, isLoadingMore: false));
          }
        }
        currentPage = page;
        hasMore = movies.length == 10;
      } else {
        hasMore = false;
        if (page == 1) {
          emit(HomeEmptyMovieState());
        }
      }
    } catch (e) {
      emit(HomeSearchErrorState("Failed to get movies: ${e.toString()}"));
    } finally {
      isLoading = false;
    }
  }

  Future<void> searchMovie(String? movieName, {int page = 1}) async {
    if (isLoading) return;
    try {
      isLoading = true;
      if (movieName != null && movieName.isNotEmpty) {
        var movieRequestDTO = MovieRequestByName(movieName: movieName);
        final result = await movieRepository.search(movieRequestDTO);
        if (result != null) {
          if (page == 1) {
            emit(HomeMoviesState(movies: result));
          } else {
            final currentState = state;
            if (currentState is HomeMoviesState) {
              emit(HomeMoviesState(
                  movies: currentState.movies + result, isLoadingMore: false));
            }
          }
          currentPage = page;
          hasMore = result.length == 10;
        } else {
          hasMore = false;
          if (page == 1) {
            emit(HomeEmptyMovieState());
          }
        }
      } else {
        isLoading = false;
        await getAllMovies(page: page);
      }
    } catch (e) {
      emit(HomeSearchErrorState("Failed to get movies: ${e.toString()}"));
    } finally {
      isLoading = false;
    }
  }

  void loadMoreMovies(String? movieName) {
    if (hasMore && !isLoading) {
      emit(HomeMoviesState(
          movies: (state as HomeMoviesState).movies, isLoadingMore: true));
      if (movieName != null && movieName.isNotEmpty) {
        searchMovie(movieName, page: currentPage + 1);
      } else {
        getAllMovies(page: currentPage + 1);
      }
    }
  }

  void debounce() {
    debounceSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((searchTxt) {
      searchMovie(searchTxt);
    });
  }
   void onSearchTextChanged(String text) {
    debounceSubject.add(text);
  }
}
