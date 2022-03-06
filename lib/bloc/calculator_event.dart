part of 'calculator_bloc.dart';

abstract class CalculatorEvent {}

class AddElementEvent extends CalculatorEvent{
  String name;
  AddElementEvent({required this.name});
}
