class ScheduleRequestByMovieIdFollowDay {
  final int movieId;
  final String day;
  ScheduleRequestByMovieIdFollowDay({required this.movieId, required this.day});

  Map<String, dynamic> toJson() => {
        'movieId': movieId,
        'date': day,
      };
}
