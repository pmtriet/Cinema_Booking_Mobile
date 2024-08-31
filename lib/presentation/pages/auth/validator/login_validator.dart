import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LoginValidator {
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var emailValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      sink.add(validateEmail(email.trim()));
    },
  );

  var passwordValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      sink.add(validatePassword(password));
    },
  );

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation).skip(1);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passwordStream =>
      _passwordSubject.stream.transform(passwordValidation).skip(1);
  Sink<String> get passwordSink => _passwordSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  LoginValidator() {
    Rx.combineLatest2(_emailSubject, _passwordSubject, (email, password) {
      return validateEmail(email.trim()) == "" &&
          validatePassword(password) == "";
    }).listen((enable) {
      btnSink.add(enable);
    });
  }
  dispose() {
    _emailSubject.close();
    _passwordSubject.close();
    _btnSubject.close();
  }
}

String validateEmail(String email) {
  if (email == "") return "Email is required";
  var isValidEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email);
  if (!isValidEmail) return "Please enter a valid email address";
  return "";
}

String validatePassword(String password) {
  if (password == "") return "Password is required";
  if (password.length < 6) return "Password is at least 6 characters";
  return "";
}
