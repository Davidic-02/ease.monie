import 'package:esae_monie/extensions/build_context.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:esae_monie/blocs/auth/auth_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class ForgotPasswordScreen extends HookWidget {
  const ForgotPasswordScreen({super.key});
  static const String routeName = 'forgot_password';
  @override
  Widget build(BuildContext context) {
    final emailFocusNode = useFocusNode();

    return Scaffold(
      backgroundColor: const Color(0xFF23303B),
      body: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          return _buildWhen(context, previous, current);
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalSpaceSmall,

                    CustomTextFormField(
                      onChanged: (value) => context.read<AuthBloc>().add(
                        AuthEvent.forgotPasswordEmailChanged(value),
                      ),
                      errorText:
                          !state.forgotPasswordEmail.isPure &&
                              state.forgotPasswordEmail.isNotValid
                          ? "Please enter a valid email address"
                          : null,
                      focusNode: emailFocusNode,
                      hintText: 'Email Address',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      fillColor: AppColors.whiteColor,
                      onFieldSubmitted: (_) => context.read<AuthBloc>().add(
                        AuthEvent.forgotPassword(),
                      ),
                    ),
                    AppSpacing.verticalSpaceMedium,
                    Button(
                      'Send Reset Email',
                      busy:
                          state.forgotPasswordStatus ==
                          FormzSubmissionStatus.inProgress,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          AuthEvent.forgotPassword(),
                        );
                      },
                    ),
                  ],
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

  bool _buildWhen(BuildContext context, AuthState previous, AuthState current) {
    if (previous.forgotPasswordStatus != current.forgotPasswordStatus &&
        current.forgotPasswordStatus.isSuccess) {
      ToastService.toast(
        'If an account exists with this mail, a password reset link has been sent.',
        ToastType.success,
      );
      context.navigator.pop();
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      ToastService.toast('${current.errorMessage}', ToastType.error);
      context.read<AuthBloc>().add(const AuthEvent.errorMessage(null));
      return true;
    }
    if (previous.forgotPasswordStatus != current.forgotPasswordStatus) {
      return true;
    }

    if (previous.email != current.email) {
      return true;
    }

    return false;
  }
}
