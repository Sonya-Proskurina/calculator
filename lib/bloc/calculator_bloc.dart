import 'package:bloc/bloc.dart';
import 'package:calculator/repository/calculator_repository.dart';
import '../entities/buttons_entities.dart';
part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  bool other = false;
  CalculatorRepository repository;
  CalculatorBloc({required this.repository})
      : super(CalculatorLoadingState()) {
    on<AddElementEvent>((event, emit) {
     final result = repository.work(event.name);
     emit(CalculatorCleanState(
         list: result.list,
         mantissa: result.mantissa,
         order: result.order,
         signMantissa: result.signMantissa));
    });
    on<LoadedEvent>((event, emit) {
      final result = repository.work("C");
      emit(CalculatorCleanState(
          list: result.list,
          mantissa: result.mantissa,
          order: result.order,
          signMantissa: result.signMantissa));
    });
  }
}
