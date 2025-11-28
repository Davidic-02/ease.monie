import 'package:esae_monie/blocs/auth/auth_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_up.dart';
import 'package:esae_monie/presentation/widgets/bottom_navbar.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:esae_monie/presentation/screens/auth/forgot_password.dart';

class Login extends HookWidget {
  const Login({super.key});

  static const String routeName = 'login';
  @override
  Widget build(BuildContext context) {
    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final obscurePassword = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      backgroundColor: const Color(0xFF23303B),
      body: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            _loginBuildWhen(context, previous, current),
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .3,
                        ),
                        const Center(
                          child: Text(
                            'Login to Your Account',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: emailFocusNode,
                          hintText: 'Email',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          fillColor: AppColors.whiteColor,
                          onChanged: (value) => context.read<AuthBloc>().add(
                            AuthEvent.emailChanged(value),
                          ),
                          errorText:
                              !state.email.isPure && state.email.isNotValid
                              ? "Please enter a valid email address"
                              : null,
                        ),

                        AppSpacing.verticalSpaceSmall,

                        CustomTextFormField(
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.send,
                          hintText: 'Password',
                          keyboardType: TextInputType.text,
                          fillColor: AppColors.whiteColor,
                          obscureText: !obscurePassword.value,
                          isPassword: true,
                          errorText:
                              !state.password.isPure &&
                                  state.password.isNotValid
                              ? "Password must be at least 6 characters."
                              : null,
                          onSuffixIconPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                          onFieldSubmitted: (_) => context.read<AuthBloc>().add(
                            const AuthEvent.login(),
                          ),
                          onChanged: (value) => context.read<AuthBloc>().add(
                            AuthEvent.passwordChanged(value),
                          ),
                        ),

                        AppSpacing.verticalSpaceLarge,

                        Button(
                          'Login',
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              const AuthEvent.login(),
                            );
                          },

                          busy:
                              state.loginStatus ==
                              FormzSubmissionStatus.inProgress,
                        ),
                        AppSpacing.verticalSpaceHuge,
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              ForgotPasswordScreen.routeName,
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .3,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),

                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        SignUpScreen.routeName,
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                child: SvgPicture.asset('assets/svgs/ellipse.svg'),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _loginBuildWhen(
    BuildContext context,
    AuthState previous,
    AuthState current,
  ) {
    if (previous.loginStatus != current.loginStatus &&
        current.loginStatus.isSuccess) {
      ToastService.toast('Welcome!');

      context.navigator.pushNamedAndRemoveUntil(
        MainScreen.routeName,
        (route) => false,
      );
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      ToastService.toast(
        current.errorMessage ?? 'Something went wrong',
        ToastType.error,
      );
      return true;
    }
    if (previous.loginStatus != current.loginStatus) {
      return true;
    }

    if (previous.email != current.email ||
        previous.password != current.password) {
      return true;
    }

    return false;
  }
}
