import 'package:calculator/entities/result_entitites.dart';
import 'package:flutter/material.dart';
import '../entities/buttons_entities.dart';
import 'parser.dart';
import '../res/colors/colors.dart';

class CalculatorRepository {
  List<String> textOrder = [];
  List<String> textMantissa = [];
  String signMantissa = "";
  String signOrder = " ";
  bool modeEE = false;
  bool other = false;
  int sizeMantissa = 1;
  int sizeOrder = 0;

  String res=" ";
  bool numInput = true;

  final List<ButtonEntities> _buttons = [
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
    ButtonEntities.forColor(fon: MyColors.orange, buttons: [
      ButtonBodyEntities.forName(name: "=", eventText: "="),
    ]),
  ];

  ResultEntities work(String name) {
    if (name == "C") {
      textOrder = [];
      textMantissa = ["0"];
      signOrder = " ";
      signMantissa = "";
      modeEE = false;
      other = false;
      sizeMantissa = 1;
      _buttons[2].fon = Colors.white10;
      sizeOrder = 0;
      res =" ";
    }
    if (!other) {
        if (isNumber(name)) {
          numInput=true;
          if (!modeEE) {
            if (textMantissa.length == 1 && textMantissa[0] == "0") {
              textMantissa.remove("0");
              sizeMantissa--;
            }
            if (sizeMantissa < 8) {
              if ((sizeMantissa > 0 &&
                  !isEPi(textMantissa[textMantissa.length - 1])) ||
                  sizeMantissa == 0) {
                textMantissa.add(name);
                sizeMantissa++;
              }
            }
          }
          else {
            if (sizeOrder < 2) {
              if ((sizeOrder > 0 && !isEPi(textOrder[textOrder.length - 1])) ||
                  sizeOrder == 0) {
                textOrder.add(name);
                sizeOrder++;
              }
            }
          }
        }
        if (modeEE == false) {
        switch (name) {
          case "e":
          case "\u{03C0}":
            numInput = true;
          if (textMantissa.length == 1 && textMantissa[0] == "0") {
              textMantissa.remove("0");
              sizeMantissa--;
            }
            if (sizeMantissa < 8) {
              if ((sizeMantissa > 0 &&
                      !isEPi(textMantissa[textMantissa.length - 1]) &&
                      !isNumber(textMantissa[textMantissa.length - 1])) ||
                  sizeMantissa == 0) {
                textMantissa.add(name);
                sizeMantissa++;
              }
            }
            break;
          case "del1":
            numInput = true;
            sizeMantissa -= textMantissa[textMantissa.length - 1].length;
            textMantissa.removeLast();
            if (textMantissa.isEmpty) {
              textMantissa.add("0");
              sizeMantissa++;
            }
            break;
          case "+/-":
            signMantissa = (signMantissa == "") ? "-" : "";
            break;
          case "^":
            numInput = false;
            if (sizeMantissa + 1 <= 8 &&
                isNumber(textMantissa[textMantissa.length - 1])) {
              textMantissa.add(name);
              sizeMantissa += name.length;
            }
            break;
          case ".":
            if (sizeMantissa + 1 <= 8 &&
                isNumber(textMantissa[textMantissa.length - 1])) {
              textMantissa.add(name);
              sizeMantissa += name.length;
            }
            break;
          case "+":
          case "-":
          case "/":
          case "*":
          numInput = false;
          if (sizeMantissa + 1 <= 9 && textMantissa[0] != "0") {
              if (isNumber(textMantissa[textMantissa.length - 1]) ||
                  isEPi(textMantissa[textMantissa.length - 1])) {
                textMantissa.add(name);
                sizeMantissa += name.length;
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
          numInput = false;
          if (textMantissa.length == 1 && textMantissa[0] == "0") {
              textMantissa.remove("0");
              sizeMantissa--;
            }
            if (sizeMantissa == 0 ||
                isOperation(textMantissa[textMantissa.length - 1]) ||
                isFunction(textMantissa[textMantissa.length - 1])) {
              if (sizeMantissa + name.length <= 8) {
                textMantissa.add(name);
                sizeMantissa += name.length;
              }
            }
            break;
        }
      } else {
        switch (name) {
          case "e":
          case "\u{03C0}":
            if (sizeOrder < 2) {
              if ((sizeOrder > 0 &&
                      !isEPi(textOrder[textOrder.length - 1]) &&
                      !isNumber(textOrder[textOrder.length - 1])) ||
                  sizeOrder == 0) {
                textOrder.add(name);
                sizeOrder++;
              }
            }
            break;
          case "del1":
            sizeOrder -= textOrder[textOrder.length - 1].length;
            textOrder.removeLast();
            break;
          case "+/-":
            signOrder = (signOrder == " ") ? "-" : " ";
            break;
        }
      }
      switch (name) {
        case "=":
          String otvet = "";
          try {
            res+=signMantissa+getLine(textMantissa);
            if (textOrder.isNotEmpty) {
              res+="*10^";
              if (signOrder!=" ") {
                res+="-";
              }
              res+=getLine(textOrder);
            }
            String bigO = Parser().printText(res);
            print(double.tryParse(bigO));
            if (double.tryParse(bigO)! > 99999999) {
              otvet = "overflow";
            } else {
              for (int i = 0; i < 8; i++) {
                otvet += bigO[i];
              }
            }
          } catch (e) {
            otvet = "ERROR";
          }
          textOrder = [];
          textMantissa = [otvet];
          signOrder = " ";
          signMantissa = "";
          modeEE = false;
          other = true;
          sizeMantissa = 1;
          sizeOrder = 0;
          break;
        case "change":
          for (var element in _buttons) {
            element.firstOn = !element.firstOn;
          }
          break;
        case "EE":
          modeEE = !modeEE;
          if (modeEE) {
            _buttons[2].fon =MyColors.orange;
          } else {
            _buttons[2].fon = MyColors.whiteP;
          }
          break;
      }
    }
    if (!numInput&&textMantissa[0]!="0") {
      if(signMantissa.isNotEmpty) {
        res+="-";
        signMantissa="";
      }
      res += getLine(textMantissa);
      textMantissa=["0"];
      sizeMantissa = 1;
      numInput=true;
      if (textOrder.isNotEmpty) {
        String s = res[res.length-1];
        res =res.substring(0, res.length - 1);
        res+="*10^";
        if (signOrder!=" ") {
          res+="-";
        }
        res+=getLine(textOrder);
        textOrder=[];
        signOrder = " ";
        sizeOrder=0;
        res+=s;
      }
    }
    return ResultEntities(res, _buttons, numInput, getLine(textMantissa),
        getLineOrder(textOrder, modeEE, signOrder), signMantissa);
  }

  List<ButtonEntities> getButtons() {
    return _buttons;
  }

  void changeMode() {
    for (var element in _buttons) {
      element.firstOn = !element.firstOn;
    }
  }

  String getLine(List<String> list) {
    String line = "";
    for (var element in list) {
      line += element;
    }
    return line;
  }

  String getLineOrder(List<String> list, bool modeEE, String signOrder) {
    String line = "";
    if (list.isNotEmpty) line = "E";
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
