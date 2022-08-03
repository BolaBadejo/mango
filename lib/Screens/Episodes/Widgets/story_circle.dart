import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:provider/provider.dart';

class StoryCircle extends StatelessWidget {
  final function;

  const StoryCircle({Key? key, this.function});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<MangoUser>>(context);
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}