class MovieRequestById {
  final int movieId;
  MovieRequestById({required this.movieId});

  Map<String, dynamic> toJson() => {
        'movieId': movieId,
      };
}
