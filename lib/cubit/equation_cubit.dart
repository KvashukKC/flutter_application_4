import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'equation_state.dart';

class EquationCubit extends Cubit<EquationState> {
  EquationCubit() : super(EquationInput(
    aError: null,
    bError: null,
    cError: null,
    isAgreed: false,
  )); // Инициализируем сразу состоянием ввода

  String? _aError;
  String? _bError;
  String? _cError;
  bool _isAgreed = false;

  void validateInput(String a, String b, String c) {
    _aError = null;
    _bError = null;
    _cError = null;

    if (a.isEmpty) {
      _aError = 'Поле не может быть пустым';
    } else if (double.tryParse(a) == null) {
      _aError = 'Введите число';
    } else if (double.parse(a) == 0) {
      _aError = 'Коэффициент a не может быть 0';
    }

    if (b.isEmpty) {
      _bError = 'Поле не может быть пустым';
    } else if (double.tryParse(b) == null) {
      _bError = 'Введите число';
    }

    if (c.isEmpty) {
      _cError = 'Поле не может быть пустым';
    } else if (double.tryParse(c) == null) {
      _cError = 'Введите число';
    }

    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }

  void toggleAgreement(bool? value) {
    _isAgreed = value ?? false;
    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }

  void calculate(String a, String b, String c) {
    if (_aError != null || _bError != null || _cError != null || !_isAgreed) {
      return;
    }

    final double aVal = double.parse(a);
    final double bVal = double.parse(b);
    final double cVal = double.parse(c);

    final discriminant = bVal * bVal - 4 * aVal * cVal;
    String result;

    if (discriminant > 0) {
      final x1 = (-bVal + sqrt(discriminant)) / (2 * aVal);
      final x2 = (-bVal - sqrt(discriminant)) / (2 * aVal);
      result = 'Два действительных корня:\n'
          'x₁ = ${x1.toStringAsFixed(2)}\n'
          'x₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      final x = -bVal / (2 * aVal);
      result = 'Один действительный корень:\n'
          'x = ${x.toStringAsFixed(2)}';
    } else {
      final realPart = -bVal / (2 * aVal);
      final imaginaryPart = sqrt(-discriminant) / (2 * aVal);
      result = 'Два комплексных корня:\n'
          'x₁ = ${realPart.toStringAsFixed(2)} + ${imaginaryPart.toStringAsFixed(2)}i\n'
          'x₂ = ${realPart.toStringAsFixed(2)} - ${imaginaryPart.toStringAsFixed(2)}i';
    }

    emit(EquationResult(
      a: aVal,
      b: bVal,
      c: cVal,
      result: result,
    ));
  }

  void returnToInput() {
    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }
}