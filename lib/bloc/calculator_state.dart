part of 'calculator_bloc.dart';

abstract class CalculatorState {}

class CalculatorCleanState extends CalculatorState {
  List<ButtonEntities> list;
  String order;
  String mantissa;
  String signMantissa;

  CalculatorCleanState(
      {required this.list,
      required this.mantissa,
      required this.order,
      required this.signMantissa,});
}

class CalculatorLoadingState extends CalculatorState {}

class CalculatorErrorState extends CalculatorState {}
