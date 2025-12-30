import 'package:esae_monie/blocs/netflix/netflix_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/presentation/widgets/button.dart';
import 'package:esae_monie/presentation/widgets/custom_text_form_field.dart';
import 'package:esae_monie/presentation/widgets/custom_topbar.dart';
import 'package:esae_monie/presentation/widgets/text_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Netflix extends HookWidget {
  static const routeName = 'Netflix';

  const Netflix({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameFocus = useFocusNode();
    final lastNameFocus = useFocusNode();
    final addressFocus = useFocusNode();
    final stateFocus = useFocusNode();
    final postalFocus = useFocusNode();
    final cityFocus = useFocusNode();
    final countryFocus = useFocusNode();
    final cardNameFocus = useFocusNode();
    final cardNumberFocus = useFocusNode();
    final expiryFocus = useFocusNode();
    final cvvFocus = useFocusNode();

    return Scaffold(
      body: BlocBuilder<NetflixBloc, NetflixState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomTopbar(
                    title: 'Netflix',
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.verticalSpaceHuge,
                        TextTitle(text: 'Add Infomation'),
                        AppSpacing.verticalSpaceMedium,

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                keyboardType: TextInputType.name,
                                focusNode: firstNameFocus,
                                hintText: 'First Name',
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.firstNameChanged(value)),
                                onFieldSubmitted: (_) =>
                                    lastNameFocus.requestFocus(),
                                errorText:
                                    !state.firstName.isPure &&
                                        state.firstName.isNotValid
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            AppSpacing.horizontalSpaceSmall,
                            Expanded(
                              child: CustomTextFormField(
                                keyboardType: TextInputType.name,
                                focusNode: lastNameFocus,
                                hintText: 'Last Name',
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.lastNameChanged(value)),
                                onFieldSubmitted: (_) =>
                                    addressFocus.requestFocus(),
                                errorText:
                                    !state.lastName.isPure &&
                                        state.lastName.isNotValid
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.verticalSpaceMedium,

                        CustomTextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: addressFocus,
                          hintText: 'Address',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context.read<NetflixBloc>().add(
                            NetflixEvent.addressChanged(value),
                          ),
                          onFieldSubmitted: (_) => stateFocus.requestFocus(),
                          errorText:
                              !state.address.isPure && state.address.isNotValid
                              ? 'Required'
                              : null,
                        ),

                        AppSpacing.verticalSpaceMedium,

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                keyboardType: TextInputType.name,
                                focusNode: stateFocus,
                                hintText: 'State',
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.stateChanged(value)),
                                onFieldSubmitted: (_) =>
                                    postalFocus.requestFocus(),
                              ),
                            ),
                            AppSpacing.horizontalSpaceSmall,
                            Expanded(
                              child: CustomTextFormField(
                                focusNode: postalFocus,
                                hintText: 'Postal Code',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.postalCodeChanged(value)),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.verticalSpaceMedium,

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                keyboardType: TextInputType.name,
                                focusNode: cityFocus,
                                hintText: 'City',
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.cityChanged(value)),
                                onFieldSubmitted: (_) =>
                                    countryFocus.requestFocus(),
                              ),
                            ),
                            AppSpacing.horizontalSpaceSmall,
                            Expanded(
                              child: CustomTextFormField(
                                keyboardType: TextInputType.name,
                                focusNode: countryFocus,
                                hintText: 'Country',
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.countryChanged(value)),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.verticalSpaceHuge,
                        TextTitle(text: 'Add Account Details'),
                        AppSpacing.verticalSpaceMedium,

                        CustomTextFormField(
                          keyboardType: TextInputType.name,
                          focusNode: cardNameFocus,
                          hintText: 'Card Holder Name',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context.read<NetflixBloc>().add(
                            NetflixEvent.cardHolderNameChanged(value),
                          ),
                          onFieldSubmitted: (_) =>
                              cardNumberFocus.requestFocus(),
                        ),

                        AppSpacing.verticalSpaceMedium,

                        CustomTextFormField(
                          focusNode: cardNumberFocus,
                          hintText: 'Card Number',
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context.read<NetflixBloc>().add(
                            NetflixEvent.cardNumberChanged(value),
                          ),
                          onFieldSubmitted: (_) => expiryFocus.requestFocus(),
                        ),

                        AppSpacing.verticalSpaceMedium,

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                focusNode: expiryFocus,
                                hintText: 'MM/YY',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.expiryChanged(value)),
                                onFieldSubmitted: (_) =>
                                    cvvFocus.requestFocus(),
                              ),
                            ),
                            AppSpacing.horizontalSpaceSmall,
                            Expanded(
                              child: CustomTextFormField(
                                focusNode: cvvFocus,
                                hintText: 'CVV',
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                onChanged: (value) => context
                                    .read<NetflixBloc>()
                                    .add(NetflixEvent.cvvChanged(value)),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.verticalSpaceMassive,

                        Button(
                          'Send',
                          onPressed: state.isFormValid
                              ? () => context.read<NetflixBloc>().add(
                                  const NetflixEvent.submit(),
                                )
                              : null,
                        ),

                        AppSpacing.verticalSpaceHuge,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
