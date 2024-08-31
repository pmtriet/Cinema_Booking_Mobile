class MovieRequestByName {
  final String movieName;
  MovieRequestByName({required this.movieName});

  Map<String, dynamic> toJson() => {
        'name': movieName,
      };
}
