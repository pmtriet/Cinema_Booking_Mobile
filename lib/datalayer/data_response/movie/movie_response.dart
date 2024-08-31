class MovieResponse {
  final int movieId;
  final String movieName;
  final String movieCategory;
  final String? movieUrl;

  final int? duration;
  final String? description;
  final String? release;
  final String? director;
  final String? actor;
  final String? imgUrl;

  MovieResponse(
      {required this.movieId,
      required this.movieName,
      required this.movieCategory,
      this.movieUrl,
      this.duration,
      this.description,
      this.release,
      this.director,
      this.actor,
      this.imgUrl});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    String releaseReponse = json['releaseDate'] as String;

    return MovieResponse(
      movieId: json['id'] as int,
      movieName: json['name'] as String,
      movieCategory: json['category']['name'] as String,
      movieUrl: json['urlTrailer'] as String,
      duration: json['duration'] as int,
      description: json['desc'] as String,
      release: releaseReponse.substring(0, 10),
      director: json['director'] as String,
      actor: json['actor'] as String,
      imgUrl: json['imagePath'] as String,
    );
  }
}
