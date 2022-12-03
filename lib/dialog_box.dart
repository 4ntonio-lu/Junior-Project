import 'package:flutter/material.dart';
import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

   DialogBox({super.key, required this.controller,
  required this.onSave,
     required this.onCancel,
  });


  @override
  Widget build(BuildContext context)
  {
    return AlertDialog(
    backgroundColor: Colors.deepPurpleAccent,
    content: Container(
        height:120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        //get input
        TextField(
          controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Add a new task:",
        ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          //save
          MyButton(text: "Save", onPressed: onSave),
          const SizedBox(width: 6),
          //cancel, exit?
          MyButton(text: "Cancel", onPressed: onCancel),

        ],)

      ],)

    ),
    );
  }
}