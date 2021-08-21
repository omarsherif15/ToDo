
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Shared/Components/Cubit/cubit.dart';


Widget defaultFormField({
  required TextEditingController ?controller,
  required TextInputType ?type,
  required label,
  required IconData ?prefix,
  bool isPassword = false,
  onSubmit,
  onChange,
  onTap,
  validate,
  IconData ?suffix,
  suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          hintText: label,
          prefixIcon:Icon (prefix),
          suffixIcon: IconButton(
            onPressed: suffixPressed,
            icon:Icon(suffix),
          ),
          border: OutlineInputBorder()
      ),
      validator:validate

    );


Widget defaultTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(

    padding: const EdgeInsets.all(15.0),

    child: Row(

      children:

      [

        CircleAvatar(

          radius: 35,

          child: Text('${model['time']}',

          maxLines: 2,

          textAlign: TextAlign.center,

          style: TextStyle(

              color: Colors.white,

            fontSize: 19,

            fontWeight: FontWeight.bold

          ),

          ),

          backgroundColor: Colors.green,

        ),

        SizedBox(width: 10,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment:CrossAxisAlignment.start,

            children: [

              Text('${model['title']}',style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold

              ),),

              SizedBox(height: 5,),

              Text('${model['date']}', style: TextStyle(color: Colors.grey[500]),),



            ],

          ),

        ),

        SizedBox(width: 20,),

        IconButton(

            onPressed: ()

            {

              if(AppCubit.get(context).isDone) {

                AppCubit.get(context)

                    .updateDatabase(status: 'done', id: model['id']);

                AppCubit.get(context).changeDoneButton(isDone: false);

              }

              else {

                AppCubit.get(context)

                    .updateDatabase(status: 'New', id: model['id']);

                AppCubit.get(context).changeDoneButton(isDone: true);

              }

            },

          icon: Icon(Icons.done),

        ),

        IconButton(

          onPressed: () {

            if(AppCubit.get(context).isArchived) {
                  AppCubit.get(context)
                      .updateDatabase(status: 'archived', id: model['id']);
                  AppCubit.get(context).changeArchiveButton(isArchived: false,archiveIcon: Icons.unarchive_outlined);
                }

            else {
                  AppCubit.get(context)
                      .updateDatabase(status: 'New', id: model['id']);
                  AppCubit.get(context).changeArchiveButton(isArchived: false, archiveIcon: Icons.archive_outlined);
            }
              },

          icon:Icon (AppCubit.get(context).archiveIcon),


        )



      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteFromDatabase(id: model['id']);
  },
);

