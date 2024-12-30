// import 'package:cinemabooking/common/widgets/infor_row.dart';
// import 'package:cinemabooking/config/route.dart';
// import 'package:cinemabooking/config/ui.dart';
// import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
// import 'package:cinemabooking/datalayer/repo/ticket_repo.dart';
// import 'package:cinemabooking/presentation/cubit/ticket/ticket_cubit.dart';
// import 'package:cinemabooking/presentation/cubit/ticket/ticket_page_cubit.dart';
// import 'package:cinemabooking/presentation/pages/ticket/qr_generator.dart';
// import 'package:cinemabooking/presentation/states/ticket/ticket_page_state.dart';
// import 'package:cinemabooking/presentation/states/ticket/ticket_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class TicketPage extends StatelessWidget {
//   const TicketPage(
//       {super.key,
//       required this.dataQr,
//       required this.scheduleId,
//       required this.chosenSeats,
//       required this.roomName,
//       required this.movieName,
//       required this.dateTime,
//       required this.cost,
//       required this.nameChosenSeats});
//   final String dataQr;
//   final int scheduleId;
//   final List<SeatResponse> chosenSeats;
//   final List<String> nameChosenSeats;

//   final String roomName;
//   final String movieName;
//   final String dateTime;
//   final String cost;

//   @override
//   Widget build(BuildContext context) {
//     final ticketRepository = TicketPageRepository();
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) =>
//               TicketPageCubit(ticketRepository: ticketRepository),
//         ),
//         BlocProvider(
//           create: (context) => TicketCubit(),
//         )
//       ],
//       child: MaterialApp(
//         home: TicketView(
//           dataQr: dataQr,
//           chosenSeats: chosenSeats,
//           scheduleId: scheduleId,
//           roomName: roomName,
//           movieName: movieName,
//           dateTime: dateTime,
//           cost: cost,
//           nameChosenSeats: nameChosenSeats,
//         ),
//       ),
//     );
//   }
// }

// class TicketView extends StatefulWidget {
//   const TicketView(
//       {super.key,
//       required this.dataQr,
//       required this.scheduleId,
//       required this.chosenSeats,
//       required this.roomName,
//       required this.movieName,
//       required this.dateTime,
//       required this.cost,
//       required this.nameChosenSeats});
//   final String dataQr;
//   final List<SeatResponse> chosenSeats;
//   final int scheduleId;

//   final String roomName;
//   final String movieName;
//   final String dateTime;
//   final String cost;
//   final List<String> nameChosenSeats;

//   @override
//   TicketViewState createState() => TicketViewState();
// }

// class TicketViewState extends State<TicketView> {
//   @override
//   void initState() {
//     super.initState();

//     BlocProvider.of<TicketPageCubit>(context)
//         .payment(widget.scheduleId, widget.chosenSeats);
//   }

//   void _showPaymentDialog(BuildContext context, bool paymentSuccess) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Lottie.asset(
//                 paymentSuccess
//                     ? 'assets/animations/success.json'
//                     : 'assets/animations/error.json',
//                 fit: BoxFit.fill,
//               ),
//               Text(
//                 paymentSuccess ? 'Congrates' : 'Oops!',
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 paymentSuccess
//                     ? 'Booking successfully'
//                     : 'Something went wrong',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               CupertinoDialogAction(
//                 onPressed: paymentSuccess
//                     ? () {
//                         context.pop();
//                       }
//                     : () {
//                         for (var i = 0; i < 4; i++) {
//                           context.pop();
//                         }
//                       },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(appColor),
//                     borderRadius: BorderRadius.circular(6.0),
//                   ),
//                   height: 40,
//                   width: 100,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 5,
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "OK",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           elevation: 24,
//         );
//       },
//     );
//   }

//   void _showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           backgroundColor: Color.fromARGB(85, 255, 255, 255),
//           content: Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//           elevation: 24,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: BlocConsumer<TicketPageCubit, TicketPageState>(
//           listener: (context, state) {
//         if (state is PaymentPageTicketState) {
//           context.read<TicketCubit>().showTicket();
//           _showPaymentDialog(context, true);
//         } else if (state is TicketPageErrorState) {
//           _showPaymentDialog(context, false);
//         } else if (state is TicketPageLoadingState) {
//           _showLoadingDialog(context);
//         }
//       }, builder: (context, state) {
//         if (state is TicketPageInitialState) {
//           return pageWidget(false);
//         } else {
//           return pageWidget(true);
//         }
//       }),
//     );
//   }

