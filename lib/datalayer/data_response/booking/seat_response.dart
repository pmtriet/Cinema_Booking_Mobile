class SeatResponse {
  final int seatId;
  final int scheduleId;
  final String seatName;
  int seatStatus; //0:available, 1: occupied,2:chosen
  final int seatType; //0:standard, 1: VIP
  final int seatPrice;

  SeatResponse({
    required this.seatId,
    required this.scheduleId,
    required this.seatName,
    required this.seatStatus,
    required this.seatType,
    required this.seatPrice,
  });

  factory SeatResponse.fromJson(Map<String, dynamic> json, int scheduleId) {
    var seatStatus = json['isReserved'] as bool;
    var seatType = json['type'] as String;
    return SeatResponse(
      seatId: json['seatId'] as int,
      scheduleId: scheduleId,
      seatName: json['name'] as String,
      seatStatus: (seatStatus ? 1 : 0),
      seatType: (seatType == "VIP" ? 1 : 0),
      seatPrice: json['price'] as int,
    );
  }
}
/*
        } */