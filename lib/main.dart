import 'package:auto_size_text/auto_size_text.dart';
import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/repository/calculator_repository.dart';
import 'package:calculator/res/colors/colors.dart';
import 'package:calculator/res/constants/constants_elements.dart';
import 'package:calculator/widgets/keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider<CalculatorBloc>(
            create: (context) =>
                CalculatorBloc(repository: CalculatorRepository())),
      ], child: const HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<CalculatorBloc>().add(LoadedEvent());
    return Scaffold(
      backgroundColor: MyColors.black,
      body: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
        if (state is CalculatorLoadingState) {
          return ConstantElement.loadingWidget;
        } else if (state is CalculatorCleanState) {
          return Container(
            margin: const EdgeInsetsDirectional.all(8),
            child: Column(
              children: [
                const Spacer(),
               Container(
                    padding: const EdgeInsetsDirectional.all(16),
                    // decoration:
                    // BoxDecoration(border: Border.all(color: MyColors.grey)),
                    margin: const EdgeInsetsDirectional.all(8),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      // child: Expanded(
                        child: AutoSizeText(
                            state.res,
                            style: const TextStyle(
                                fontFamily: "Seven",
                                fontSize: 20,
                                color:MyColors.orange),
                          ),
                      // ),
                    ),
                ),
                 Container(
                    padding: const EdgeInsetsDirectional.all(16),
                    margin: const EdgeInsetsDirectional.all(8),
                    decoration:
                        BoxDecoration(border: Border.all(color: MyColors.grey)),
                    child: Row(
                      children: [
                        Stack(alignment: Alignment.centerRight, children: [
                          const Text(
                            "8",
                            style: TextStyle(
                                fontFamily: "Seven",
                                fontSize: 45,
                                color:MyColors.whiteP),
                          ),
                          Text(
                            state.signMantissa,
                            style: const TextStyle(
                                fontFamily: "Seven",
                                fontSize: 45,
                                color: MyColors.orange),
                          ),
                        ]),
                        const Spacer(),
                        Stack(alignment: Alignment.centerRight, children: [
                          const Text(
                            "88888888",
                            style: TextStyle(
                                fontFamily: "Seven",
                                fontSize: 45,
                                color: MyColors.whiteP),
                          ),
                          Text(
                            state.mantissa,
                            style: const TextStyle(
                                fontFamily: "Seven",
                                fontSize: 45,
                                color: MyColors.orange),
                          ),
                        ]),
                        const SizedBox(width: 8),
                        Stack(alignment: Alignment.topRight, children: [
                          const Text(
                            "8888",
                            style: TextStyle(
                                fontFamily: "Seven",
                                fontSize: 20,
                                color: MyColors.whiteP),
                          ),
                          Text(
                            state.order,
                            style: const TextStyle(
                                fontFamily: "Seven",
                                fontSize: 20,
                                color: MyColors.orange),
                          ),
                        ]),
                      ],
                    ),
                  ),
                Flexible(flex: 4, child: KeyboardWidget(list: state.list)),
              ],
            ),
          );
        } else {
          return ConstantElement.errorWidget;
        }
      }),
    );
  }
}
