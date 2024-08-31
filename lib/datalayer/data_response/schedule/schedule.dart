class Schedule{
  final int scheduleId;
  final String startTime;
  final String endTime;

  Schedule( {required this.scheduleId, required this.startTime, required this.endTime});

   factory Schedule.fromJson(Map <String,dynamic> json){
    return Schedule(
      scheduleId: json['id'] as int,
      startTime: json['timeStart'] as String,
      endTime: json['timeEnd'] as String,
    );
  }
  factory Schedule.fromJsonWithDate(Map <String,dynamic> json,String scheduleDate){
    return Schedule(
      scheduleId: json['id'] as int,
      startTime: json['timeStart'] as String,
      endTime: json['timeEnd'] as String,
    );
  }
}