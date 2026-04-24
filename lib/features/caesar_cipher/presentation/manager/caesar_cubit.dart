import 'package:flutter_bloc/flutter_bloc.dart';
import 'caesar_state.dart';
import '../../data/models/caesar_step_model.dart';

class CaesarCubit extends Cubit<CaesarState> {
  CaesarCubit()
      : super(CaesarActive(
          text: 'Hello World',
          shift: 3,
          isEncrypt: true,
          steps: const [],
          currentStep: -1,
          isAnimating: false,
        )) {
    _generateSteps('Hello World', 3, true);
  }

  void updateText(String text) {
    if (state is CaesarActive) {
      final currentState = state as CaesarActive;
      _generateSteps(text, currentState.shift, currentState.isEncrypt);
    }
  }

  void updateShift(int shift) {
    if (state is CaesarActive) {
      final currentState = state as CaesarActive;
      _generateSteps(currentState.text, shift, currentState.isEncrypt);
    }
  }

  void setMode(bool isEncrypt) {
    if (state is CaesarActive) {
      final currentState = state as CaesarActive;
      _generateSteps(currentState.text, currentState.shift, isEncrypt);
    }
  }

  void _generateSteps(String text, int shift, bool isEncrypt) {
    List<CaesarStepModel> steps = [];
    int actualShift = isEncrypt ? shift : -shift;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        int base = char.codeUnitAt(0) >= 97 ? 97 : 65;
        int charCode = char.codeUnitAt(0) - base;
        int shifted = (charCode + actualShift) % 26;
        if (shifted < 0) shifted += 26;
        String outChar = String.fromCharCode(shifted + base);
        
        String op = isEncrypt ? 'E' : 'D';
        String sign = isEncrypt ? '+' : '-';
        String calc = "$op ($shift) = ($charCode $sign $shift) mod 26 = $shifted -> ${outChar.toUpperCase()}";
        
        steps.add(CaesarStepModel(
            inputChar: char, outputChar: outChar, calculation: calc));
      } else {
        steps.add(CaesarStepModel(
            inputChar: char, outputChar: char, calculation: "Non-alphabetic character unchanged"));
      }
    }
    emit(CaesarActive(
        text: text,
        shift: shift,
        isEncrypt: isEncrypt,
        steps: steps,
        currentStep: -1,
        isAnimating: false));
  }

  void runAnimation() async {
    if (state is CaesarActive) {
      final currentState = state as CaesarActive;
      emit(currentState.copyWith(isAnimating: true, currentStep: -1));

      for (int i = 0; i < currentState.steps.length; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (isClosed) return;
        final latestState = state as CaesarActive;
        if (!latestState.isAnimating) return;
        emit(latestState.copyWith(currentStep: i));
      }
      
      final finalState = state as CaesarActive;
      emit(finalState.copyWith(isAnimating: false));
    }
  }

  void resetAnimation() {
    if (state is CaesarActive) {
      final currentState = state as CaesarActive;
      emit(currentState.copyWith(currentStep: -1, isAnimating: false));
    }
  }
}