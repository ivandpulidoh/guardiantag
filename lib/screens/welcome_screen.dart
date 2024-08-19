import 'package:flutter/material.dart';
import 'package:google_maps_yt/screens/signin_screen.dart';
import 'package:google_maps_yt/screens/singup_screen.dart';
import 'package:google_maps_yt/theme/theme.dart';
import 'package:google_maps_yt/widgets/custom_scaffold.dart';
import 'package:google_maps_yt/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome Back!\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                                '\nEnter personal details to your employee account',
                            style: TextStyle(
                              fontSize: 20,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SigninScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SingupScreen(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
