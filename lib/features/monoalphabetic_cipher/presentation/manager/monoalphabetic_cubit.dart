import 'package:flutter_bloc/flutter_bloc.dart';
import 'monoalphabetic_state.dart';
import '../../data/models/monoalphabetic_step_model.dart';

class MonoalphabeticCubit extends Cubit<MonoalphabeticState> {
  static const String _standardAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  MonoalphabeticCubit()
      : super(MonoalphabeticActive(
          text: 'Hello World',
          keyword: 'KEYWORD',
          isEncrypt: true,
          cipherAlphabet: _generateCipherAlphabet('KEYWORD'),
          steps: const [],
          currentStep: -1,
          isAnimating: false,
        )) {
    _processText('Hello World', 'KEYWORD', true);
  }

  static String _generateCipherAlphabet(String keyword) {
    String cleanKey = keyword.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    String result = "";
    
    for (int i = 0; i < cleanKey.length; i++) {
      if (!result.contains(cleanKey[i])) {
        result += cleanKey[i];
      }
    }
    
    for (int i = 0; i < _standardAlphabet.length; i++) {
      if (!result.contains(_standardAlphabet[i])) {
        result += _standardAlphabet[i];
      }
    }
    return result;
  }

  void updateText(String text) {
    if (state is MonoalphabeticActive) {
      final currentState = state as MonoalphabeticActive;
      _processText(text, currentState.keyword, currentState.isEncrypt);
    }
  }

  void updateKeyword(String keyword) {
    if (state is MonoalphabeticActive) {
      final currentState = state as MonoalphabeticActive;
      _processText(currentState.text, keyword, currentState.isEncrypt);
    }
  }

  void setMode(bool isEncrypt) {
    if (state is MonoalphabeticActive) {
      final currentState = state as MonoalphabeticActive;
      _processText(currentState.text, currentState.keyword, isEncrypt);
    }
  }

  void _processText(String text, String keyword, bool isEncrypt) {
    String currentCipherAlphabet = _generateCipherAlphabet(keyword);
    List<MonoalphabeticStepModel> steps = [];

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        bool isLower = char == char.toLowerCase();
        String upperChar = char.toUpperCase();
        
        String outChar;
        String calc;

        if (isEncrypt) {
          int index = _standardAlphabet.indexOf(upperChar);
          outChar = currentCipherAlphabet[index];
          calc = "$upperChar → maps to index $index → $outChar";
        } else {
          int index = currentCipherAlphabet.indexOf(upperChar);
          outChar = _standardAlphabet[index];
          calc = "$upperChar → found at index $index → $outChar";
        }

        if (isLower) outChar = outChar.toLowerCase();

        steps.add(MonoalphabeticStepModel(
            inputChar: char, outputChar: outChar, calculation: calc));
      } else {
        steps.add(MonoalphabeticStepModel(
            inputChar: char, outputChar: char, calculation: "Non-alphabetic character unchanged"));
      }
    }

    emit(MonoalphabeticActive(
        text: text,
        keyword: keyword,
        isEncrypt: isEncrypt,
        cipherAlphabet: currentCipherAlphabet,
        steps: steps,
        currentStep: -1,
        isAnimating: false));
  }

  void runAnimation() async {
    if (state is MonoalphabeticActive) {
      final currentState = state as MonoalphabeticActive;
      emit(currentState.copyWith(isAnimating: true, currentStep: -1));

      for (int i = 0; i < currentState.steps.length; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (isClosed) return;
        final latestState = state as MonoalphabeticActive;
        if (!latestState.isAnimating) return;
        emit(latestState.copyWith(currentStep: i));
      }
      
      final finalState = state as MonoalphabeticActive;
      emit(finalState.copyWith(isAnimating: false));
    }
  }

  void resetAnimation() {
    if (state is MonoalphabeticActive) {
      final currentState = state as MonoalphabeticActive;
      emit(currentState.copyWith(currentStep: -1, isAnimating: false));
    }
  }
}