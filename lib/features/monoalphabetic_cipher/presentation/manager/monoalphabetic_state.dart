import 'package:equatable/equatable.dart';
import '../../data/models/monoalphabetic_step_model.dart';

abstract class MonoalphabeticState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonoalphabeticInitial extends MonoalphabeticState {}

class MonoalphabeticActive extends MonoalphabeticState {
  final String text;
  final String keyword;
  final bool isEncrypt;
  final String cipherAlphabet;
  final List<MonoalphabeticStepModel> steps;
  final int currentStep;
  final bool isAnimating;

  MonoalphabeticActive({
    required this.text,
    required this.keyword,
    required this.isEncrypt,
    required this.cipherAlphabet,
    required this.steps,
    required this.currentStep,
    required this.isAnimating,
  });

  @override
  List<Object?> get props => [
        text,
        keyword,
        isEncrypt,
        cipherAlphabet,
        steps,
        currentStep,
        isAnimating,
      ];

  MonoalphabeticActive copyWith({
    String? text,
    String? keyword,
    bool? isEncrypt,
    String? cipherAlphabet,
    List<MonoalphabeticStepModel>? steps,
    int? currentStep,
    bool? isAnimating,
  }) {
    return MonoalphabeticActive(
      text: text ?? this.text,
      keyword: keyword ?? this.keyword,
      isEncrypt: isEncrypt ?? this.isEncrypt,
      cipherAlphabet: cipherAlphabet ?? this.cipherAlphabet,
      steps: steps ?? this.steps,
      currentStep: currentStep ?? this.currentStep,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}