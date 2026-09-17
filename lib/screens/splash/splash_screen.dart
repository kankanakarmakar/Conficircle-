// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<double> _loadingProgress;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _loadingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

    _logoOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoScale = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _loadingProgress = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut));

    _logoController.forward().then((_) {
      _textController.forward();
      _loadingController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 300), widget.onComplete);
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Decorative blob - top left blue
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative blob - top right coral
          Positioned(
            top: -30,
            right: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.coral.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bottom hero image simulation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.38,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x66173883)],
                ),
              ),
            ),
          ),
          // Bottom left decoration
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bottom right coral blob
          Positioned(
            bottom: 60,
            right: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.coral.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Right-side vertical text
          Positioned(
            right: 24,
            top: size.height * 0.52,
            child: AnimatedBuilder(
              animation: _textOpacity,
              builder: (_, __) => Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['EXPLORE', 'LEARN', 'CONNECT', 'ACHIEVE']
                      .map((t) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              t,
                              style: AppTypography.montserrat(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),

          // Top right tagline
          Positioned(
            top: 64,
            right: 24,
            child: AnimatedBuilder(
              animation: _textOpacity,
              builder: (_, __) => Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Students Today.',
                        style: AppTypography.montserrat(
                          fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue,
                        )),
                    Text('Leaders Tomorrow.',
                        style: AppTypography.montserrat(
                          fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue,
                        )),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 30,
                      color: AppColors.coral,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom-left small text
          Positioned(
            bottom: 32,
            left: 24,
            child: AnimatedBuilder(
              animation: _textOpacity,
              builder: (_, __) => Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COLLEGE STUDENTS.',
                        style: AppTypography.montserrat(
                          fontSize: 9, fontWeight: FontWeight.w700,
                          color: AppColors.white, letterSpacing: 2.0,
                        )),
                    Text('A BRIGHTER TOMORROW',
                        style: AppTypography.montserrat(
                          fontSize: 9, fontWeight: FontWeight.w700,
                          color: AppColors.white, letterSpacing: 2.0,
                        )),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
  'assets/images/image.png',
  width: 90,
  height: 90,
),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Handwritten tagline
                AnimatedBuilder(
                  animation: _textOpacity,
                  builder: (_, __) => Opacity(
                    opacity: _textOpacity.value,
                    child: Column(
                      children: [
                        Text(
                          'A brighter you',
                          style: AppTypography.caveat(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'for a ',
                              style: AppTypography.caveat(
                                fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.blue,
                              ),
                            ),
                            TextSpan(
                              text: 'bigger tomorrow.',
                              style: AppTypography.caveat(
                                fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.coral,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Loading spinner
                AnimatedBuilder(
                  animation: _loadingProgress,
                  builder: (_, __) => Opacity(
                    opacity: _loadingProgress.value.clamp(0.0, 1.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue.withOpacity(0.5)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Creating your space...',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfiCircleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo mark
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            children: [
              // C shape
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(42, 42),
                        painter: _CPainter(),
                      ),
                    ),
                  ),
                ),
              ),
              // Coral dot
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Text logo
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Confi',
              style: AppTypography.montserrat(
                fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.blue,
              ),
            ),
            TextSpan(
              text: 'Circle',
              style: AppTypography.montserrat(
                fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.blue,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 4),
        Text(
          'Discover. Grow. Belong.',
          style: AppTypography.montserrat(
            fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkGrey,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _CPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.5,
      4.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CPainter oldDelegate) => false;
}
