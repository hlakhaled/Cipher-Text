import 'package:cipher_text/core/utils/consts/app_colors.dart';
import 'package:cipher_text/core/utils/consts/app_styles.dart';
import 'package:cipher_text/features/vigenere_cipher/presentation/views/vigenere_view.dart';
import 'package:flutter/material.dart';

import '../../../caesar_cipher/presentation/views/caesar_view.dart';
// Make sure this import path matches your structure
import '../../../monoalphabetic_cipher/presentation/views/monoalphabetic_view.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({Key? key}) : super(key: key);

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  bool _isSidebarVisible = true;
  int _selectedIndex = 0; // Tracks which cipher is currently selected

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              title: _buildAppTitle(),
              centerTitle: true,
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.surface,
              child: _buildSidebarContent(isMobile), // Pass isMobile
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isSidebarVisible ? 280 : 0,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  right: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: 280,
                  child: _buildSidebarContent(isMobile),
                ),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                if (!isMobile)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isSidebarVisible = !_isSidebarVisible;
                            });
                          },
                          icon: Icon(
                            _isSidebarVisible
                                ? Icons.menu_open_rounded
                                : Icons.menu_rounded,
                            color: AppColors.textSecondary,
                            size: 26,
                          ),
                          tooltip: 'Toggle Sidebar',
                        ),
                        if (!_isSidebarVisible) ...[
                          const SizedBox(width: 12),
                          _buildAppTitle(fontSize: 18),
                        ],
                      ],
                    ),
                  ),
                // This expanded widget now calls a method to build the active view
                Expanded(child: _buildActiveView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Logic to return the correct screen based on the sidebar selection
  Widget _buildActiveView() {
    switch (_selectedIndex) {
      case 0:
        return const CaesarView();
      case 1:
        return const MonoalphabeticView();
      case 2:
        return const Center(child: Text('Playfair View Coming Soon...'));
      case 3:
        return const VigenereView();
      case 4:
        return const Center(child: Text('Hill View Coming Soon...'));
      default:
        return const CaesarView();
    }
  }

  Widget _buildAppTitle({double fontSize = 24}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Cipher',
            style: AppStyles.title.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
            text: 'Lab',
            style: AppStyles.title.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text(
                      "{ }",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppTitle(),
                    const SizedBox(height: 4),
                    Text(
                      'Classical Ciphers',
                      style: AppStyles.subtitle.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Text('CIPHERS', style: AppStyles.sectionHeader),
        ),
        // Pass the index and mobile status to the sidebar items
        _buildSidebarItem(
          'Caesar',
          'Shift cipher',
          Icons.lock_outline_rounded,
          0,
          isMobile,
        ),
        _buildSidebarItem(
          'Monoalphabetic',
          'Substitution',
          Icons.shuffle_rounded,
          1,
          isMobile,
        ),

        _buildSidebarItem(
          'Vigenère',
          'Polyalphabetic',
          Icons.vpn_key_outlined,
          3,
          isMobile,
        ),
        _buildSidebarItem(
          'Playfair',
          '5x5 matrix',
          Icons.grid_view_rounded,
          2,
          isMobile,
        ),
        _buildSidebarItem(
          'Hill',
          'Matrix cipher',
          Icons.calculate_outlined,
          4,
          isMobile,
        ),
      ],
    );
  }

  Widget _buildSidebarItem(
    String title,
    String subtitle,
    IconData icon,
    int index,
    bool isMobile,
  ) {
    bool isSelected = _selectedIndex == index; // Check if this item is active

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryLight.withOpacity(0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: AppStyles.body.copyWith(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppStyles.subtitle.copyWith(fontSize: 12),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index; // Update the state with the new selection
          });

          // Automatically close the drawer if we are on a mobile screen
          if (isMobile) {
            Navigator.pop(context);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
