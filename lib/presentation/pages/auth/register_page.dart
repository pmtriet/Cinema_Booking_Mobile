import 'package:cinemabooking/common/widgets/button.dart';
import 'package:cinemabooking/common/widgets/textfield.dart';
import 'package:cinemabooking/config/route.dart';
import 'package:cinemabooking/config/ui.dart';
import 'package:cinemabooking/datalayer/repo/auth_repo.dart';
import 'package:cinemabooking/presentation/cubit/auth/register_cubit.dart';
import 'package:cinemabooking/presentation/pages/auth/validator/register_validator.dart';
import 'package:cinemabooking/presentation/states/auth/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(authRepository: authRepository),
      child: const MaterialApp(
        home: RegisterView(),
      ),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterValidator registerValidator = RegisterValidator();

  @override
  void initState() {
    super.initState();
    // Listen to text changes of TextFormField
    emailController.addListener(() {
      registerValidator.emailSink.add(emailController.text);
    });
    nameController.addListener(() {
      registerValidator.nameSink.add(nameController.text);
    });
    passwordController.addListener(() {
      registerValidator.passwordSink.add(passwordController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    registerValidator.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(backgroundColor),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              context.go(RouteName.login);
            }
          },
          builder: (context, state) {
            switch (state){
              case RegisterInitialState():
                return _registerView(context, null);
              case RegisterErrorState():
                return _registerView(context, state.errorMessage);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _registerView(BuildContext context, String? errorResponse) {
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
                'Register',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(appColor)),
              ),
              const SizedBox(
                height: 19,
              ),
              const Text(
                'Create an account to access all the features of Maxpense!',
                style: TextStyle(fontSize: 16, color: Color(textColor)),
              ),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder<String>(
                  stream: registerValidator.emailStream,
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
                          context.read<RegisterCubit>().validRegister();
                        });
                  }),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<String>(
                  stream: registerValidator.nameStream,
                  builder: (context, snapshot) {
                    return AppTextFormField(
                        labelText: 'Name',
                        icon: const Icon(
                          Icons.person,
                          color: Color(appColor),
                        ),
                        controller: nameController,
                        errorText: snapshot.data,
                        onTap: () {
                          context.read<RegisterCubit>().validRegister();
                        });
                  }),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<String>(
                  stream: registerValidator.passwordStream,
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
                          context.read<RegisterCubit>().validRegister();
                        });
                  }),
              const SizedBox(
                height: 20,
              ),
              errorResponse != null
                  ? Center(
                      child: Text(
                        errorResponse,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<bool>(
                  stream: registerValidator.btnStream,
                  builder: (context, snapshot) {
                    return AppButton(
                      title: "Register",
                      onTextButtonPressed: () {
                        snapshot.data == true
                            ? context.read<RegisterCubit>().register(
                                emailController.text.trim(),
                                nameController.text.trim(),
                                passwordController.text)
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
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color(textColor),
                          fontSize: 16,
                        ),
                      ),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: InkWell(
                            onTap: () {
                              context.go(RouteName.login);
                            },
                            child: const Text(
                              'Login',
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
