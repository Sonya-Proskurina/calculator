import 'package:bloc/bloc.dart';
import 'package:calculator/entities/buttont_entities.dart';
import 'package:calculator/parser.dart';
import 'package:calculator/res/colors/colors.dart';
import 'package:flutter/material.dart';

part 'calculator_event.dart';

part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  bool error = false;
  static List<ButtonEntities> buttons = [
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "C", eventText: "C"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forIcon(
          iconData: Icons.backspace_outlined, eventText: "del1"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "EE", eventText: "EE"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "/", eventText: "/"),
      ButtonBodyEntities.forName(name: "+/-", eventText: "+/-"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "7", eventText: "7"),
      ButtonBodyEntities.forName(name: "sin", eventText: "sin"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "8", eventText: "8"),
      ButtonBodyEntities.forName(name: "cos", eventText: "cos"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "9", eventText: "9"),
      ButtonBodyEntities.forName(name: "tg", eventText: "tg"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "X", eventText: "*"),
      ButtonBodyEntities.forName(name: "\u{03C0}", eventText: "\u{03C0}"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "4", eventText: "4"),
      ButtonBodyEntities.forName(name: "asin", eventText: "asin"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "5", eventText: "5"),
      ButtonBodyEntities.forName(name: "acos", eventText: "acos"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "6", eventText: "6"),
      ButtonBodyEntities.forName(name: "atg", eventText: "atg"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "-", eventText: "-"),
      ButtonBodyEntities.forName(name: "x^y", eventText: "^"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "1", eventText: "1"),
      ButtonBodyEntities.forName(name: "e^x", eventText: "e^"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "2", eventText: "2"),
      ButtonBodyEntities.forName(name: "lnx", eventText: "ln"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "3", eventText: "3"),
      ButtonBodyEntities.forName(name: "lgx", eventText: "lg"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "+", eventText: "+"),
      ButtonBodyEntities.forName(name: "10^x", eventText: "10^"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forIcon(
          iconData: Icons.wifi_protected_setup_outlined, eventText: "change"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: "0", eventText: "0"),
      ButtonBodyEntities.forName(name: "e", eventText: "e"),
    ]),
    ButtonEntities(buttons: [
      ButtonBodyEntities.forName(name: ".", eventText: "."),
    ]),
    ButtonEntities.forColor(fon: MyColors.primary, buttons: [
      ButtonBodyEntities.forName(name: "=", eventText: "="),
    ]),
  ];

  List<String> textOrder = [];
  List<String> textMantissa = ["0"];
  String signOrder = " ";
  String signMantissa = "";
  bool modeEE = false;
  int sizeMantissa = 1;
  int sizeOrder = 0;

  CalculatorBloc()
      : super(CalculatorCleanState(
          list: buttons,
          order: "",
          mantissa: "0",
          signMantissa: "",
        )) {
    on<AddElementEvent>((event, emit) {
      if (event.name=="C") {
        textOrder = [];
        textMantissa = ["0"];
        signOrder = " ";
        signMantissa = "";
        modeEE = false;
        error = false;
        sizeMantissa = 1;
        sizeOrder = 0;
        emit(CalculatorCleanState(
            list: buttons,
            mantissa: getLine(textMantissa),
            order: getLineOrder(textOrder),
            signMantissa: signMantissa));
      }
      if (!error) {
        if (modeEE == false) {
          switch (event.name) {
            case "0":
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
              if (textMantissa.length == 1 && textMantissa[0] == "0") {
                textMantissa.remove("0");
                sizeMantissa--;
              }
              if (sizeMantissa < 8) {
                if ((sizeMantissa > 0 &&
                    !isEPi(textMantissa[textMantissa.length - 1])) ||
                    sizeMantissa == 0) {
                  textMantissa.add(event.name);
                  sizeMantissa++;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
            case "e":
            case "\u{03C0}":
              if (textMantissa.length == 1 && textMantissa[0] == "0") {
                textMantissa.remove("0");
                sizeMantissa--;
              }
              if (sizeMantissa < 8) {
                if ((sizeMantissa > 0 &&
                    !isEPi(textMantissa[textMantissa.length - 1]) &&
                    !isNumber(textMantissa[textMantissa.length - 1])) ||
                    sizeMantissa == 0) {
                  textMantissa.add(event.name);
                  sizeMantissa++;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
            case "del1":
              sizeMantissa -= textMantissa[textMantissa.length - 1].length;
              textMantissa.removeLast();
              if (textMantissa.isEmpty) {
                textMantissa.add("0");
                sizeMantissa++;
              }
              emit(CalculatorCleanState(
                  list: buttons,
                  mantissa: getLine(textMantissa),
                  order: getLineOrder(textOrder),
                  signMantissa: signMantissa));
              break;
            case "+/-":
              signMantissa = (signMantissa == "") ? "-" : "";
              emit(CalculatorCleanState(
                  list: buttons,
                  mantissa: getLine(textMantissa),
                  order: getLineOrder(textOrder),
                  signMantissa: signMantissa));
              break;

            case "^":
            case ".":
              if (sizeMantissa + 1 <= 8 &&
                  isNumber(textMantissa[textMantissa.length - 1])) {
                textMantissa.add(event.name);
                sizeMantissa += event.name.length;
                emit(CalculatorCleanState(
                    list: buttons,
                    mantissa: getLine(textMantissa),
                    order: getLineOrder(textOrder),
                    signMantissa: signMantissa));
              }
              break;
            case "+":
            case "-":
            case "/":
            case "*":
              if (sizeMantissa + 1 <= 8 && textMantissa[0] != "0") {
                if (isNumber(textMantissa[textMantissa.length - 1]) ||
                    isEPi(textMantissa[textMantissa.length - 1])) {
                  textMantissa.add(event.name);
                  sizeMantissa += event.name.length;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
            case "10^":
            case "sin":
            case "asin":
            case "cos":
            case "acos":
            case "tg":
            case "atg":
            case "e^":
            case "ln":
            case "lg":
              if (textMantissa.length == 1 && textMantissa[0] == "0") {
                textMantissa.remove("0");
                sizeMantissa--;
              }
              if (sizeMantissa == 0 ||
                  isOperation(textMantissa[textMantissa.length - 1]) ||
                  isFunction(textMantissa[textMantissa.length - 1])) {
                if (sizeMantissa + event.name.length <= 8) {
                  textMantissa.add(event.name);
                  sizeMantissa += event.name.length;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
          }
        } else {
          switch (event.name) {
            case "0":
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
            case "6":
            case "7":
            case "8":
            case "9":
              if (sizeOrder < 2) {
                if ((sizeOrder > 0 &&
                    !isEPi(textOrder[textOrder.length - 1])) ||
                    sizeOrder == 0) {
                  textOrder.add(event.name);
                  sizeOrder++;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
            case "e":
            case "\u{03C0}":
              if (sizeOrder < 2) {
                if ((sizeOrder > 0 && !isEPi(textOrder[textOrder.length - 1]) &&
                    !isNumber(textOrder[textOrder.length - 1])) ||
                    sizeOrder == 0) {
                  textOrder.add(event.name);
                  sizeOrder++;
                  emit(CalculatorCleanState(
                      list: buttons,
                      mantissa: getLine(textMantissa),
                      order: getLineOrder(textOrder),
                      signMantissa: signMantissa));
                }
              }
              break;
            case "del1":
              sizeOrder -= textOrder[textOrder.length - 1].length;
              textOrder.removeLast();
              emit(CalculatorCleanState(
                  list: buttons,
                  mantissa: getLine(textMantissa),
                  order: getLineOrder(textOrder),
                  signMantissa: signMantissa));
              break;
            case "+/-":
              signOrder = (signOrder == " ") ? "-" : " ";
              emit(CalculatorCleanState(
                  list: buttons,
                  mantissa: getLine(textMantissa),
                  order: getLineOrder(textOrder),
                  signMantissa: signMantissa));
              break;
          }
        }
        switch (event.name) {
          case "=":
            String otvet;
            try {
              otvet = Parser().printText(getLine(textMantissa));
              print(otvet);
              textOrder = [];
              textMantissa = [otvet];
              signOrder = " ";
              signMantissa = "";
              modeEE = false;
              sizeMantissa = 1;
              sizeOrder = 0;
            } catch (e) {
              otvet = "ERROR";
              textMantissa = [otvet];
              error = true;
            }
            emit(CalculatorCleanState(
                list: buttons,
                mantissa: getLine(textMantissa),
                order: getLineOrder(textOrder),
                signMantissa: signMantissa));
            break;
          case "change":
            for (var element in buttons) {
              element.firstOn = !element.firstOn;
            }
            emit(CalculatorCleanState(
                list: buttons,
                mantissa: getLine(textMantissa),
                order: getLineOrder(textOrder),
                signMantissa: signMantissa));
            break;
          case "EE":
            modeEE = !modeEE;
            emit(CalculatorCleanState(
                list: buttons,
                mantissa: getLine(textMantissa),
                order: getLineOrder(textOrder),
                signMantissa: signMantissa));
            break;
        }
      }
    });
  }

  String getLine(List<String> list) {
    String line = "";
    for (var element in list) {
      line += element;
    }
    return line;
  }

  String getLineOrder(List<String> list) {
    String line = "";
    if (modeEE) line = "E";
    line += signOrder;
    line += getLine(list);
    while (line.length < 4) {
      line += " ";
    }
    return line;
  }

  bool isNumber(String name) {
    bool isNumber = false;
    List<String> num = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    for (var element in num) {
      if (name == element) isNumber = true;
    }
    return isNumber;
  }

  bool isEPi(String name) {
    return name == "e" || name == "\u{03C0}";
  }

  bool isOperation(String name) {
    bool isOperation = false;
    List<String> operations = ["+", "-", "/", "*"];
    for (var element in operations) {
      if (name == element) isOperation = true;
    }
    return isOperation;
  }

  bool isFunction(String name) {
    bool isFunction = false;
    List<String> functions = [
      "sin",
      "cos",
      "tg",
      "asin",
      "acos",
      "atg",
      "e^",
      "10^",
      "^",
      "ln",
      "lg"
    ];
    for (var element in functions) {
      if (name == element) isFunction = true;
    }
    return isFunction;
  }
}
