/// A two-operand calculator. The display is the single source of truth for
/// the current entry; the UI only renders this state.
class CalculatorEngine {
  String display = '0';
  double? firstOperand;
  String? pendingOperator;
  bool awaitingSecond = false;
  bool justCalculated = false;
  String? errorMessage;

  String get expression {
    final operator = pendingOperator;
    if (operator == null) return justCalculated ? 'Result' : 'Enter a calculation';
    return '${_format(firstOperand ?? 0)} $operator ${awaitingSecond ? '…' : display}';
  }

  void press(String key) {
    if (key == 'AC') {
      clear();
    } else if ('0123456789'.contains(key) && key.length == 1) {
      _digit(key);
    } else if (const ['+', '−', '×', '÷'].contains(key)) {
      _operator(key);
    } else if (key == '=') {
      _equals();
    }
  }

  void clear() {
    display = '0';
    firstOperand = null;
    pendingOperator = null;
    awaitingSecond = false;
    justCalculated = false;
    errorMessage = null;
  }

  void _digit(String digit) {
    if (errorMessage != null || justCalculated) clear();
    if (awaitingSecond) {
      display = digit;
      awaitingSecond = false;
    } else if (display == '0') {
      display = digit;
    } else if (display.length < 12) {
      display += digit;
    }
    errorMessage = null;
  }

  void _operator(String operator) {
    if (errorMessage != null) return;
    if (pendingOperator != null && !awaitingSecond) {
      _calculate();
      if (errorMessage != null) return;
    }
    firstOperand = double.parse(display);
    pendingOperator = operator;
    awaitingSecond = true;
    justCalculated = false;
  }

  void _equals() {
    if (errorMessage != null) return;
    if (pendingOperator == null) {
      errorMessage = 'Choose an operation first.';
      return;
    }
    if (awaitingSecond) {
      errorMessage = 'Enter a second number.';
      return;
    }
    _calculate();
    if (errorMessage == null) justCalculated = true;
  }

  void _calculate() {
    final left = firstOperand;
    final operator = pendingOperator;
    final right = double.tryParse(display);
    if (left == null || right == null || operator == null) {
      errorMessage = 'Calculation is incomplete. Tap AC to reset.';
      return;
    }
    if (operator == '÷' && right == 0) {
      errorMessage = 'Cannot divide by zero. Tap AC or enter a new number.';
      return;
    }
    final result = switch (operator) {
      '+' => left + right,
      '−' => left - right,
      '×' => left * right,
      '÷' => left / right,
      _ => double.nan,
    };
    if (!result.isFinite) {
      errorMessage = 'Result is too large. Tap AC to reset.';
      return;
    }
    display = _format(result);
    firstOperand = null;
    pendingOperator = null;
    awaitingSecond = false;
    errorMessage = null;
  }

  String _format(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e12) {
      return value.toInt().toString();
    }
    final rounded = value.toStringAsPrecision(10);
    return rounded.contains('.')
        ? rounded.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
        : rounded;
  }
}
