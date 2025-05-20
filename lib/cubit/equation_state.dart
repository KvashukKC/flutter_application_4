import 'package:equatable/equatable.dart';

abstract class EquationState extends Equatable {
  const EquationState();

  @override
  List<Object> get props => [];
}

class EquationInitial extends EquationState {}

class EquationInput extends EquationState {
  final String? aError;
  final String? bError;
  final String? cError;
  final bool isAgreed;

  const EquationInput({
    this.aError,
    this.bError,
    this.cError,
    required this.isAgreed,
  });

  @override
  List<Object> get props => [aError ?? '', bError ?? '', cError ?? '', isAgreed];
}

class EquationResult extends EquationState {
  final double a;
  final double b;
  final double c;
  final String result;

  const EquationResult({
    required this.a,
    required this.b,
    required this.c,
    required this.result,
  });

  @override
  List<Object> get props => [a, b, c, result];
}