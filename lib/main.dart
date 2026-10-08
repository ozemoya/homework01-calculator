// Myles Miller (002753776) · Homework 01 · Undergraduate pathway.
import 'package:flutter/material.dart';

import 'calculator_engine.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final CalculatorEngine _engine = CalculatorEngine();
  bool _isDark = false;

  void _press(String key) => setState(() => _engine.press(key));

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF355C7D)),
      useMaterial3: true,
    );
    final dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8BC4F0),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'Calculator Studio',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 300),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator Studio'),
          actions: [
            IconButton(
              tooltip: _isDark ? 'Switch to light theme' : 'Switch to dark theme',
              onPressed: () => setState(() => _isDark = !_isDark),
              icon: Icon(_isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: _Display(engine: _engine),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _keyRow(['AC', '÷', '×', '−']),
                        _keyRow(['7', '8', '9', '+']),
                        _keyRow(['4', '5', '6', '=']),
                        _keyRow(['1', '2', '3', '0']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _keyRow(List<String> keys) => Expanded(
        child: Row(
          children: [
            for (final key in keys)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _CalculatorKey(label: key, onPressed: () => _press(key)),
                ),
              ),
          ],
        ),
      );
}

class _Display extends StatelessWidget {
  const _Display({required this.engine});
  final CalculatorEngine engine;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(engine.expression, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Semantics(
            liveRegion: true,
            label: 'Calculator display ${engine.display}',
            child: SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  engine.display,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            liveRegion: true,
            child: Text(
              engine.errorMessage ?? 'Ready',
              style: TextStyle(
                color: engine.errorMessage == null ? colors.onSurfaceVariant : colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorKey extends StatelessWidget {
  const _CalculatorKey({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  String get _accessibleLabel => switch (label) {
        'AC' => 'All clear',
        '÷' => 'Divide',
        '×' => 'Multiply',
        '−' => 'Subtract',
        '+' => 'Add',
        '=' => 'Equals',
        _ => label,
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAction = const ['AC', '÷', '×', '−', '+', '='].contains(label);
    final isEquals = label == '=';
    return Semantics(
      button: true,
      label: _accessibleLabel,
      child: Material(
        color: isEquals
            ? colors.primary
            : isAction
                ? colors.secondaryContainer
                : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isEquals
                        ? colors.onPrimary
                        : isAction
                            ? colors.onSecondaryContainer
                            : colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
