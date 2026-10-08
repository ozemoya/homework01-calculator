import 'package:calculator_app/calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void enter(CalculatorEngine calculator, String keys) {
  for (final key in keys.split(' ')) {
    calculator.press(key);
  }
}

void main() {
  test('four operations and a negative result', () {
    final calculator = CalculatorEngine();
    enter(calculator, '8 + 7 =');
    expect(calculator.display, '15');
    enter(calculator, 'AC 9 − 1 4 =');
    expect(calculator.display, '-5');
    enter(calculator, 'AC 6 × 0 =');
    expect(calculator.display, '0');
    enter(calculator, 'AC 8 ÷ 2 =');
    expect(calculator.display, '4');
  });

  test('division by zero and incomplete input recover', () {
    final calculator = CalculatorEngine();
    enter(calculator, '8 ÷ 0 =');
    expect(calculator.errorMessage, contains('divide by zero'));
    enter(calculator, 'AC 2 + =');
    expect(calculator.errorMessage, contains('second number'));
    enter(calculator, 'AC 3 + 4 =');
    expect(calculator.display, '7');
    expect(calculator.errorMessage, isNull);
  });

  test('repeated operator changes selection and result starts a new input', () {
    final calculator = CalculatorEngine();
    enter(calculator, '8 + × 2 =');
    expect(calculator.display, '16');
    calculator.press('4');
    expect(calculator.display, '4');
    enter(calculator, '+ 1 =');
    expect(calculator.display, '5');
  });
}
