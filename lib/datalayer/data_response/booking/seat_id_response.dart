class SeatIDsResponse {
  final int seatId;
  

  SeatIDsResponse({
    required this.seatId,
  });

  factory SeatIDsResponse.fromJson(Map<String, dynamic> json, int scheduleId) {
    return SeatIDsResponse(
      seatId: json['seatId'] as int,
    );
  }
}
/*
        } */