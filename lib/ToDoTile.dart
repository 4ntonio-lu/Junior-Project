import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:junior_project_three/my_button.dart';
import 'package:junior_project_three/my_home_page.dart';
import 'package:get/get.dart';

class ToDoTile extends StatefulWidget {
  final String reminderName;
  bool reminderCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  final confettiCtl;

  _play()
  {
    confettiCtl.play();
  }

  ToDoTile({
    super.key,
    required this.reminderName,
    required this.reminderCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.confettiCtl
  });

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  late final confettiCtl = ConfettiController(duration: const Duration(seconds: 1));
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            /*
            SlidableAction(
              onPressed: widget.deleteFunction,
              icon: Icons.check,
              backgroundColor: Colors.green,
              borderRadius: BorderRadius.circular(10),
            )
            */
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.deepPurple[400],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // checkbox
              Checkbox(
                value: widget.reminderCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    widget.reminderCompleted = value ?? false;
                  });
                  if(value == true) {
                    confettiCtl.play();
                  }

                },
                activeColor: Colors.black,
              ),
              // task name
              Text(
                widget.reminderName,
                style: TextStyle(
                  decoration: widget.reminderCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
          ConfettiWidget(
            confettiController: confettiCtl,
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
          ),
            ],
          ),
        ),
      ),
    );
  }
}

