class DatetimeResponse {
  final DateTime datetime;

  DatetimeResponse(
      {required this.datetime,});

  factory DatetimeResponse.fromJson(Map<String, dynamic> json) {
    return DatetimeResponse(
      datetime: json as DateTime,
    );
  }
}
