// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_digital_wallet/di/injection.dart';
import '../mvi/authentication_action.dart';
import '../mvi/authentication_bloc.dart';
import '../mvi/authentication_event.dart';
import '../mvi/authentication_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthenticationBloc _bloc;
  late final StreamSubscription<AuthenticationEvent> _eventSub;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AuthenticationBloc>();
    _eventSub = _bloc.events.listen((event) {
      switch (event) {
        case ShowAuthSuccessMessage():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event.message)));
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
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();

    _bloc.onAction(
      LoginWithEmailPasswordAction(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.account_circle, color: colorScheme.primary, size: 54),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Login to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                  ),
                  onSubmitted: (_) => _onLoginPressed(),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO(authentication): navigate to forgot password screen.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Forgot password tapped (UI only).')),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    final isLoading = state is AuthenticationLoading;

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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Login'),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ),
                const SizedBox(height: 16),
                SocialLoginButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () {
                    // TODO(authentication): implement social login.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google login tapped (UI only).')),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SocialLoginButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple,
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Apple login tapped (UI only).')));
                  },
                ),
                const SizedBox(height: 10),
                SocialLoginButton(
                  label: 'Continue with Facebook',
                  icon: Icons.facebook,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Facebook login tapped (UI only).')),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        // TODO(authentication): navigate to register screen.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Register tapped (UI only).')),
                        );
                      },
                      child: const Text('Sign up'),
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
