// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mvi/authentication_action.dart';
import '../mvi/authentication_bloc.dart';
import '../mvi/authentication_event.dart';
import '../mvi/authentication_state.dart';
import '../widgets/auth_text_field.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  late final AuthenticationBloc _bloc;
  late final StreamSubscription _eventSub;
  bool _obscurePassword = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AuthenticationBloc>();
    _eventSub = _bloc.events.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowAuthSuccessMessage():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
          // Navigate back after successful registration
          context.router.maybePop();
        case ShowAuthErrorMessage():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
      }
    });
  }

  @override
  void dispose() {
    _eventSub.cancel();
    _bloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    FocusScope.of(context).unfocus();

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.authPleaseSelectDob)));
      return;
    }

    _bloc.onAction(
      RegisterWithEmailAction(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _selectedDate!,
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appThemes;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: theme.surfaceColor,
        appBar: AppBar(title: Text(context.t.authCreateAccount), centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text(
                  context.t.authSignUpTitle,
                  textAlign: TextAlign.center,
                  style: theme.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  context.t.authCreateYourAccount,
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.copyWith(color: theme.textSecondaryColor),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        controller: _firstNameController,
                        label: context.t.authFirstName,
                        hintText: context.t.authFirstNameHint,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AuthTextField(
                        controller: _lastNameController,
                        label: context.t.authLastName,
                        hintText: context.t.authLastNameHint,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _emailController,
                  label: context.t.authEmail,
                  hintText: context.t.authEnterYourEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _phoneController,
                  label: context.t.authPhoneNumber,
                  hintText: context.t.authEnterYourPhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: context.t.authDateOfBirth,
                      hintText: context.t.authSelectYourBirthday,
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? context.t.authSelectDate
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: theme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordController,
                  label: context.t.authPassword,
                  hintText: context.t.authCreateAPassword,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                  ),
                  onSubmitted: (_) => _onRegisterPressed(),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    final isLoading = state is AuthenticationLoading;

                    return FilledButton(
                      onPressed: isLoading ? null : _onRegisterPressed,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.surfaceColor,
                              ),
                            )
                          : Text(context.t.authCreateAccount),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.t.authAlreadyHaveAccount, style: theme.bodyMedium),
                    TextButton(
                      onPressed: () => context.router.maybePop(),
                      child: Text(context.t.authLoginButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
