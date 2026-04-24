import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/vigenere_cubit.dart';
import 'widgets/vigenere_input_section.dart';
import 'widgets/vigenere_animation_board.dart';
import '../../../../core/utils/consts/app_styles.dart';
import '../../../../core/utils/consts/app_colors.dart';

class VigenereView extends StatelessWidget {
  const VigenereView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return BlocProvider(
      create: (context) => VigenereCubit(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: isMobile ? 20 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vigenère Cipher',
                        style: AppStyles.title.copyWith(
                          fontSize: isMobile ? 24 : 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Polyalphabetic substitution: each letter shifts by the corresponding letter of the repeating key.',
                        style: AppStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 24 : 30),
            const VigenereInputSection(),
            SizedBox(height: isMobile ? 24 : 30),
            const VigenereAnimationBoard(),
          ],
        ),
      ),
    );
  }
}