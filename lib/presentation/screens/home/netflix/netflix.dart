import 'package:esae_monie/blocs/netflix/netflix_bloc.dart';
import 'package:esae_monie/constants/app_spacing.dart';
import 'package:esae_monie/models/schedule_payments.dart';
import 'package:esae_monie/presentation/screens/home/netflix/netflix_payment_confirmation.dart';
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
    final payment =
        ModalRoute.of(context)!.settings.arguments as ScheduledPayment;

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
                AppSpacing.verticalSpaceMedium,
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    payment.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      payment.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      payment.dueDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                payment.amount.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'Payment for ${payment.name} is due soon. Make sure to pay on time to avoid service interruptions.',
                          style: const TextStyle(fontSize: 14),
                        ),

                        AppSpacing.verticalSpaceHuge,
                        TextTitle(text: 'Add Infomation'),

                        CustomTextFormField(
                          keyboardType: TextInputType.name,
                          focusNode: firstNameFocus,
                          hintText: 'First Name',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context.read<NetflixBloc>().add(
                            NetflixEvent.firstNameChanged(value),
                          ),
                          onFieldSubmitted: (_) => lastNameFocus.requestFocus(),
                          errorText:
                              !state.firstName.isPure &&
                                  state.firstName.isNotValid
                              ? 'Required'
                              : null,
                        ),

                        CustomTextFormField(
                          keyboardType: TextInputType.name,
                          focusNode: lastNameFocus,
                          hintText: 'Last Name',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => context.read<NetflixBloc>().add(
                            NetflixEvent.lastNameChanged(value),
                          ),
                          onFieldSubmitted: (_) => addressFocus.requestFocus(),
                          errorText:
                              !state.lastName.isPure &&
                                  state.lastName.isNotValid
                              ? 'Required'
                              : null,
                        ),

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
                                    .add(NetflixEvent.regionChanged(value)),

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

                        AppSpacing.verticalSpaceMassive,
                        TextTitle(text: 'Add Account Details'),

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

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Button(
                            'Send',
                            onPressed: state.isFormValid
                                ? () {
                                    context.read<NetflixBloc>().add(
                                      const NetflixEvent.submit(),
                                    );

                                    Navigator.pushNamed(
                                      context,
                                      NetflixPaymentConfirmation.routeName,
                                      arguments: payment,
                                    );
                                  }
                                : null,
                          ),
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
