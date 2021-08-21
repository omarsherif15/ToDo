import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Shared/Components/Components.dart';
import 'package:todo_app/Shared/Components/Constants.dart';
import 'package:todo_app/Shared/Components/Constants.dart';
import 'package:todo_app/Shared/Components/Cubit/cubit.dart';
import 'package:todo_app/Shared/Components/Cubit/states.dart';

class ArchivedTasks extends StatefulWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  _ArchivedTasksState createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,ToDoStates>(
      listener: (context,state){},
      builder: (context,state) => ListView.separated(
        itemBuilder: (context,index) => defaultTaskItem(archivedTasks![index],context),
        separatorBuilder: (context,builder) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[400],
          ),
        ),
        itemCount:archivedTasks!.length,
      ),
    );
  }
}
