class ScheduleRoomResponse {
  final int scheduleId;
  final String startTime;
  final String endTime;
  final int roomId;
  final String roomName;

  ScheduleRoomResponse({
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    required this.roomId,
    required this.roomName,
  });

  factory ScheduleRoomResponse.fromJson(Map<String, dynamic> json) {
    var roomResponse = json['room'] as Map<String, dynamic>;
    return ScheduleRoomResponse(
      scheduleId: json['id'] as int,
      startTime: json['timeStart'] as String,
      endTime: json['timeEnd'] as String,
      roomId: roomResponse['id'] as int,
      roomName: roomResponse['roomName'] as String,
    );
  }
}
