import 'package:equatable/equatable.dart'; // Для сравнения состояний

// Базовое абстрактное состояние
abstract class EquationState extends Equatable {
  const EquationState();

  // Переопределяем props для корректного сравнения состояний
  @override
  List<Object> get props => [];
}

// Начальное состояние - форма ввода
class EquationInput extends EquationState {
  final String? aError; // Ошибка для поля A
  final String? bError; // Ошибка для поля B
  final String? cError; // Ошибка для поля C
  final bool isAgreed; // Флаг согласия с обработкой данных

  const EquationInput({
    this.aError,
    this.bError,
    this.cError,
    required this.isAgreed,
  });

  // Для сравнения состояний
  @override
  List<Object> get props => [aError ?? '', bError ?? '', cError ?? '', isAgreed];
}

// Состояние с результатами вычислений
class EquationResult extends EquationState {
  final double a; // Коэффициент A
  final double b; // Коэффициент B
  final double c; // Коэффициент C
  final String result; // Строка с результатом

  const EquationResult({
    required this.a,
    required this.b,
    required this.c,
    required this.result,
  });

  @override
  List<Object> get props => [a, b, c, result];
}