import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const Color primaryRed = Color(0xFFB71C1C);

  void _handleGetStarted() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Animated red gradient background with soft glow waves
          const _AnimatedBackground(),

          // Top Navigation Bar
          const _TopNav(),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to SDCA AI Assistant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: size.width < 520 ? 32 : 48,
                        letterSpacing: 0.2,
                      ),
                    ).animate().fadeIn(duration: 700.ms).moveY(begin: 20, end: 0, curve: Curves.easeOut),
                    const SizedBox(height: 14),
                    Text(
                      'Your smart companion for student inquiries and campus information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF5F5F5),
                        fontWeight: FontWeight.w400,
                        fontSize: size.width < 520 ? 16 : 20,
                      ),
                    ).animate().fadeIn(duration: 800.ms).moveY(begin: 16, end: 0, curve: Curves.easeOut),
                    const SizedBox(height: 28),

                    // CTA Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: _GlowButton(
                        onPressed: _handleGetStarted,
                        child: Text('Get Started'),
                      ).animate().fadeIn(duration: 900.ms).moveY(begin: 12, end: 0, curve: Curves.easeOut),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNav extends StatefulWidget {
  const _TopNav();

  @override
  State<_TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<_TopNav> with SingleTickerProviderStateMixin {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
    

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // NAV ROW
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 24,
              vertical: isMobile ? 6 : 10,
            ),
            child: Row(
              mainAxisAlignment:
                  isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/Logo_white.png',
                  height: isMobile ? 45 : 50,
                ).animate().fadeIn(duration: 400.ms).moveY(begin: -8, end: 0, curve: Curves.easeOut),

                if (!isMobile) ...[
                  const Spacer(),
                  _NavButton(
                    label: 'Home',
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name != '/') {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  _NavButton(
                    label: 'Account',
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                ] else
                  // mobile menu icon
                  IconButton(
                    icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white),
                    onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  ),
              ],
            ),
          ),

          // MOBILE DROPDOWN — expands below the nav row (always visible when open)
          if (isMobile)
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // collapse when closed by limiting height to 0
                  maxHeight: _menuOpen ? 200 : 0,
                ),
                child: SingleChildScrollView(
                  // prevent overflow if many items
                  physics: _menuOpen ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Opacity(
                    opacity: _menuOpen ? 1 : 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0000).withValues(alpha:0.95),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _DropdownItem(
                            label: 'Home',
                            onTap: () {
                              setState(() => _menuOpen = false);
                              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                            },
                          ),
                          const Divider(height: 1, color: Colors.white24),
                          _DropdownItem(
                            label: 'Account',
                            onTap: () {
                              setState(() => _menuOpen = false);
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DropdownItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white.withValues(alpha:0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ).animate(target: _hovered ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.04, 1.04),
              duration: 120.ms,
            ),
      ),
    );
  }
}

class _GlowButton extends StatefulWidget {
  const _GlowButton({required this.onPressed, required this.child});
  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha:0.25),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _LandingPageState.primaryRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            child: widget.child,
          ),
        ),
      ).animate(target: _hovered ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03), duration: 180.ms)
        .moveY(begin: 0, end: -1, duration: 180.ms),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlowWavePainter(progress: _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _GlowWavePainter extends CustomPainter {
  _GlowWavePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // Base dark red tones (SDCA theme)
    final base = const Color(0xFF9B0000);
    final dark = const Color(0xFF200000);
    final lighter = const Color(0xFF200000);

    // ==== Background Gradient ====
    final rect = Offset.zero & size;
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [dark, base, lighter],
    );
    final basePaint = Paint()..shader = baseGradient.createShader(rect);
    canvas.drawRect(rect, basePaint);

    // ==== Radial Light Overlay ====
    final radialCenter = Offset(size.width * 0.1, size.height * 0.3);
    final radialGradient = RadialGradient(
      center: Alignment(
        (radialCenter.dx / size.width) * 2 - 1,
        (radialCenter.dy / size.height) * 2 - 1,
      ),
      radius: 0.3,
      colors: [
        const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.03),
        Colors.transparent,
      ],
      stops: const [0.0, 0.15],
    );
    final radialPaint = Paint()..shader = radialGradient.createShader(rect);
    canvas.drawRect(rect, radialPaint);

    // ==== Animated Soft Glow Circles ====
    final glowPaint = Paint()
      ..color = const Color.fromARGB(255, 228, 215, 37).withValues(alpha: 0.46)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 64);

    final t = progress * 2 * math.pi;
    final cx = size.width * (0.5 + 0.15 * math.sin(t));
    final cy = size.height * (0.5 + 0.10 * math.cos(t * 0.8));

    canvas.drawCircle(Offset(cx, cy), size.shortestSide * 0.35, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8),
        size.shortestSide * 0.25, glowPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.25),
        size.shortestSide * 0.2, glowPaint);

    // ==== Beautiful Layered Wave Overlay ====
    final waveGradient = LinearGradient(
      colors: [
        const Color(0xFFFFD700).withValues(alpha: 0.15),
        const Color(0xFFFFF176).withValues(alpha: 0.25),
        const Color(0xFFFFD700).withValues(alpha: 0.15),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    // Wave 1 - Primary wave
    final wavePaint1 = Paint()
      ..shader = waveGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Wave 2 - Secondary wave (slightly offset)
    final wavePaint2 = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Wave 3 - Tertiary wave (more subtle)
    final wavePaint3 = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Draw three waves at different positions with smooth curves
    _drawSmoothWave(canvas, size, t, 0.72, 18.0, 2.0, 0.0, wavePaint1);
    _drawSmoothWave(canvas, size, t, 0.68, 12.0, 1.5, 0.5, wavePaint2);
    _drawSmoothWave(canvas, size, t, 0.76, 8.0, 2.5, 1.0, wavePaint3);
  }

  void _drawSmoothWave(Canvas canvas, Size size, double t, double yPosition,
      double amplitude, double frequency, double phaseShift, Paint paint) {
    final path = Path();
    final yBase = size.height * yPosition;
    final segments = (size.width / 6).ceil(); // Smoother curves

    for (int i = 0; i <= segments; i++) {
      final x = (i / segments) * size.width;
      final wave1 = math.sin((x / size.width * frequency * math.pi) + t + phaseShift) * amplitude;
      final wave2 = math.sin((x / size.width * frequency * 1.5 * math.pi) - t * 0.7 + phaseShift) * (amplitude * 0.3);
      final y = yBase + wave1 + wave2;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic bezier for smooth curves
        final prevX = ((i - 1) / segments) * size.width;
        final controlX = (prevX + x) / 2;
        final prevWave1 = math.sin((prevX / size.width * frequency * math.pi) + t + phaseShift) * amplitude;
        final prevWave2 = math.sin((prevX / size.width * frequency * 1.5 * math.pi) - t * 0.7 + phaseShift) * (amplitude * 0.3);
        final controlY = yBase + prevWave1 + prevWave2;

        path.quadraticBezierTo(controlX, controlY, x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowWavePainter oldDelegate) => oldDelegate.progress != progress;
}


