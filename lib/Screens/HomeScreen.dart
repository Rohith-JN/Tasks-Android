// ignore_for_file: file_names, empty_statements

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/Screens/themes.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:flutter/services.dart';
import 'package:rolling_switch/rolling_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool status = false;
    final TodoController todoController = Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Reminders", style: Theme.of(context).textTheme.headline1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: RollingSwitch.icon(
              width: 110.0,
              height: 50.0,
              onChanged: (bool state) {
                if (Get.isDarkMode) {
                  Get.changeThemeMode(ThemeMode.light);
                } else {
                  Get.changeThemeMode(ThemeMode.dark);
                }
              },
              rollingInfoRight: const RollingIconInfo(
                icon: Icons.light_mode,
                backgroundColor: Colors.grey,
                text: Text('light', style: TextStyle(fontSize: 17.0)),
              ),
              rollingInfoLeft: const RollingIconInfo(
                icon: Icons.dark_mode,
                backgroundColor: Colors.grey,
                text: Text('dark', style: TextStyle(fontSize: 17.0)),
              ),
            ),
          ),
        ],
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
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) {
                      HapticFeedback.heavyImpact();
                      todoController.todos.removeAt(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todoController.todos[index].title,
                                  style: GoogleFonts.notoSans(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 23.0,
                                      decoration:
                                          (todoController.todos[index].done!)
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                ),
                                Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                      shape: const CircleBorder(),
                                      checkColor: Colors.black,
                                      activeColor: Color(0xFFEAEAEA),
                                      value: todoController.todos[index].done,
                                      side:
                                          Theme.of(context).checkboxTheme.side,
                                      onChanged: (value) {
                                        var changed =
                                            todoController.todos[index];
                                        changed.done = value;
                                        todoController.todos[index] = changed;
                                      }),
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            const Divider(
                              color: Color(0xFF707070),
                              thickness: 1.0,
                            ),
                            Text(
                              todoController.todos[index].details,
                              style: GoogleFonts.notoSans(
                                color: Theme.of(context).hintColor,
                                fontSize: 20.0,
                                decoration: (todoController.todos[index].done!)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            separatorBuilder: (_, __) => const SizedBox(
                  height: 25.0,
                ),
            itemCount: todoController.todos.length)),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(() => TodoScreen());
        },
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
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
                  fontSize: 23.0),
            ),
          ),
        ),
      ),
    );
  }
}
