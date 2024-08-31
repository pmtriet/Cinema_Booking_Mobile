import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/common/widgets/textfield.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/repo/auth_repo.dart';
import 'package:cinemabooking/presentation/cubit/auth/login_cubit.dart';
import 'package:cinemabooking/presentation/pages/auth/validator/login_validator.dart';
import 'package:cinemabooking/presentation/states/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(authRepository: authRepository),
      child: const MaterialApp(
        home: LoginView(),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginValidator loginValidator = LoginValidator();

  @override
  void initState() {
    super.initState();

    // Listen to text changes of TextFormField
    emailController.addListener(() {
      loginValidator.emailSink.add(emailController.text);
    });
    passwordController.addListener(() {
      loginValidator.passwordSink.add(passwordController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    loginValidator.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(backgroundColor),
            body: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  context.go(RouteName.home);
                }
              },
              builder: (context, state) {
                switch (state){
                  case LoginInitialState(): 
                    return _loginWidget(context, null);
                  case LoginErrorState():
                    return _loginWidget(context, state.errorMessage);
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            )));
  }

  Widget _loginWidget(BuildContext context, String? errorResponse) {
    return Scaffold(
      backgroundColor: const Color(backgroundColor),
      appBar: AppBar(
        backgroundColor: const Color(backgroundColor),
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png'),
          onPressed: () {
            context.go(RouteName.welcome);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(appColor)),
              ),
              const SizedBox(
                height: 19,
              ),
              const Text(
                'Login now to track all your expenses and income at a place!',
                style: TextStyle(fontSize: 16, color: Color(textColor)),
              ),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder<String>(
                  stream: loginValidator.emailStream,
                  builder: (context, snapshot) {
                    return AppTextFormField(
                      labelText: 'Email',
                      icon: const Icon(
                        Icons.email,
                        color: Color(appColor),
                      ),
                      controller: emailController,
                      errorText: snapshot.data,
                      onTap: () {
                        context.read<LoginCubit>().validLogin();
                      },
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<String>(
                  stream: loginValidator.passwordStream,
                  builder: (context, snapshot) {
                    return AppTextFormField(
                      labelText: 'Password',
                      icon: const Icon(
                        Icons.key,
                        color: Color(appColor),
                      ),
                      controller: passwordController,
                      isPassword: true,
                      errorText: snapshot.data,
                      onTap: () {
                        context.read<LoginCubit>().validLogin();
                      },
                    );
                  }),
              const SizedBox(
                height: 30,
              ),
              errorResponse != null
                  ? Center(
                      child: Text(
                      errorResponse,
                      style: const TextStyle(color: Colors.red),
                    ))
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<bool>(
                  stream: loginValidator.btnStream,
                  builder: (context, snapshot) {
                    return AppButton(
                      title: "Login",
                      onTextButtonPressed: () {
                        snapshot.data == true
                            ? context.read<LoginCubit>().login(
                                emailController.text.trim(), passwordController.text)
                            : null;
                      },
                      enable: snapshot.data == true ? true : false,
                    );
                  }),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Color(textColor),
                          fontSize: 16,
                        ),
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: InkWell(
                            onTap: () {
                              context.go(RouteName.register);
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Color(appColor),
                                fontSize: 12,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
