import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/monoalphabetic_cubit.dart';
import '../../manager/monoalphabetic_state.dart';
import '../../../../../core/utils/consts/app_colors.dart';
import '../../../../../core/utils/consts/app_styles.dart';

class MonoalphabeticAnimationBoard extends StatelessWidget {
  const MonoalphabeticAnimationBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<MonoalphabeticCubit, MonoalphabeticState>(
      builder: (context, state) {
        if (state is! MonoalphabeticActive) return const SizedBox();

        String activeLetterToHighlight = "";
        if (state.currentStep >= 0 && state.currentStep < state.steps.length) {
          String char = state.steps[state.currentStep].inputChar.toUpperCase();
          if (RegExp(r'[A-Z]').hasMatch(char)) {
            activeLetterToHighlight = char;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SUBSTITUTION TABLE', style: AppStyles.sectionHeader),
                  const SizedBox(height: 16),
                  // 🔥 REPLACED ScrollView/Row with a Wrap widget
                  Wrap(
                    spacing: 8.0, // Horizontal space between items
                    runSpacing:
                        16.0, // Vertical space if it wraps to the next line
                    children: List.generate(26, (index) {
                      String standardChar = String.fromCharCode(65 + index);
                      String cipherChar = state.cipherAlphabet[index];

                      bool isHighlight = false;
                      if (activeLetterToHighlight.isNotEmpty) {
                        isHighlight = state.isEncrypt
                            ? standardChar == activeLetterToHighlight
                            : cipherChar == activeLetterToHighlight;
                      }

                      // Removed the Padding widget, Wrap handles spacing now
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMiniBox(
                            standardChar,
                            isHighlight
                                ? AppColors.activeHighlight
                                : AppColors.background,
                            AppColors.textPrimary,
                            isHighlight,
                          ),
                          const SizedBox(height: 4),
                          _buildMiniBox(
                            cipherChar,
                            isHighlight
                                ? AppColors.primary
                                : AppColors.primaryLight,
                            isHighlight ? Colors.white : AppColors.primary,
                            isHighlight,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INPUT', style: AppStyles.sectionHeader),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: List.generate(state.steps.length, (index) {
                      bool isActive = state.currentStep == index;
                      return _buildCharBox(
                        state.steps[index].inputChar,
                        isActive
                            ? AppColors.activeHighlight
                            : AppColors.inputCharBg,
                        isActive
                            ? AppColors.textPrimary
                            : AppColors.textPrimary,
                        true,
                        isActive,
                        isMobile,
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Text('OUTPUT', style: AppStyles.sectionHeader),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: List.generate(state.steps.length, (index) {
                      bool isVisible =
                          state.currentStep >= index ||
                          state.currentStep == -1 && !state.isAnimating;
                      bool isActive = state.currentStep == index;
                      return _buildCharBox(
                        isVisible ? state.steps[index].outputChar : '',
                        isActive
                            ? AppColors.activeHighlight
                            : AppColors.outputCharBg,
                        isActive
                            ? AppColors.textPrimary
                            : AppColors.outputCharText,
                        false,
                        isActive,
                        isMobile,
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: state.currentStep >= 0
                          ? AppColors.activeHighlight.withOpacity(0.3)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: state.currentStep >= 0
                            ? AppColors.activeHighlight
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      state.currentStep >= 0
                          ? 'Step ${state.currentStep + 1}/${state.steps.length}: ${state.steps[state.currentStep].calculation}'
                          : 'Press Run Animation to see steps',
                      style: AppStyles.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMiniBox(
    String char,
    Color bgColor,
    Color textColor,
    bool isHighlight,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlight
              ? Colors.transparent
              : AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        char,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildCharBox(
    String char,
    Color bgColor,
    Color textColor,
    bool isBordered,
    bool isActive,
    bool isMobile,
  ) {
    double size = isMobile ? 40 : 48;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isBordered
            ? Border.all(
                color: isActive ? AppColors.activeHighlight : AppColors.border,
                width: 2,
              )
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Text(
        char,
        style: AppStyles.charBoxText.copyWith(
          color: textColor,
          fontSize: isMobile ? 16 : 20,
        ),
      ),
    );
  }
}
