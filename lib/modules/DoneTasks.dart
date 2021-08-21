import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Shared/Components/Components.dart';
import 'package:todo_app/Shared/Components/Constants.dart';
import 'package:todo_app/Shared/Components/Cubit/cubit.dart';
import 'package:todo_app/Shared/Components/Cubit/states.dart';

class DoneTasks extends StatefulWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  _DoneTasksState createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,ToDoStates>(
      listener: (context,state){},
      builder: (context,state) => ListView.separated(
        itemBuilder: (context,index) => defaultTaskItem(doneTasks![index],context),
        separatorBuilder: (context,builder) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[400],
          ),
        ),
        itemCount:doneTasks!.length,
      ),
    );
  }
}

