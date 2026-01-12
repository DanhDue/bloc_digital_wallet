// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_digital_wallet/di/injection.dart';
import '../mvi/authentication_action.dart';
import '../mvi/authentication_bloc.dart';
import '../mvi/authentication_event.dart';
import '../mvi/authentication_state.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final AuthenticationBloc _bloc;
  late final StreamSubscription<AuthenticationEvent> _eventSub;

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AuthenticationBloc>();
    _eventSub = _bloc.events.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowAuthSuccessMessage():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.message),
              backgroundColor: context.appThemes.primaryColor,
            ),
          );
          // Navigate back to login after showing success message
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              context.router.maybePop();
            }
          });
        case ShowAuthErrorMessage():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(event.message), backgroundColor: context.appThemes.errorColor),
          );
      }
    });
  }

  @override
  void dispose() {
    _eventSub.cancel();
    _bloc.close();
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmitPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _bloc.onAction(ForgotPasswordAction(_emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appThemes;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: theme.surfaceColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.router.maybePop(),
                      icon: Icon(Icons.arrow_back, color: theme.textPrimaryColor),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.backgroundColor,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    context.t.authForgotPasswordTitle,
                    style: theme.headlineMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    context.t.authForgotPasswordSubtitle,
                    style: theme.bodyMedium.copyWith(color: theme.textSecondaryColor),
                  ),
                  const SizedBox(height: 32),
                  // Email label
                  Text(
                    context.t.authForgotPasswordEmailLabel,
                    style: theme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Email input field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: context.t.authForgotPasswordEmailHint,
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: theme.surfaceColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.t.authInvalidEmailFormat;
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return context.t.authInvalidEmailFormat;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmitPressed(),
                  ),
                  const SizedBox(height: 32),
                  // Submit button
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      final isLoading = state is AuthenticationLoading;

                      return FilledButton(
                        onPressed: isLoading ? null : _onSubmitPressed,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            : Text(
                                context.t.authForgotPasswordSubmitButton,
                                style: theme.titleMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.surfaceColor,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
