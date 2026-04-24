import 'package:flutter_bloc/flutter_bloc.dart';
import 'vigenere_state.dart';
import '../../data/models/vigenere_step_model.dart';

class VigenereCubit extends Cubit<VigenereState> {
  VigenereCubit()
      : super(VigenereActive(
          text: 'Attack at dawn',
          keyword: 'LEMON',
          isEncrypt: true,
          steps: const [],
          currentStep: -1,
          isAnimating: false,
        )) {
    _processText('Attack at dawn', 'LEMON', true);
  }

  void updateText(String text) {
    if (state is VigenereActive) {
      final currentState = state as VigenereActive;
      _processText(text, currentState.keyword, currentState.isEncrypt);
    }
  }

  void updateKeyword(String keyword) {
    if (state is VigenereActive) {
      final currentState = state as VigenereActive;
      _processText(currentState.text, keyword, currentState.isEncrypt);
    }
  }

  void setMode(bool isEncrypt) {
    if (state is VigenereActive) {
      final currentState = state as VigenereActive;
      _processText(currentState.text, currentState.keyword, isEncrypt);
    }
  }

  void _processText(String text, String keyword, bool isEncrypt) {
    String safeKey = keyword.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (safeKey.isEmpty) safeKey = 'A'; 

    List<VigenereStepModel> steps = [];
    int keyIndex = 0;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        bool isLower = char == char.toLowerCase();
        String upperChar = char.toUpperCase();
        String keyChar = safeKey[keyIndex % safeKey.length];
        keyIndex++;

        int charVal = upperChar.codeUnitAt(0) - 65;
        int keyVal = keyChar.codeUnitAt(0) - 65;
        
        int outVal;
        if (isEncrypt) {
          outVal = (charVal + keyVal) % 26;
        } else {
          outVal = (charVal - keyVal) % 26;
          if (outVal < 0) outVal += 26;
        }

        String outChar = String.fromCharCode(outVal + 65);
        if (isLower) outChar = outChar.toLowerCase();

        String op = isEncrypt ? '+' : '-';
        String calc = "$upperChar($charVal) $op $keyChar($keyVal) mod 26 = $outVal → ${outChar.toUpperCase()}";

        steps.add(VigenereStepModel(
            inputChar: char, keyChar: keyChar, outputChar: outChar, calculation: calc));
      } else {
        steps.add(VigenereStepModel(
            inputChar: char, keyChar: '.', outputChar: char, calculation: "Non-alphabetic character unchanged"));
      }
    }

    emit(VigenereActive(
        text: text,
        keyword: keyword,
        isEncrypt: isEncrypt,
        steps: steps,
        currentStep: -1,
        isAnimating: false));
  }

  void runAnimation() async {
    if (state is VigenereActive) {
      final currentState = state as VigenereActive;
      emit(currentState.copyWith(isAnimating: true, currentStep: -1));

      for (int i = 0; i < currentState.steps.length; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (isClosed) return;
        final latestState = state as VigenereActive;
        if (!latestState.isAnimating) return;
        emit(latestState.copyWith(currentStep: i));
      }
      
      final finalState = state as VigenereActive;
      emit(finalState.copyWith(isAnimating: false));
    }
  }

  void resetAnimation() {
    if (state is VigenereActive) {
      final currentState = state as VigenereActive;
      emit(currentState.copyWith(currentStep: -1, isAnimating: false));
    }
  }
}