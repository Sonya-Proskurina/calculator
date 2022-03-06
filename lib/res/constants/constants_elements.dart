import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ConstantElement {
   static Widget loadingWidget = const Center(child: CircularProgressIndicator(),);

   static Widget errorWidget = const Center(child: Text("Ошибка загрузки.\nПожалуйста проверьте интернет соединение.\n",textAlign: TextAlign.center,),);

}
