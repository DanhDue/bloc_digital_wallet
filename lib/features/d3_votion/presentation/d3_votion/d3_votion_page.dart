import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bloc_digital_wallet/core/architecture/architecture.dart';
import 'd3_votion_bloc.dart';
import 'd3_votion_state.dart';
import 'd3_votion_event.dart';
import 'd3_votion_action.dart';

@RoutePage()
class D3VotionPage extends BaseMviPage<D3VotionBloc, D3VotionState, D3VotionEvent> {
  const D3VotionPage({super.key});

  @override
  void Function(D3VotionBloc bloc)? get onBlocCreated =>
      (bloc) => bloc.onAction(const GetD3VotionAction('Single'));

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(title: const Text('D3 Votion'));
  }

  @override
  Widget handleState(BuildContext context, D3VotionState state) {
    return switch (state) {
      D3VotionInitial() => _buildInitial(context),
      D3VotionLoading() => const Center(child: CircularProgressIndicator()),
      D3VotionLoaded(:final data) => _buildSuccess(context, data),
      D3VotionError(:final message) => _buildError(context, message),
    };
  }

  @override
  void handleEvent(BuildContext context, D3VotionEvent event) {}

  Widget _buildInitial(BuildContext context) {
    return const Center(child: Text('Initializing...'));
  }

  Widget _buildSuccess(BuildContext context, dynamic data) {
    final entity = data;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.word ?? '',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (entity.ipa != null)
            Text(
              entity.ipa!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
            ),
          const SizedBox(height: 16),
          Text(
            entity.definition ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (entity.samples != null && entity.samples!.isNotEmpty) ...[
            Text(
              'Samples',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...entity.samples!.map((sample) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sample.text ?? ''),
                        if (sample.vietnameseText != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            sample.vietnameseText!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(child: Text('Error: $message'));
  }
}
