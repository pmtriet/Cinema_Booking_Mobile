class ScheduleRequest {
  final int scheduleId;
  ScheduleRequest({required this.scheduleId});

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
      };
}
