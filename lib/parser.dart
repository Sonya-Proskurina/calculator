import 'dart:math' as math;

class Parser {
  static Map<String, double Function(double arg)> mapFun = {
    "sin":(arg) {return math.sin(arg);},
    "cos":(arg) {return math.cos(arg);},
    "tg":(arg) {return math.tan(arg);},
    "asin":(arg) {return math.asin(arg);},
    "acos":(arg) {return math.acos(arg);},
    "atg":(arg) {return math.atan(arg);},
    "ln":(arg) {return math.log(arg);},
    "lg":(arg) {return math.log(arg)/math.log(10);},
  };
  
String printText(String text) {
  // String text = "22+3-2*(2*5+2)*4";
  print(text);
  // for (int i = 0; i< lexAnalyze(text).length; i++) {
  //   print(lexAnalyze(text)[i].type.name);
  //   print(lexAnalyze(text)[i].value);
  // }
  LexemeBuffer lexemeBuffer = LexemeBuffer(lexemes: lexAnalyze(text));
  // print(expr(lexemeBuffer).toStringAsFixed(8));
  return expr(lexemeBuffer).toStringAsFixed(8);
}

static double expr(LexemeBuffer lexemes) {
  Lexeme lexeme = lexemes.next();
  if (lexeme.type==LexemeType.EOF) {
    return 0;
  }
  else {
    lexemes.back();
    return plusminus(lexemes);
  }
}

static double plusminus(LexemeBuffer lexemes) {
  double val =multdiv(lexemes);
  while(true) {
    Lexeme lexeme = lexemes.next();
    if (lexeme.type==LexemeType.OP_PLUS) {
      val+=multdiv(lexemes);
    }
    else if (lexeme.type==LexemeType.OP_MINUS){
      val-=multdiv(lexemes);
    }
    else {
      lexemes.back();
      return val;
    }
  }
}

static double multdiv(LexemeBuffer lexemes) {
  double val =factor(lexemes);
  while(true) {
    Lexeme lexeme = lexemes.next();
    if (lexeme.type==LexemeType.OP_MUL) {
      val*=factor(lexemes);
    }
    else if (lexeme.type==LexemeType.OP_DIV){
      val/=factor(lexemes);
    }
    else {
      lexemes.back();
      return val;
    }
  }
}

static double factor(LexemeBuffer lexemes) {
  Lexeme lexeme = lexemes.next();
  switch(lexeme.type) {
    case LexemeType.OP_MINUS:
      double val = factor(lexemes);
      return -val;
    case LexemeType.NUMBER:
      return double.tryParse(lexeme.value)??0;
    default:
      throw "ERROR factor";
  }
}

List<Lexeme> lexAnalyze(String text) {
  List<Lexeme> list = [];
  int pos = 0;
  while(pos<text.length) {
    String c = text[pos];
    switch (c) {
      case '+':
        list.add(Lexeme(type: LexemeType.OP_PLUS, value: c));
        pos++;
        continue;
      case '-':
        list.add(Lexeme(type: LexemeType.OP_MINUS, value: c));
        pos++;
        continue;
      case '*':
        list.add(Lexeme(type: LexemeType.OP_MUL, value: c));
        pos++;
        continue;
      case '/':
        list.add(Lexeme(type: LexemeType.OP_DIV, value: c));
        pos++;
        continue;
      case 'e':
        list.add(Lexeme(type: LexemeType.NUMBER, value: math.e.toString()));
        pos++;
        continue;
      case '\u{03C0}':
        list.add(Lexeme(type: LexemeType.NUMBER, value: math.pi.toString()));
        pos++;
        continue;
      case '^':
        list.add(Lexeme(type: LexemeType.DEGREE, value: c));
        pos++;
        continue;
      default:
        if (isNumber(c)) {
          bool dot =false;
         String num = "";
         do {
           num+=c;
           if (c==".") dot = true;
           pos++;
           if (pos>=text.length) break;
           c = text[pos];
         } while (isNumber(c)||c=="."&&!dot);
         list.add(Lexeme(type: LexemeType.NUMBER, value: num));
        } else {
          String val="";
          if (c=="s") {
            val=="sin";
            list.add(Lexeme(type: LexemeType.NAME, value: "sin"));
            pos+=3;
          }
            if (c=="c") {
              val == "cos";
              list.add(Lexeme(type: LexemeType.NAME, value: "cos"));
              pos+=3;
            }
            if (c=="t") {
              val == "tg";
              list.add(Lexeme(type: LexemeType.NAME, value: "tg"));
              pos+=2;
            }
            if (c=="l") {
              if (text[pos+1]=="n") val = "ln";
              if (text[pos+1]=="g") val = "lg";
              list.add(Lexeme(type: LexemeType.NAME, value: val));
              pos+=(val.length);
            }
            if (c=="a") {
              if (text[pos+1]=="s") val = "asin";
              if (text[pos+1]=="c") val = "acos";
              if (text[pos+1]=="t") val = "atg";
              list.add(Lexeme(type: LexemeType.NAME, value: val));
              pos+=(val.length);
            }
        }
    }
  }
  list.add(Lexeme(type: LexemeType.EOF, value: ""));
  List<Lexeme> normalList = [];
  for(int i=list.length-1; i>=0;i--) {
    if (list[i].type!=LexemeType.DEGREE&&list[i].type!=LexemeType.NAME) {
      normalList.add(list[i]);
    }
    else {
      Lexeme last = normalList[normalList.length-1];
      normalList.removeLast();
      if (list[i].type==LexemeType.NAME) {
          double Function(double arg) f = mapFun[list[i].value]!;
          if (i+1<list.length) {
            normalList.add(Lexeme(type: LexemeType.NUMBER, value: f(double.tryParse(last.value)!).toString()));
          }
          else {
            throw "ERROR";
          }
      }
      if (list[i].type==LexemeType.DEGREE) {
        if (i-1<0) {
          throw "ERROR";
        } else {
          Lexeme osn = list[i-1];
          normalList.add(Lexeme(type: LexemeType.NUMBER, value: math.pow(double.tryParse(osn.value)!, double.tryParse(last.value)!).toString()));
          i--;
        }
      }
    }
  }
  list.clear();
  for (int i =normalList.length-1;i>=0;i--) {
    list.add(normalList[i]);
  }
  return list;
}

bool isNumber(String name) {
  bool isNumber = false;
  List<String> num = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  for (var element in num) {
    if (name == element) isNumber = true;
  }
  return isNumber;
}
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

enum LexemeType {
  OP_PLUS, OP_MINUS, OP_MUL, OP_DIV,
  NUMBER, NAME, DEGREE,
  EOF
}

class Lexeme {
  LexemeType type;
  String value;
  Lexeme({required this.type, required this.value});
}

class LexemeBuffer {
  int pos=0;
  List<Lexeme> lexemes;
  LexemeBuffer({required this.lexemes});

  Lexeme next() {
    return lexemes[pos++];
  }

  void back() {
    pos--;
  }

  int getPos() {
    return pos;
  }
}
