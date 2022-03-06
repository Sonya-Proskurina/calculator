import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/entities/buttont_entities.dart';
import 'package:calculator/res/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonWidget extends StatelessWidget {
  ButtonEntities buttonEntities;
  ButtonWidget({Key? key, required this.buttonEntities}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if (buttonEntities.buttons.length == 1) {
      final contentBody = buttonEntities.buttons[0];
      body = (contentBody.name != null)
          ? Text(
              contentBody.name.toString(),
              style: const TextStyle(fontSize: 16),
            )
          : Icon(contentBody.iconData);
    } else {
      final contentBodyTop = (buttonEntities.firstOn)
          ? buttonEntities.buttons[1]
          : buttonEntities.buttons[0];
      final contentBodyBottom = (buttonEntities.firstOn)
          ? buttonEntities.buttons[0]
          : buttonEntities.buttons[1];
      body = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // const SizedBox(height: 8),
        (contentBodyTop.name != null)
            ? Text(contentBodyTop.name.toString(),
                style: const TextStyle(color: MyColors.grey, fontSize: 10))
            : Icon(contentBodyTop.iconData, color: MyColors.grey),
        const SizedBox(height: 8),
        (contentBodyBottom.name != null)
            ? Text(
                contentBodyBottom.name.toString(),
                style: const TextStyle(fontSize: 16),
              )
            : Icon(contentBodyBottom.iconData),
      ]);
    }
    return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        child: body,
        onPressed: () {
          String name = "";
          if (buttonEntities.buttons.length == 1 || buttonEntities.firstOn) {
            name = buttonEntities.buttons[0].eventText;
          } else {
            name = buttonEntities.buttons[1].eventText;
          }
          context.read<CalculatorBloc>().add(AddElementEvent(name: name));
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          primary: buttonEntities.fon,
        ),
      ),
    );
  }
}
