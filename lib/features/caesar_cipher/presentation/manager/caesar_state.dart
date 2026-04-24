import 'package:equatable/equatable.dart';
import '../../data/models/caesar_step_model.dart';

abstract class CaesarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CaesarInitial extends CaesarState {}

class CaesarActive extends CaesarState {
  final String text;
  final int shift;
  final bool isEncrypt;
  final List<CaesarStepModel> steps;
  final int currentStep;
  final bool isAnimating;

  CaesarActive({
    required this.text,
    required this.shift,
    required this.isEncrypt,
    required this.steps,
    required this.currentStep,
    required this.isAnimating,
  });

  @override
  List<Object?> get props => [
        text,
        shift,
        isEncrypt,
        steps,
        currentStep,
        isAnimating,
      ];

  CaesarActive copyWith({
    String? text,
    int? shift,
    bool? isEncrypt,
    List<CaesarStepModel>? steps,
    int? currentStep,
    bool? isAnimating,
  }) {
    return CaesarActive(
      text: text ?? this.text,
      shift: shift ?? this.shift,
      isEncrypt: isEncrypt ?? this.isEncrypt,
      steps: steps ?? this.steps,
      currentStep: currentStep ?? this.currentStep,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}