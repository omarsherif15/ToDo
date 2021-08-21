import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Shared/Components/Cubit/cubit.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Shared/Components/Cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey =GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,ToDoStates>(
        listener: (context,states){
          if(states is InsertToDatabaseState)
            {
              AppCubit.get(context).changeFabIcon(isShown: true, icon: Icons.edit);
              titleController.text = '';
              timeController.text = '';
              dateController.text='';
              Navigator.pop(context);
            }
        },
        builder: (context,states) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text(cubit.title[cubit.currentIndex],),
            ),),
          body:cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              if(cubit.isBottomSheetShown) {
               cubit.changeFabIcon(isShown: false, icon: Icons.add);
                scaffoldKey.currentState?.showBottomSheet((context)
                => Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey[200],
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                        [
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Title',
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder()
                            ),
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return'Title must not be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            readOnly: true,
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              hintText: 'Time',
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onTap:() {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) =>
                              timeController.text = value!.format(context).toString()
                              );},
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return'Time must not be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            readOnly: true,
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              hintText: 'Date',
                              prefixIcon: Icon(Icons.date_range_outlined),
                              border: OutlineInputBorder(),
                            ),
                            onTap:() {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:DateTime.now(),
                                  lastDate: DateTime.parse('2022-01-01')
                              ).then((value) =>
                              dateController.text = DateFormat.yMMMd().format(value!)
                              );},
                            validator: (value)
                            {
                              if(value!.isEmpty)
                              {
                                return'Date must not be empty';
                              }
                              return null;
                            },
                          ),
                        ]
                    ),
                  ),
                )).closed.then((value) => cubit.changeFabIcon(isShown: true, icon: Icons.edit));
              }
              else {
                if (formKey.currentState!.validate())
                {
                  cubit.insertToDatabase(
                      title: titleController.text ,
                      date: dateController.text,
                      time: timeController.text,
                  );
                }
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeIndex(index);
              },
            items:
            [
              BottomNavigationBarItem(
                icon:Icon(Icons.menu),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.check),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.archive_outlined),
                label: 'Archived',
              ),
            ],
          ),

        );
        },
      ),
    );
  }


}



