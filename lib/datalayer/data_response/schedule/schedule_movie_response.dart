class ScheduleMovieResponse {
  final int scheduleId;
  final String startTime;
  final String endTime;
  final String date;
  final String movieName;

  ScheduleMovieResponse({
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.movieName,
  });

  factory ScheduleMovieResponse.fromJson(Map<String, dynamic> json) {
    var movieResponse = json['movie'] as Map<String, dynamic>;
    return ScheduleMovieResponse(
      scheduleId: json['id'] as int,
      startTime: json['timeStart'] as String,
      endTime: json['timeEnd'] as String,
      date: json['date'] as String,
      movieName: movieResponse['name'] as String,
    );
  }
}
