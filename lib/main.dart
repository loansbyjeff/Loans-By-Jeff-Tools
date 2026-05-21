import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Credit Card APR Finder',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff666666),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F5132),
          primary: const Color(0xFF0F5132),
        ),
      ),
      home: const ResponsiveWebWrapper(),
    );
  }
}

class ResponsiveWebWrapper extends StatelessWidget {
  const ResponsiveWebWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: const AprCalculatorScreen(),
        ),
      ),
    );
  }
}

class AprCalculatorScreen extends StatefulWidget {
  const AprCalculatorScreen({super.key});

  @override
  State<AprCalculatorScreen> createState() => _AprCalculatorScreenState();
}

class _AprCalculatorScreenState extends State<AprCalculatorScreen> {
  double _balance = 5000.0;
  double _minPayment = 150.0;
  String _aprResult = "24.00%";
  bool _isInputTooLow = false;

  @override
  void initState() {
    super.initState();
    _calculateApr();
  }

  void _calculateApr() {
    if (_balance > 0 && _minPayment > 0) {
      final double principalComponent = _balance * 0.01;
      final double estimatedMonthlyInterest = _minPayment - principalComponent;

      if (estimatedMonthlyInterest > 0) {
        final double monthlyRate = estimatedMonthlyInterest / _balance;
        final double apr = monthlyRate * 12 * 100;
        setState(() {
          _aprResult = "${apr.toStringAsFixed(2)}%";
          _isInputTooLow = false;
        });
      } else {
        setState(() {
          _aprResult = "Input Low";
          _isInputTooLow = true;
        });
      }
    } else {
      setState(() {
        _aprResult = "0.00%";
        _isInputTooLow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance,
                      color: const Color(0xff094ec8).withOpacity(0.8),
                      size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'MUTUAL of OMAHA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff094ec8),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const Text(
                'MORTGAGE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff094ec8),
                  letterSpacing: 5.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Credit Card APR Finder',
            textAlign: TextAlign.center, // Fixed typo
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            color: const Color(0xFFF8F9FA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Credit Card Balance (\$)',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${_balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5132)),
                  ),
                  Slider(
                    value: _balance,
                    min: 500,
                    max: 20000,
                    divisions: 195,
                    activeColor: const Color(0xFF0F5132),
                    inactiveColor: const Color(0xFFE2E8F0),
                    onChanged: (value) {
                      setState(() {
                        _balance = value;
                        _calculateApr();
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Fixed typo
                    children: [
                      Text('\$500',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFFA0AEC0))),
                      Text('\$20,000+',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFFA0AEC0))),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: const Color(0xFFF8F9FA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minimum Payment Required (\$)',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${_minPayment.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5132)),
                  ),
                  Slider(
                    value: _minPayment,
                    min: 25,
                    max: 1000,
                    divisions: 195,
                    activeColor: const Color(0xFF0F5132),
                    inactiveColor: const Color(0xFFE2E8F0),
                    onChanged: (value) {
                      setState(() {
                        _minPayment = value;
                        _calculateApr();
                      });
                    },
                  ),
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Fixed typo
                    children: [
                      Text('\$25',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFFA0AEC0))),
                      Text('\$1,000+',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFFA0AEC0))),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: _isInputTooLow
                  ? const Color(0xFFFFF5F5)
                  : const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isInputTooLow
                    ? const Color(0xFFFEB2B2)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'ESTIMATED ANNUAL APR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: _isInputTooLow
                        ? const Color(0xFFC53030)
                        : const Color(0xFFA0AEC0),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _aprResult,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: _isInputTooLow
                        ? const Color(0xFFC53030)
                        : const Color(0xFF48BB78),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isInputTooLow
                      ? 'Increase minimum payment'
                      : 'based on the current inputs',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isInputTooLow
                        ? const Color(0xFFE53E3E)
                        : const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            '* Created by Jeff Homolak. Assumptions include a 1% balance + interest formula.',
            textAlign: TextAlign.center, // Fixed typo
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF718096),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
