import 'package:flutter_bloc/flutter_bloc.dart'; // Для работы с Cubit
import 'dart:math'; // Для математических вычислений

import 'equation_state.dart'; // Импорт состояний

class EquationCubit extends Cubit<EquationState> {
  // Конструктор - инициализируем состояние формой ввода
  EquationCubit() : super(EquationInput(
    aError: null,
    bError: null,
    cError: null,
    isAgreed: false,
  ));

  // Приватные переменные для хранения текущих ошибок и состояния чекбокса
  String? _aError;
  String? _bError;
  String? _cError;
  bool _isAgreed = false;

  // Валидация введенных данных
  void validateInput(String a, String b, String c) {
    // Сбрасываем предыдущие ошибки
    _aError = _bError = _cError = null;

    // Валидация коэффициента A
    if (a.isEmpty) {
      _aError = 'Поле не может быть пустым';
    } else if (double.tryParse(a) == null) {
      _aError = 'Введите число';
    } else if (double.parse(a) == 0) {
      _aError = 'Коэффициент a не может быть 0';
    }

    // Валидация коэффициента B
    if (b.isEmpty) {
      _bError = 'Поле не может быть пустым';
    } else if (double.tryParse(b) == null) {
      _bError = 'Введите число';
    }

    // Валидация коэффициента C
    if (c.isEmpty) {
      _cError = 'Поле не может быть пустым';
    } else if (double.tryParse(c) == null) {
      _cError = 'Введите число';
    }

    // Переходим в состояние ввода с обновленными ошибками
    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }

  // Изменение состояния чекбокса согласия
  void toggleAgreement(bool? value) {
    _isAgreed = value ?? false;
    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }

  // Вычисление корней уравнения
  void calculate(String a, String b, String c) {
    // Если есть ошибки или нет согласия - не вычисляем
    if (_aError != null || _bError != null || _cError != null || !_isAgreed) return;

    final double aVal = double.parse(a);
    final double bVal = double.parse(b);
    final double cVal = double.parse(c);

    final discriminant = bVal * bVal - 4 * aVal * cVal;
    String result;

    // Вычисляем корни в зависимости от дискриминанта
    if (discriminant > 0) {
      // Два действительных корня
      final x1 = (-bVal + sqrt(discriminant)) / (2 * aVal);
      final x2 = (-bVal - sqrt(discriminant)) / (2 * aVal);
      result = 'Два действительных корня:\nx₁ = ${x1.toStringAsFixed(2)}\nx₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      // Один действительный корень
      final x = -bVal / (2 * aVal);
      result = 'Один действительный корень:\nx = ${x.toStringAsFixed(2)}';
    } else {
      // Комплексные корни
      final realPart = -bVal / (2 * aVal);
      final imaginaryPart = sqrt(-discriminant) / (2 * aVal);
      result = 'Два комплексных корня:\nx₁ = ${realPart.toStringAsFixed(2)} + ${imaginaryPart.toStringAsFixed(2)}i\nx₂ = ${realPart.toStringAsFixed(2)} - ${imaginaryPart.toStringAsFixed(2)}i';
    }

    // Переходим в состояние с результатами
    emit(EquationResult(
      a: aVal,
      b: bVal,
      c: cVal,
      result: result,
    ));
  }

  // Возврат к форме ввода
  void returnToInput() {
    emit(EquationInput(
      aError: _aError,
      bError: _bError,
      cError: _cError,
      isAgreed: _isAgreed,
    ));
  }
}