// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_digital_wallet/config/theme/app_themes.dart';
import 'package:bloc_digital_wallet/di/injection.dart';
import 'package:bloc_digital_wallet/generated/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'code_verification_action.dart';
import 'code_verification_bloc.dart';
import 'code_verification_event.dart';
import 'code_verification_state.dart';

@RoutePage()
class CodeVerificationPage extends StatefulWidget {
  const CodeVerificationPage({super.key});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late final CodeVerificationBloc _bloc;
  late final StreamSubscription<CodeVerificationEvent> _eventSub;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CodeVerificationBloc>();
    _eventSub = _bloc.events.listen((event) {
      if (!mounted) return;
      switch (event) {
        case ShowCodeVerificationSuccessMessage():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(event.message), backgroundColor: Colors.green));
        case ShowCodeVerificationErrorMessage():
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(event.message), backgroundColor: Colors.red));
        case NavigateToSetNewPassword():
          // TODO: Navigate to Set New Password screen
          // context.router.push(const SetNewPasswordRoute());
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Navigate to Set New Password')));
      }
    });
  }

  @override
  void dispose() {
    _eventSub.cancel();
    _bloc.close();
    _codeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (_codeController.text.length != 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.authCodeFormatInvalid)));
      return;
    }
    _bloc.onAction(VerifyCodeAction(_codeController.text));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
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
                const SizedBox(height: 148), // Spacing from top as per Figma
                Text(
                  context.t.authCheckYourEmail,
                  textAlign: TextAlign.center,
                  style: theme.headlineSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.t.authEnterCodeInstruction,
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium.copyWith(color: theme.textSecondaryColor),
                ),
                const SizedBox(height: 32),
                // Code Input
                Center(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 5,
                      style: theme.headlineMedium.copyWith(letterSpacing: 10),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '00000',
                        hintStyle: theme.headlineMedium.copyWith(
                          letterSpacing: 10,
                          color: Colors.grey.shade300,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSubmitted: (_) => _onVerifyPressed(),
                    ),
                  ),
                ),
                const SizedBox(height: 340 - 148 - 32 - 60 - 32), // Spacer to Verify Button
                BlocBuilder<CodeVerificationBloc, CodeVerificationState>(
                  builder: (context, state) {
                    final isLoading = state is CodeVerificationLoading;

                    return FilledButton(
                      onPressed: isLoading ? null : _onVerifyPressed,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: theme.primaryColor,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              context.t.authVerifyCode,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Resend logic
                    },
                    child: Text(
                      context.t.authResendEmail,
                      style: TextStyle(
                        color: theme.textSecondaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
