import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/custom_ecg_wave.dart';
import '../core/widgets/custom_shield_emblem.dart';
import '../viewmodels/app_view_model.dart';

class Screen1Login extends StatefulWidget {
  final AppViewModel viewModel;

  const Screen1Login({super.key, required this.viewModel});

  @override
  State<Screen1Login> createState() => _Screen1LoginState();
}

class _Screen1LoginState extends State<Screen1Login> {
  final TextEditingController _driverIdController =
      TextEditingController(text: 'AMB-1042');
  final TextEditingController _passwordController =
      TextEditingController(text: '1042');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _driverIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final driverId = _driverIdController.text.trim();
    final pin = _passwordController.text.trim();

    if (driverId.isEmpty || pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide Driver ID and Secure PIN'),
          backgroundColor: AppColors.emergencyRed,
        ),
      );
      return;
    }

    widget.viewModel.loginAndStartDuty(driverId: driverId, pin: pin);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Container(
      color: AppColors.deepNavy,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Ambient glowing red backdrop effect
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.emergencyRed.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emergencyRed.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Shield Emblem
              const Center(
                child: CustomShieldEmblem(width: 68, height: 80),
              ),

              const SizedBox(height: 12),

              // Header Title
              Text(
                'AMBULANCE',
                style: AppTheme.plusJakartaStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'RESPONSE',
                style: AppTheme.plusJakartaStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.emergencyRed,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              // Portal Subtitle
              Text(
                vm.tr('app_portal_title'),
                style: AppTheme.plusJakartaStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSubtle,
                  letterSpacing: 2.0,
                ),
              ),

              const SizedBox(height: 8),

              // ECG Heartbeat Accent
              const CustomEcgWave(
                width: 150,
                height: 14,
                color: AppColors.emergencyRed,
                strokeWidth: 2.0,
              ),

              const SizedBox(height: 20),

              // Main Login Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Eyebrow
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.emergencyRed,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          vm.tr('driver_sign_in'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.emergencyRed,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Greeting
                    RichText(
                      text: TextSpan(
                        text: '${vm.tr('welcome_back')} ',
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textNavy,
                        ),
                        children: [
                          TextSpan(
                            text: 'Arun',
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.emergencyRed,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      vm.tr('sign_in_sub'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Driver ID Input Field
                    Text(
                      vm.tr('lbl_driver_id'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.badge_outlined,
                              color: Color(0xFF64748B),
                              size: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _driverIdController,
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textNavy,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.activeGreen,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Password / PIN Field
                    Text(
                      vm.tr('lbl_password'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: Color(0xFF64748B),
                              size: 18,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textNavy,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Remember Me & Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              vm.rememberMe = !vm.rememberMe;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: vm.rememberMe
                                      ? AppColors.emergencyRed
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: vm.rememberMe
                                        ? AppColors.emergencyRed
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: vm.rememberMe
                                    ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                vm.tr('remember_me'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            vm.openSupportModal();
                          },
                          child: Text(
                            vm.tr('forgot_password'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emergencyRed,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Login CTA Button
                    GestureDetector(
                      onTap: _handleLogin,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.emergencyRed,
                              AppColors.emergencyRedDark
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emergencyRed.withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.login_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  vm.tr('login_start_duty'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const Positioned(
                              right: 12,
                              child: Opacity(
                                opacity: 0.4,
                                child: CustomEcgWave(
                                  width: 80,
                                  height: 18,
                                  color: Colors.white,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Reassurance Quote
              Column(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vm.tr('login_quote_2'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      text: '${vm.tr('login_quote_3')} ',
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: vm.tr('login_quote_4'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.emergencyRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
