// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/material.dart';

/// A helper widget to flatten nested TranslationProviders.
/// This allows us to list providers in a flat array, making it easier for Mason
/// to inject new feature providers without managing nested indentation.
class MultiTranslationProvider extends StatelessWidget {
  final List<Widget Function({required Widget child})> providers;
  final Widget child;

  const MultiTranslationProvider({super.key, required this.providers, required this.child});

  @override
  Widget build(BuildContext context) {
    return providers.reversed.fold(
      child,
      (currentChild, providerConstructor) => providerConstructor(child: currentChild),
    );
  }
}
