import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/vigenere_cubit.dart';
import '../../manager/vigenere_state.dart';
import '../../../../../core/utils/consts/app_colors.dart';
import '../../../../../core/utils/consts/app_styles.dart';

class VigenereInputSection extends StatelessWidget {
  const VigenereInputSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<VigenereCubit, VigenereState>(
      builder: (context, state) {
        if (state is! VigenereActive) return const SizedBox();

        return Column(
          children: [
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
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPlainTextInput(context, state),
                        const SizedBox(height: 20),
                        _buildKeywordInput(context, state),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildPlainTextInput(context, state),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 2,
                          child: _buildKeywordInput(context, state),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('REPEATING KEY STREAM', style: AppStyles.sectionHeader),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.steps.map((step) => _buildKeyStreamBox(step.keyChar)).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildModeButton('Encrypt', true, state.isEncrypt, context),
                  _buildModeButton('Decrypt', false, !state.isEncrypt, context),
                  ElevatedButton.icon(
                    onPressed: state.isAnimating
                        ? null
                        : () => context.read<VigenereCubit>().runAnimation(),
                    icon: const Icon(Icons.play_arrow_rounded, size: 24),
                    label: Text(
                      'Run animation',
                      style: AppStyles.buttonText.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.read<VigenereCubit>().resetAnimation(),
                    icon: const Icon(Icons.refresh_rounded, size: 24),
                    label: Text(
                      'Reset',
                      style: AppStyles.buttonText.copyWith(color: AppColors.textPrimary),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

  Widget _buildKeyStreamBox(String char) {
    bool isSpace = char == '.';
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSpace ? AppColors.background : const Color(0xFFD4F4FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSpace ? AppColors.border : const Color(0xFFB2EBF2),
          width: 1,
        ),
      ),
      child: Text(
        char,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSpace ? AppColors.textSecondary.withOpacity(0.5) : const Color(0xFF0097A7),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildPlainTextInput(BuildContext context, VigenereActive state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text', style: AppStyles.body),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.text,
          style: AppStyles.body,
          onChanged: (val) => context.read<VigenereCubit>().updateText(val),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildKeywordInput(BuildContext context, VigenereActive state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key', style: AppStyles.body),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.keyword,
          style: AppStyles.body,
          onChanged: (val) => context.read<VigenereCubit>().updateKeyword(val),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            hintText: 'Letters only',
            hintStyle: AppStyles.subtitle.copyWith(color: AppColors.textSecondary.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Letters only, repeats over the message.',
          style: AppStyles.subtitle.copyWith(fontSize: 13),
        )
      ],
    );
  }

  Widget _buildModeButton(String text, bool isEncryptValue, bool isSelected, BuildContext context) {
    return InkWell(
      onTap: () => context.read<VigenereCubit>().setMode(isEncryptValue),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEncryptValue ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: AppStyles.buttonText.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}