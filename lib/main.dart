import 'package:calculator/bloc/calculator_bloc.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)),
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<CalculatorBloc>(create: (context) => CalculatorBloc()),
      ], child: const HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
        if (state is CalculatorLoadingState) {
          return ConstantElement.loadingWidget;
        } else if (state is CalculatorCleanState) {
          return Container(
            margin: const EdgeInsetsDirectional.all(8),
            child: Column(
              children: [
                const SizedBox(height: 128),
                Container(
                  height: 80,
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
                              color: Colors.white10),
                        ),
                        Text(
                          state.signMantissa,
                          style: const TextStyle(
                              fontFamily: "Seven",
                              fontSize: 45,
                              color: Colors.deepOrangeAccent),
                        ),
                      ]),
                      const Spacer(),
                      Stack(alignment: Alignment.centerRight, children: [
                        const Text(
                          "88888888",
                          style: TextStyle(
                              fontFamily: "Seven",
                              fontSize: 45,
                              color: Colors.white10),
                        ),
                        Text(
                          state.mantissa,
                          style: const TextStyle(
                              fontFamily: "Seven",
                              fontSize: 45,
                              color: Colors.deepOrangeAccent),
                        ),
                      ]),
                      const SizedBox(width: 8),
                      Stack(alignment: Alignment.topRight, children: [
                        const Text(
                          "8888",
                          style: TextStyle(
                              fontFamily: "Seven",
                              fontSize: 20,
                              color: Colors.white10),
                        ),
                        Text(
                          state.order,
                          style: const TextStyle(
                              fontFamily: "Seven",
                              fontSize: 20,
                              color: Colors.deepOrangeAccent),
                        ),
                      ]),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: KeyboardWidget(list: state.list)),
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
