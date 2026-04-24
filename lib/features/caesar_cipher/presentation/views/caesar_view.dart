import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/caesar_cubit.dart';
import 'widgets/input_section.dart';
import 'widgets/animation_board.dart';
import '../../../../core/utils/consts/app_styles.dart';
import '../../../../core/utils/consts/app_colors.dart';

class CaesarView extends StatelessWidget {
  const CaesarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return BlocProvider(
      create: (context) => CaesarCubit(),
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
                    Icons.lock_rounded,
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
                        'Caesar Cipher',
                        style: AppStyles.title.copyWith(
                          fontSize: isMobile ? 24 : 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Shifts each letter by a fixed amount in the alphabet.',
                        style: AppStyles.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 24 : 30),
            const InputSection(),
            SizedBox(height: isMobile ? 24 : 30),
            const AnimationBoard(),
          ],
        ),
      ),
    );
  }
}