//   Widget pageWidget(bool paymentSuccess) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text(
//               paymentSuccess ? 'Your Ticket' : 'Payment',
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: const Color(backgroundColor),
//             centerTitle: true,
//             actions: [
//               paymentSuccess
//                   ? IconButton(
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         context.go(RouteName.home);
//                       },
//                     )
//                   : const SizedBox.shrink(),
//             ]),
//         backgroundColor: const Color(backgroundColor),
//         body: PopScope(
//           canPop: false,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       paymentSuccess
//                           ? const Center(child: QRGenerator(data: 'Your ticket'))
//                           : Center(child: QRGenerator(data: widget.dataQr)),
//                       paymentSuccess
//                           ? const SizedBox.shrink()
//                           : const Center(
//                               child: Text(
//                                 'Scan QR for payment',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                       BlocBuilder<TicketCubit, TicketState>(
//                         builder: (context, state) {
//                           if (state is TicketShowState) {
//                             return ticketWidget();
//                           } else {
//                             return const SizedBox.shrink();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   Widget ticketWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 40,
//         ),
//         Text(
//           widget.movieName,
//           style: const TextStyle(
//               color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         InfoRow(label: 'Room', value: widget.roomName),
//         InfoRow(label: 'Date', value: widget.dateTime),
//         InfoRow(label: 'Cost', value: widget.cost),
//         Column(
//           children: List.generate(widget.nameChosenSeats.length, (index) {
//             return InfoRow(
//               label: index == 0 ? 'Seats' : null,
//               value: widget.nameChosenSeats[index],
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:cinemabooking/config/sever_url.dart';
import 'package:cinemabooking/datalayer/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';

// Lớp để đóng gói các tham số truyền vào (nếu sử dụng)
class TicketArguments {
  final int scheduleId;
  final List<int> chosenSeats;

  TicketArguments({
    required this.scheduleId,
    required this.chosenSeats,
  });
}

class TicketPage extends StatefulWidget {
  final int scheduleId; // ID lịch chiếu
  final List<int> chosenSeats; // Danh sách seatId đã chọn

  const TicketPage({
    super.key,
    required this.scheduleId,
    required this.chosenSeats,
  });

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String? paymentUrl;
  bool isLoading = true;
  final Dio _dio = DioClient.getInstance(); // Khởi tạo Dio

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Hiển thị loading khi bắt đầu tải trang
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            // Ẩn loading khi tải xong trang
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('$serverFEUrl/payment-info')) {
              // Xử lý kết quả thanh toán
              _handlePaymentResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    createPayment();
  }

  Future<void> createPayment() async {
    const String bookingApiUrl =
        '$serverUrl/booking'; // URL API booking của bạn

    try {
      // Gọi API booking với scheduleId và chosenSeats
      Response bookingResponse = await _dio.post(
        bookingApiUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode({
          'scheduleId': widget.scheduleId,
          'seatIds': widget.chosenSeats,
        }),
      );
      print('Booking response status: ${bookingResponse.statusCode}');
      print('Booking response data: ${bookingResponse.data}');

      if (bookingResponse.statusCode == 201) {
        final responseData = bookingResponse.data;

        // Kiểm tra xem data có tồn tại không
        if (responseData != null && responseData['data'] != null) {
          String paymentUrlFromBooking = responseData['data'];
          print('Payment URL: $paymentUrlFromBooking');

          setState(() {
            paymentUrl = paymentUrlFromBooking;
            isLoading = false;
          });

          // Load URL vào WebView
          if (paymentUrl != null) {
            _controller.loadRequest(Uri.parse(paymentUrl!));
          }
        } else {
          // data không tồn tại trong phản hồi
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không nhận được URL thanh toán từ server')),
          );
        }
      } else {
        // Xử lý lỗi khi gọi API booking
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt vé thất bại')),
        );
      }
    } catch (e) {
      // Xử lý ngoại lệ
      setState(() {
        isLoading = false;
      });
      print('Error in createPayment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  void _handlePaymentResult(String url) {
    // Phân tích URL để lấy thông tin thanh toán
    Uri uri = Uri.parse(url);
    String? responseCode = uri.queryParameters['vnp_ResponseCode'];

    print('vnp_ResponseCode: $responseCode');

    String message;
    if (responseCode == '00') {
      message = 'Thanh toán thành công!';
      // Cập nhật trạng thái đơn hàng trên hệ thống của bạn tại đây
    } else {
      message = 'Thanh toán thất bại. Mã lỗi: $responseCode';
      // Xử lý thất bại thanh toán tại đây
    }

    // Hiển thị thông báo cho người dùng
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kết Quả Thanh Toán'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng hộp thoại
              context.go('/'); // Quay lại trang trước bằng go_router
              // Hoặc chuyển hướng đến trang thành công
              // context.go('/success');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
      ),
      body: Stack(
        children: [
          if (paymentUrl != null)
            WebViewWidget(controller: _controller)
          else
            const Center(child: Text('Không thể tạo URL thanh toán')),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
