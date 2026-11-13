// lib/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthComplete;
  const AuthScreen({super.key, required this.onAuthComplete});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // ── Background gradient blobs ─────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coral.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightBlue.withOpacity(0.08),
              ),
            ),
          ),

          // ── Main content ──────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Logo + tagline
                const SizedBox(height: 32),
                _buildLogoSection(),
                const SizedBox(height: 32),

                // Tab bar
                _buildTabBar(),

                // Tab views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _LoginTab(onSuccess: widget.onAuthComplete),
                      _SignUpTab(onSuccess: widget.onAuthComplete),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo mark
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text('✦', style: TextStyle(fontSize: 34, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Confi',
                style: AppTypography.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
              TextSpan(
                text: 'Circle',
                style: AppTypography.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.coral,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your confidence journey starts here',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTypography.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        unselectedLabelStyle: AppTypography.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.darkGrey,
        tabs: const [
          Tab(text: 'Log In'),
          Tab(text: 'Sign Up'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LOG IN TAB
// ─────────────────────────────────────────────────────────────
class _LoginTab extends StatefulWidget {
  final VoidCallback onSuccess;
  const _LoginTab({required this.onSuccess});

  @override
  State<_LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<_LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    // Mark as returning user (has account, already used app)
    context.read<UserProvider>().setExistingStudentDemo();
    setState(() => _loading = false);
    widget.onSuccess();
  }

  void _googleSignIn() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    // For demo: existing user via Google
    context.read<UserProvider>().setExistingStudentDemo();
    setState(() => _loading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back! 👋', style: AppTypography.headingSmall),
            const SizedBox(height: 4),
            Text(
              'Log in to continue your journey',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 28),

            // Email field
            _AuthField(
              controller: _emailCtrl,
              label: 'Email address',
              hint: 'you@college.edu',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password field
            _AuthField(
              controller: _passCtrl,
              label: 'Password',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _obscurePass,
              suffix: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.darkGrey,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your password';
                if (v.length < 6) return 'Password too short';
                return null;
              },
            ),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot password?',
                  style: AppTypography.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coral,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Log in button
            _PrimaryButton(
              label: 'Log In',
              loading: _loading,
              onTap: _login,
            ),

            const SizedBox(height: 20),
            const _Divider(label: 'or continue with'),
            const SizedBox(height: 20),

            // Google sign-in
            _GoogleButton(onTap: _loading ? null : _googleSignIn),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SIGN UP TAB
// ─────────────────────────────────────────────────────────────
class _SignUpTab extends StatefulWidget {
  final VoidCallback onSuccess;
  const _SignUpTab({required this.onSuccess});

  @override
  State<_SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<_SignUpTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please agree to the Terms & Privacy Policy',
            style: AppTypography.bodySmall.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.coral,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    // New user — update profile name and keep isFirstTime=true
    context.read<UserProvider>().updateProfile(name: _nameCtrl.text.trim());
    setState(() => _loading = false);
    widget.onSuccess();
  }

  void _googleSignUp() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    // New user via Google — stays first-time
    context.read<UserProvider>().updateProfile(name: 'Anaya');
    setState(() => _loading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create your account ✨', style: AppTypography.headingSmall),
            const SizedBox(height: 4),
            Text(
              'Join thousands of students growing daily',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 28),

            // Full name
            _AuthField(
              controller: _nameCtrl,
              label: 'Full name',
              hint: 'Anaya Sharma',
              icon: Icons.person_outline_rounded,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter your name';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email
            _AuthField(
              controller: _emailCtrl,
              label: 'Email address',
              hint: 'you@college.edu',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            _AuthField(
              controller: _passCtrl,
              label: 'Password',
              hint: 'Min. 6 characters',
              icon: Icons.lock_outline_rounded,
              obscure: _obscurePass,
              suffix: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.darkGrey,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePass = !_obscurePass),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter a password';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm password
            _AuthField(
              controller: _confirmCtrl,
              label: 'Confirm password',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _obscureConfirm,
              suffix: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.darkGrey,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) {
                if (v != _passCtrl.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Terms agreement
            GestureDetector(
              onTap: () => setState(() => _agreed = !_agreed),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _agreed ? AppColors.blue : Colors.transparent,
                      border: Border.all(
                        color: _agreed ? AppColors.blue : AppColors.lightGrey,
                        width: 2,
                      ),
                    ),
                    child: _agreed
                        ? const Icon(Icons.check, size: 14, color: AppColors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: AppTypography.bodySmall,
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.coral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.coral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sign up button
            _PrimaryButton(
              label: 'Create Account',
              loading: _loading,
              onTap: _signUp,
            ),

            const SizedBox(height: 20),
            const _Divider(label: 'or sign up with'),
            const SizedBox(height: 20),

            // Google sign-up
            _GoogleButton(onTap: _loading ? null : _googleSignUp),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared reusable widgets
// ─────────────────────────────────────────────────────────────

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGrey.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: AppColors.lightBlue, size: 20),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.softGrey,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.coral, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onTap;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: loading ? null : onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: loading
                ? LinearGradient(colors: [
                    AppColors.blue.withOpacity(0.6),
                    AppColors.lightBlue.withOpacity(0.6),
                  ])
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _GoogleButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.lightGrey, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.white,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google G logo (drawn with text since no asset yet)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Center(
                child: Text(
                  'G',
                  style: AppTypography.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF4285F4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: AppTypography.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.lightGrey, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.lightGrey, thickness: 1)),
      ],
    );
  }
}
