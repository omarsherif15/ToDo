import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Shared/Components/Cubit/states.dart';
import 'package:todo_app/modules/ArchivedTasks.dart';
import 'package:todo_app/modules/DoneTasks.dart';
import 'package:todo_app/modules/NewTasks.dart';
import 'package:todo_app/Shared/Components/Constants.dart';



class AppCubit extends Cubit<ToDoStates>
{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks()
  ];
  List<String> title =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index)
  {
    currentIndex = index;
    emit(ButtonChangeState());
  }
  late Database dataBase;
  void createDatabase() {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) async
        {
          print('Database Created');
          database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
          ).then((value)
          {
            print('Table Created');
          }
          ).catchError((error)
          {
            print('Error when creating table ${error.toString()}');
          });
        },
        onOpen: (dataBase)
        {
          print('Database Opened');
          getDataFromDatabase(dataBase);
        }
    ).then((value) 
    {
      dataBase = value;
      emit(CreateDatabaseState());
    }
    );
  }
  insertToDatabase({required title, required date, required time,}) async {
    dataBase.transaction((txn)
    {
        return txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES ("$title","$date","$time","New")')
          .then((value){
        print('$value Inserted Successfully');
        emit(InsertToDatabaseState());
        getDataFromDatabase(dataBase);})
            .catchError((error){
        print('Error while Inserting Data ${error.toString()}');
      });
    });
  }
  void getDataFromDatabase(dataBase) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
     dataBase.rawQuery('SELECT * FROM tasks').then((List<Map> value)
     {
       value.forEach((element)
       {
         if(element['status']=='New') newTasks!.add(element);
         else if(element['status']=='done') doneTasks!.add(element);
         else archivedTasks!.add(element);
       });
       emit(GetFromDatabaseState());
     });
  }

  updateDatabase({required status, required id,}) {
    dataBase.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',['$status',id])
    .then((value)
      {
        emit(UpdateDatabaseState());
        getDataFromDatabase(dataBase);
        emit(GetFromDatabaseState());
    });
  }

  deleteFromDatabase({required id,}) {
    dataBase.rawUpdate('DELETE FROM tasks WHERE id = ?',[id])
        .then((value)
    {
      emit(DeleteFromDatabaseState());
      getDataFromDatabase(dataBase);
      emit(GetFromDatabaseState());
    });
  }

  bool isBottomSheetShown = true;
  IconData fabIcon = Icons.edit;
  bool isArchived= true;
  bool isDone= true;
  IconData archiveIcon =Icons.archive_outlined;


  void changeFabIcon({required bool isShown, required IconData icon,}) {
    isBottomSheetShown = isShown ;
    fabIcon = icon;
    emit(ChangeFabIconState());
  }
  void changeArchiveButton({required bool isArchived, required IconData archiveIcon}) {
    this.isArchived = isArchived ;
    this.archiveIcon = archiveIcon;
    emit(ChangeArchiveIconState());
  }
  void changeDoneButton({required bool isDone,}) {
    this.isDone = isDone ;
    emit(ChangeDoneIconState());
  }
}
