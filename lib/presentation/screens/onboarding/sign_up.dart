import 'package:esae_monie/blocs/onboarding/onboarding_bloc.dart';
import 'package:esae_monie/constants/app_colors.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/screens/onboarding/sign_In.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  static const String routeName = 'sign_up';
  @override
  Widget build(BuildContext context) {
    final nameFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();
    final mobileNumberFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();
    final confirmPasswordFocusNode = useFocusNode();
    final obscurePassword = useState(false);
    final obscureConfirmPassword = useState(false);
    final isChecked = useState(false);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      backgroundColor: const Color(0xFF23303B),
      body: BlocBuilder<OnBoardingBloc, OnBoardingState>(
        buildWhen: (previous, current) =>
            _signUpBuildWhen(context, previous, current),
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .2,
                        ),
                        const Center(
                          child: Text(
                            'Create Your Account',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: nameFocusNode,
                          hintText: 'Name',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          fillColor: AppColors.whiteColor,
                          errorText:
                              !state.fullName.isPure &&
                                  state.fullName.isNotValid
                              ? "Name must be at least 3 characters."
                              : null,
                          onFieldSubmitted: (_) =>
                              emailFocusNode.requestFocus(),
                          onChanged: (value) => context
                              .read<OnBoardingBloc>()
                              .add(OnBoardingEvent.fullNameChanged(value)),
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: emailFocusNode,
                          textInputAction: TextInputAction.next,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          fillColor: AppColors.whiteColor,
                          onFieldSubmitted: (_) =>
                              mobileNumberFocusNode.requestFocus(),
                          onChanged: (value) => context
                              .read<OnBoardingBloc>()
                              .add(OnBoardingEvent.emailChanged(value)),
                          errorText:
                              !state.email.isPure && state.email.isNotValid
                              ? "Please enter a valid email address"
                              : null,
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: mobileNumberFocusNode,
                          textInputAction: TextInputAction.next,
                          hintText: 'Mobile Number',
                          keyboardType: TextInputType.number,
                          fillColor: AppColors.whiteColor,
                          onFieldSubmitted: (_) =>
                              passwordFocusNode.requestFocus(),
                          onChanged: (value) => context
                              .read<OnBoardingBloc>()
                              .add(OnBoardingEvent.phoneNumberChanged(value)),
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.done,
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

                          onChanged: (value) => context
                              .read<OnBoardingBloc>()
                              .add(OnBoardingEvent.passwordChanged(value)),
                          onFieldSubmitted: (_) =>
                              confirmPasswordFocusNode.requestFocus(),
                        ),
                        AppSpacing.verticalSpaceSmall,
                        CustomTextFormField(
                          focusNode: confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          hintText: 'Confirm Password',
                          keyboardType: TextInputType.text,
                          fillColor: AppColors.whiteColor,
                          obscureText: !obscureConfirmPassword.value,
                          isPassword: true,
                          errorText:
                              (!state.passwordConfirm.isPure &&
                                  state.password.value !=
                                      state.passwordConfirm.value)
                              ? "Passwords do not match."
                              : null,
                          onSuffixIconPressed: () {
                            obscureConfirmPassword.value =
                                !obscureConfirmPassword.value;
                          },
                          onChanged: (value) =>
                              context.read<OnBoardingBloc>().add(
                                OnBoardingEvent.passwordConfirmChanged(value),
                              ),
                        ),
                        AppSpacing.verticalSpaceLarge,
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked.value,
                              activeColor: Colors.blue,
                              checkColor: Colors.white,
                              onChanged: (bool? newValue) {
                                isChecked.value = newValue ?? false;
                              },
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.verticalSpaceLarge,
                        Button(
                          'Sign Up',
                          onPressed: () {
                            context.read<OnBoardingBloc>().add(
                              OnBoardingEvent.signUp(),
                            );
                          },
                          busy:
                              state.signUpStatus ==
                              FormzSubmissionStatus.inProgress,
                        ),
                        AppSpacing.verticalSpaceMassive,
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "Already have an account? "),
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        Login.routeName,
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

  bool _signUpBuildWhen(
    BuildContext context,
    OnBoardingState previous,
    OnBoardingState current,
  ) {
    if (previous.signUpStatus != current.signUpStatus &&
        current.signUpStatus.isSuccess) {
      ToastService.toast('Sign Up Successful');
      return true;
    }

    if (previous.errorMessage != current.errorMessage &&
        current.errorMessage != null) {
      ToastService.toast('${current.errorMessage}', ToastType.error);
      context.read<OnBoardingBloc>().add(
        const OnBoardingEvent.errorMessage(null),
      );
      return true;
    }

    if (previous.signUpStatus != current.signUpStatus) {
      return true;
    }

    if (previous.email != current.email ||
        previous.fullName != current.fullName ||
        previous.password != current.password ||
        previous.passwordConfirm != current.passwordConfirm ||
        previous.phoneNumber != current.phoneNumber) {
      return true;
    }

    return false;
  }
}
