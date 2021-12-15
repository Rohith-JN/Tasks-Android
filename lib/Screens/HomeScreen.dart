// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title:
              Text("Reminders", style: Theme.of(context).textTheme.headline1),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Obx(() => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Get.to(TodoScreen(index: index));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF414141),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF414141),
                              offset: Offset(2.5, 2.5),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ), //B
                          ],
                          borderRadius: BorderRadius.circular(14.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 15.0),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  todoController.todos[index].title,
                                  style: GoogleFonts.notoSans(
                                      color: Color(0xFFA8A8A8), fontSize: 20.0),
                                ),
                              ],
                            ),
                            Divider(
                              color: Color(0xFF707070),
                            ),
                            Text(
                              todoController.todos[index].details,
                              style: GoogleFonts.notoSans(
                                  color: Color(0xFFA8A8A8), fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (_, __) => SizedBox(
                    height: 25.0,
                  ),
              itemCount: todoController.todos.length)),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Get.to(TodoScreen());
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF414141),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF414141),
                    offset: Offset(2.5, 2.5),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ), //B
                ],
                borderRadius: BorderRadius.circular(14.0)),
            width: 140.0,
            height: 55.0,
            child: Center(
              child: Text(
                "Add Task",
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline2!.color,
                    fontSize: 28.0),
              ),
            ),
          ),
        ));
  }
}
