import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/common/widgets/infor_row.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/data_response/movie/movie_response.dart';
import 'package:cinemabooking/datalayer/repo/movie_repo.dart';
import 'package:cinemabooking/presentation/cubit/detail/movie_detail_cubit.dart';
import 'package:cinemabooking/presentation/pages/detail/video_player.dart';
import 'package:cinemabooking/presentation/states/detail/movie_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage(
      {super.key, required this.movieId, required this.movieName});
  final int movieId;
  final String movieName;

  @override
  Widget build(BuildContext context) {
    final movieRepository = MovieRepository();

    return BlocProvider(
      create: (_) => MovieDetailCubit(movieRepository: movieRepository),
      child: MaterialApp(
        home: MovieDetailView(
          movieId: movieId,
          movieName: movieName,
        ),
      ),
    );
  }
}

class MovieDetailView extends StatelessWidget {
  const MovieDetailView(
      {super.key, required this.movieId, required this.movieName});
  final int movieId;
  final String movieName;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<VideoPlayerState> videoPlayerKey =
        GlobalKey<VideoPlayerState>();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          movieName,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(backgroundColor),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(appColor),
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      backgroundColor: const Color(backgroundColor),
      body: Center(
        child: BlocConsumer<MovieDetailCubit, MovieDetailState>(
          listener: (context, state) {
            if (state is MovieDetailInitialState) {
              context.read<MovieDetailCubit>().getMovieById(movieId);
            }
          },
          builder: (context, state) {
            switch (state){
              case MovieDetailLoadingState():
                context.read<MovieDetailCubit>().getMovieById(movieId);
                return const Center(child: CircularProgressIndicator());
              case MovieDetailSuccessState():
                return _movieDetailWidget(context, state.movie, videoPlayerKey);
              case MovieDetailErrorState():
                return _errorWidget(state.errorMessage);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ));
  }

  Widget _movieDetailWidget(BuildContext context, MovieResponse movie,
      GlobalKey<VideoPlayerState> videoPlayerKey) {
    double width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          SizedBox(
            width: width,
            child: movie.movieUrl != null
                ? VideoPlayer(
                    key: videoPlayerKey,
                    movieTrailer: movie.movieUrl!,
                  )
                : VideoPlayer(
                    key: videoPlayerKey,
                    movieTrailer: null,
                  ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        movie.description ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      InfoRow(
                          label: 'Runtime',
                          value: movie.release != null
                              ? '${movie.duration} (min)'
                              : ""),
                      InfoRow(
                          label: 'Release',
                          value:
                              movie.release != null ? '${movie.release}' : ""),
                      InfoRow(label: 'Category', value: movie.movieCategory),
                      InfoRow(
                          label: 'Director',
                          value: movie.director != null
                              ? '${movie.director}'
                              : ""),
                      InfoRow(
                        label: 'Cast',
                        value: movie.actor != null ? '${movie.actor}' : "",
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: const Color(backgroundColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AppButton(
                        title: "Select session",
                        onTextButtonPressed: () {
                          videoPlayerKey.currentState?.pause();
                          context.push(
                              '${RouteName.schedule}/${movie.movieId}/${movie.movieName}');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget(String? errorMessage) {
    return Center(
      child: errorMessage != null
          ? const Text(
              'Error to get movie',
              style: TextStyle(color: Colors.white),
            )
          : Text(errorMessage!),
    );
  }
}
