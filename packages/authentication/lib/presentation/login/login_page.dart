// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import 'package:authentication/generated/translations.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import 'login_action.dart';
import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

/// ============================================================================
/// Login Page - MVI Pattern Implementation
/// ============================================================================
/// Extends BaseMviPage for automatic BLoC lifecycle management.
/// Implements handleState for UI rendering and handleEvent for side effects.
/// ============================================================================

@RoutePage()
class LoginPage extends BaseMviPage<LoginBloc, LoginAction, LoginState, LoginEvent> {
  const LoginPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildScaffold(BuildContext context) {
    // Override to remove Scaffold since we handle it in handleState
    return buildBody(context);
  }

  @override
  Widget handleState(BuildContext context, LoginState state) {
    return _LoginPageContent(state: state);
  }

  @override
  void handleEvent(BuildContext context, LoginEvent event) {
    switch (event) {
      case NavigateToHome():
        // Replace login screen with home/shell (can't go back)
        // context.router.replaceAll([const ShellRoute()]);
        break;
      case ShowLoginSuccessMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      case ShowLoginErrorMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

/// ============================================================================
/// Login Page Content - Stateful UI for form handling
/// ============================================================================
/// Contains form controllers and local UI state (password visibility).
/// ============================================================================

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent({required this.state});

  final LoginState state;

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    context.read<LoginBloc>().onAction(
      LoginWithEmailPasswordAction(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appThemes;
    final isLoading = widget.state is LoginLoading;

    return Scaffold(
      backgroundColor: theme.surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _buildHeader(theme),
              const SizedBox(height: 24),
              _buildEmailField(theme),
              const SizedBox(height: 14),
              _buildPasswordField(theme),
              const SizedBox(height: 10),
              _buildForgotPasswordButton(),
              const SizedBox(height: 10),
              _buildLoginButton(theme, isLoading),
              const SizedBox(height: 18),
              _buildDivider(theme),
              const SizedBox(height: 16),
              _buildSocialLoginButtons(),
              const SizedBox(height: 18),
              _buildRegisterRow(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppThemes theme) {
    return Column(
      children: [
        Center(
          child: Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_circle, color: theme.primaryColor, size: 54),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          context.tAuth.authentication.login.welcomeBack,
          textAlign: TextAlign.center,
          style: theme.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          context.tAuth.authentication.login.loginToContinue,
          textAlign: TextAlign.center,
          style: theme.bodyMedium.copyWith(color: theme.textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildEmailField(AppThemes theme) {
    return AuthTextField(
      controller: _emailController,
      label: context.tAuth.authentication.login.email,
      hintText: context.tAuth.authentication.login.enterYourEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
    );
  }

  Widget _buildPasswordField(AppThemes theme) {
    return AuthTextField(
      controller: _passwordController,
      label: context.tAuth.authentication.login.password,
      hintText: context.tAuth.authentication.login.enterYourPassword,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      ),
      onSubmitted: (_) => _onLoginPressed(),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // context.router.push(const ForgotPasswordRoute());
        },
        child: Text(context.tAuth.authentication.forgotPassword.tapped),
      ),
    );
  }

  Widget _buildLoginButton(AppThemes theme, bool isLoading) {
    return FilledButton(
      onPressed: isLoading ? null : _onLoginPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: theme.surfaceColor),
            )
          : Text(context.tAuth.authentication.login.loginButton),
    );
  }

  Widget _buildDivider(AppThemes theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.tAuth.authentication.login.or,
            style: theme.labelMedium.copyWith(color: theme.textSecondaryColor),
          ),
        ),
        Expanded(child: Divider(color: theme.dividerColor)),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialLoginButton(
          label: context.tAuth.authentication.login.continueWithGoogle,
          icon: Icons.g_mobiledata,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tAuth.authentication.login.googleLoginTapped)),
            );
          },
        ),
        const SizedBox(height: 10),
        SocialLoginButton(
          label: context.tAuth.authentication.login.continueWithApple,
          icon: Icons.apple,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tAuth.authentication.login.appleLoginTapped)),
            );
          },
        ),
        const SizedBox(height: 10),
        SocialLoginButton(
          label: context.tAuth.authentication.login.continueWithFacebook,
          icon: Icons.facebook,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.tAuth.authentication.login.facebookLoginTapped)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRegisterRow(AppThemes theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.tAuth.authentication.login.dontHaveAccount, style: theme.bodyMedium),
        TextButton(
          onPressed: () {
            // context.router.push(const RegisterRoute());
          },
          child: Text(context.tAuth.authentication.login.signUpButton),
        ),
      ],
    );
  }
}
