import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_digital_wallet/core/architecture/base_mvi_page.dart';
import 'package:bloc_digital_wallet/features/d3_votion/presentation/d3_votion/d3_votion_action.dart';
import 'package:bloc_digital_wallet/features/d3_votion/presentation/d3_votion/d3_votion_bloc.dart';
import 'package:bloc_digital_wallet/features/d3_votion/presentation/d3_votion/d3_votion_event.dart';
import 'package:bloc_digital_wallet/features/d3_votion/presentation/d3_votion/d3_votion_state.dart';

@RoutePage()
class D3VotionPage extends BaseMviPage<D3VotionBloc, D3VotionState, D3VotionEvent> {
  const D3VotionPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(title: const Text('D3Votion'));

  @override
  Widget handleState(BuildContext context, D3VotionState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Enter word',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<D3VotionBloc>().onAction(D3VotionAction.getD3Votion(value));
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: state.map(
              initial: (_) => const Center(child: Text('Enter a word to search')),
              loading: (_) => const Center(child: CircularProgressIndicator()),
              loaded: (loaded) {
                final data = loaded.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Word: ${data.word ?? ""}', style: Theme.of(context).textTheme.headlineSmall),
                      Text('Definition: ${data.definition ?? ""}'),
                      Text('IPA: ${data.ipa ?? ""}'),
                      if (data.samples != null && data.samples!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text('Samples:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...data.samples!.map((s) => ListTile(
                          title: Text(s.text ?? ""),
                          subtitle: Text(s.vietnameseText ?? ""),
                        )),
                      ],
                    ],
                  ),
                );
              },
              failure: (fail) => Center(child: Text('Error: ${fail.message}')),
            ),
          ),
        ],
      ),
    );
  }
}
