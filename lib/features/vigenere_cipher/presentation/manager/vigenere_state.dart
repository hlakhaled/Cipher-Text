import 'package:equatable/equatable.dart';
import '../../data/models/vigenere_step_model.dart';

abstract class VigenereState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VigenereInitial extends VigenereState {}

class VigenereActive extends VigenereState {
  final String text;
  final String keyword;
  final bool isEncrypt;
  final List<VigenereStepModel> steps;
  final int currentStep;
  final bool isAnimating;

  VigenereActive({
    required this.text,
    required this.keyword,
    required this.isEncrypt,
    required this.steps,
    required this.currentStep,
    required this.isAnimating,
  });

  @override
  List<Object?> get props => [
        text,
        keyword,
        isEncrypt,
        steps,
        currentStep,
        isAnimating,
      ];

  VigenereActive copyWith({
    String? text,
    String? keyword,
    bool? isEncrypt,
    List<VigenereStepModel>? steps,
    int? currentStep,
    bool? isAnimating,
  }) {
    return VigenereActive(
      text: text ?? this.text,
      keyword: keyword ?? this.keyword,
      isEncrypt: isEncrypt ?? this.isEncrypt,
      steps: steps ?? this.steps,
      currentStep: currentStep ?? this.currentStep,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}