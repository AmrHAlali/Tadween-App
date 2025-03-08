
import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30,),
          const Divider(),
          Text('Hiii'),
          Text('Alohaaaa', style: TextStyle(color: Colors.amber),),
        ],
      ),
    );
  }
}