import 'package:calculator/entities/buttont_entities.dart';
import 'package:flutter/material.dart';
import 'button_widget.dart';
import 'delegate.dart';

class KeyboardWidget extends StatelessWidget {
  List<ButtonEntities> list;
  KeyboardWidget({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedH(
        crossAxisCount: 4,
        // mainAxisSpacing: 4.0,
        // crossAxisSpacing: 4.0,
        height: MediaQuery.of(context).size.height/10,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ButtonWidget(buttonEntities: list[index]);
      },
    );
  }
}
