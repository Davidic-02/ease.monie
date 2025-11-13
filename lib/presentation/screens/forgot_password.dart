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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isResetEmailSent) {
            ToastService.toast('Password reset email sent successfully!');
          }

          if (state.errorMessage != null) {
            ToastService.toast(state.errorMessage!, ToastType.error);
            context.read<AuthBloc>().add(AuthEvent.clearError(null));
          }
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
                      //  controller: emailController,
                      onChanged: (value) => context.read<AuthBloc>().add(
                        AuthEvent.emailChanged(value),
                      ),
                      errorText: !state.email.isPure && state.email.isNotValid
                          ? "Please enter a valid email address"
                          : null,
                      focusNode: emailFocusNode,
                      hintText: 'Email Address',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      fillColor: AppColors.whiteColor,
                    ),
                    AppSpacing.verticalSpaceMedium,
                    Button(
                      'Send Reset Email',
                      busy:
                          state.resetPasswordStatus ==
                          FormzSubmissionStatus.inProgress,
                      onPressed: state.email.isValid
                          ? () {
                              //  final email = emailController.text.trim();
                              context.read<AuthBloc>().add(
                                AuthEvent.forgotPasswordRequested(
                                  state.email.value,
                                ),
                              );
                            }
                          : null,
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
}
