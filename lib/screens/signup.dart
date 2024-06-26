import 'dart:ui';

import 'package:ecommerce_app_isaatech/components/blur_container.dart';
import 'package:ecommerce_app_isaatech/components/buttons.dart';
import 'package:ecommerce_app_isaatech/components/social_icon_buttons_row.dart';
import 'package:ecommerce_app_isaatech/components/textfields.dart';
import 'package:ecommerce_app_isaatech/constants/images.dart';
import 'package:ecommerce_app_isaatech/screens/home/main_home.dart';
import 'package:ecommerce_app_isaatech/service/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;

  @override
  void initState() {
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0,
      upperBound: 45,
    );
    super.initState();
    _blurAnimationController.forward();
    _blurAnimationController.addListener(() {
      setState(() {});
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              Images.loginBg,
            ),
            fit: BoxFit.cover,
          )),
        ),
        BlurContainer(value: 50 - _blurAnimationController.value),
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
                // const PrimaryTextField(
                //   hintText: 'Name',
                //   prefixIcon: Icons.person,
                // ),
                PrimaryTextField(
                  hintText: 'Email address',
                  controller: emailController,
                  prefixIcon: CupertinoIcons.mail_solid,
                ),
                24.heightBox,
                24.heightBox,
                PrimaryTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  isObscure: true,
                  prefixIcon: CupertinoIcons.padlock,
                ),
                24.heightBox,

                // const PrimaryTextField(
                //   hintText: 'Phone',
                //   prefixIcon: CupertinoIcons.phone_fill,
                // ),
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
                      text: 'Create',
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          SignUpUser(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                        // Navigator.of(context).pushNamed(UserDashboard.id);
                      });
                }),
                const Spacer(),
                Text('Or create account using social media',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground)),
                24.heightBox,
                const SocialIconButtonsRow(),
              ],
            ).p(24),
          ),
        ),
      ]),
    );
  }

  Column _buildTitleText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Create account',
          softWrap: true,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
