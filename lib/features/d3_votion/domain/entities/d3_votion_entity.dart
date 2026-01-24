import 'package:equatable/equatable.dart';

class D3VotionEntity extends Equatable {
  final String? word;
  final String? definition;
  final String? ipa;
  final List<SampleEntity>? samples;

  const D3VotionEntity({
    this.word,
    this.definition,
    this.ipa,
    this.samples,
  });

  @override
  List<Object?> get props => [word, definition, ipa, samples];
}

class SampleEntity extends Equatable {
  final String? text;
  final String? vietnameseText;
  final String? audioLink;

  const SampleEntity({
    this.text,
    this.vietnameseText,
    this.audioLink,
  });

  @override
  List<Object?> get props => [text, vietnameseText, audioLink];
}
