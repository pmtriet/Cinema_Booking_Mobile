import 'package:cinemabooking/datalayer/data_response/booking/seat_id_response.dart';
import 'package:cinemabooking/datalayer/data_response/booking/seat_response.dart';
import 'package:cinemabooking/presentation/pages/auth/login_page.dart';
import 'package:cinemabooking/presentation/pages/auth/register_page.dart';
import 'package:cinemabooking/presentation/pages/auth/welcome_page.dart';
import 'package:cinemabooking/presentation/pages/booking/booking_page.dart';
import 'package:cinemabooking/presentation/pages/detail/movie_detail.dart';
import 'package:cinemabooking/presentation/pages/home/home_page.dart';
import 'package:cinemabooking/presentation/pages/payment/payment_page.dart';
import 'package:cinemabooking/presentation/pages/schedule/schedule_page.dart';
import 'package:cinemabooking/presentation/pages/splash/splash_page.dart';
import 'package:cinemabooking/presentation/pages/ticket/ticket_page.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const String splash = '/splash';

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/';

  static const String movieDetail = '/movieDetail';
  static const String schedule = '/schedule';
  static const String booking = '/booking';

  static const String payment = '/payment';
  static const String ticket = '/ticket';
}

final router = GoRouter(
  initialLocation: RouteName.splash,
  routes: [
    GoRoute(
        path: RouteName.splash,
        builder: (context, state) => const SplashPage()),
    GoRoute(
      path: RouteName.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
        path: '${RouteName.movieDetail}/:movieId/:movieName',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['movieId']!);
          final movieName = state.pathParameters['movieName']!;
          return MovieDetailPage(
            movieId: movieId,
            movieName: movieName,
          );
        }),
    GoRoute(
        path: '${RouteName.schedule}/:movieId/:movieName',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['movieId']!);
          final movieName = state.pathParameters['movieName']!;
          return SchedulePage(
            movieId: movieId,
            movieName: movieName,
          );
        }),
    GoRoute(
        path:
            '${RouteName.booking}/:scheduleId/:movieName/:chosenDate/:startTime',
        builder: (context, state) {
          {
            final scheduleId = int.parse(state.pathParameters['scheduleId']!);
            final movieName = state.pathParameters['movieName']!;
            final chosenDate = state.pathParameters['chosenDate']!;
            final startTime = state.pathParameters['startTime']!;
            return BookingPage(
              scheduleId: scheduleId,
              movieName: movieName,
              chosenDate: chosenDate,
              startTime: startTime,
            );
          }
        }),
    GoRoute(
      path: RouteName.payment,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final scheduleId = extra['scheduleId'] as int;
        final chosenSeats = extra['chosenSeats'] as List<SeatResponse>;
        final roomName = extra['roomName'] as String;
        return PaymentPage(
          scheduleId: scheduleId,
          chosenSeats: chosenSeats,
          roomName: roomName,
        );
      },
    ),
    GoRoute(
        path: RouteName.ticket,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final scheduleId = extra['scheduleId'] as int;
          final chosenSeats = extra['chosenSeats'] as List<int>;
          final listChosenSeats = extra['listChosenSeats'] as List<SeatResponse>;
          final dataQr = extra['dataQr']!;
          final roomName = extra['roomName']!;
          final movieName = extra['movieName']!;
          final dateTime = extra['dateTime']!;
          final cost = extra['cost']!;
          final nameChosenSeats = extra['nameChosenSeats'] as List<String>;
          return TicketPage(
              dataQr: dataQr,
              scheduleId: scheduleId,
              chosenSeats: chosenSeats,
              listChosenSeats: listChosenSeats,
              roomName: roomName,
              movieName: movieName,
              dateTime: dateTime,
              cost: cost,
              nameChosenSeats: nameChosenSeats
              );
        }),
    // GoRoute(
    //     path: '${RouteName.ticket}/:dataQr',
    //     builder: (context, state) {
    //       final extra = state.extra as Map<String, dynamic>;
    //       final scheduleId = extra['scheduleId'] as int;
    //       final chosenSeats = extra['chosenSeats'] as List<SeatResponse>;
    //       final dataQr = state.pathParameters['dataQr']!;
    //       final roomName = extra['roomName']!;
    //       final movieName = extra['movieName']!;
    //       final dateTime = extra['dateTime']!;
    //       final cost = extra['cost']!;
    //       final nameChosenSeats = extra['nameChosenSeats'] as List<String>;
    //       return TicketPage(
    //           dataQr: dataQr,
    //           scheduleId: scheduleId,
    //           chosenSeats: chosenSeats,
    //           roomName: roomName,
    //           movieName: movieName,
    //           dateTime: dateTime,
    //           cost: cost,
    //           nameChosenSeats: nameChosenSeats);
    //     }),
  ],
);
