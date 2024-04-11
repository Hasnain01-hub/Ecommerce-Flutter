import 'dart:ui';

import 'package:ecommerce_app_isaatech/components/blur_container.dart';
import 'package:ecommerce_app_isaatech/components/buttons.dart';
import 'package:ecommerce_app_isaatech/components/textfields.dart';
import 'package:ecommerce_app_isaatech/constants/images.dart';
import 'package:ecommerce_app_isaatech/screens/home/main_home.dart';
import 'package:ecommerce_app_isaatech/screens/signup.dart';
import 'package:ecommerce_app_isaatech/service/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0,
      upperBound: 6,
    );
    super.initState();
    _blurAnimationController.forward();
    _blurAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    _blurAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              print(snapshot);
              print("*((*(*((*)))))");
              if (snapshot.hasData) {
                return UserDashboard();
              } else {
                return Stack(children: [
                  Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        Images.loginBg,
                      ),
                      fit: BoxFit.cover,
                    )),
                  ),
                  BlurContainer(value: _blurAnimationController.value),
                  SafeArea(
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          double.infinity.widthBox,
                          const Spacer(),
                          const Spacer(),
                          _buildTitleText(context),
                          const Spacer(),
                          PrimaryTextField(
                            hintText: 'Email',
                            prefixIcon: Icons.person,
                            controller: emailController,
                          ),
                          24.heightBox,
                          PrimaryTextField(
                            hintText: 'Password',
                            isObscure: true,
                            controller: passwordController,
                            prefixIcon: CupertinoIcons.padlock,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Forgot your password?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              24.widthBox,
                            ],
                          ),
                          const Spacer(),
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                              listener: (context, state) {
                            if (state is AuthenticationSuccessState) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                UserDashboard.id,
                                (route) => false,
                              );
                            } else if (state is AuthenticationFailureState) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('error'),
                                    );
                                  });
                            }
                          }, builder: (context, state) {
                            return AuthButton(
                                text: 'Sign In',
                                onPressed: () {
                                  // Navigator.of(context).pushNamed(UserDashboard.id);
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    SignInUser(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    ),
                                  );
                                });
                          }),
                          const Spacer(),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Don\'t have an account?  ',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                              TextSpan(
                                  text: 'Create',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigator.of(context).pushNamed(SignUpScreen.id);
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(
                                        SignInUser(
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        ),
                                      );
                                    }),
                            ]),
                          ),
                        ],
                      ).p(24),
                    ),
                  ),
                ]);
              }
            }));
  }

  Column _buildTitleText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello',
          softWrap: true,
          style: TextStyle(
              fontSize: 85,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        Text(
          'Sign in to your account',
          softWrap: true,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
