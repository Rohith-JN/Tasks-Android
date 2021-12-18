// ignore_for_file: file_names, empty_statements

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/Screens/dialogBox.dart';
import 'package:todo_app/Screens/themes.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:flutter/services.dart';
import 'package:rolling_switch/rolling_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool status = false;
    final TodoController todoController = Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        centerTitle: false,
        title: Text("Reminders", style: Theme.of(context).textTheme.headline1),
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Obx(() => ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: (Get.isDarkMode) ? Colors.black26 : Colors.grey[300],
                  ),
                  accountName: Text('Reminders',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Theme.of(context).textTheme.headline1!.color,
                      )),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage("assets/App_icon.png"),
                      )),
                  accountEmail: null,
                ),
                ListTile(
                  title: Text("Check all",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Theme.of(context).textTheme.headline1!.color)),
                  enabled: true,
                  leading: Icon(Icons.check_box),
                  onTap: () {
                    setState(() {
                      checkAll();
                    });
                  },
                ),
                ListTile(
                  enabled: true,
                  title: Text("Uncheck all",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Theme.of(context).textTheme.headline1!.color)),
                  leading: Icon(Icons.check_box_outline_blank),
                  onTap: () {
                    setState(() {
                      unCheckAll();
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    (Get.isDarkMode)
                        ? 'Change theme:  light'
                        : 'change theme:  dark',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: Icon(Icons.color_lens_sharp),
                  onTap: () {
                    if (Get.isDarkMode) {
                      Get.changeThemeMode(ThemeMode.light);
                    } else {
                      Get.changeThemeMode(ThemeMode.dark);
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    "Delete all",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    todoController.todos.clear();
                  },
                ),
                ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: Icon(Icons.info),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                              key: UniqueKey(),
                              title: "Reminders",
                              descriptions: "A simple Reminders/Todo app",
                              text: 'Check Github',
                              img: Image(
                                  image: AssetImage("assets/App_icon.png")));
                        });
                  },
                ),
                ListTile(
                  title: Text(
                    "No of tasks:  ${todoController.todos.length}",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  onTap: () {},
                ),
              ],
            )),
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

void checkAll() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    todoController.todos[i].done = true;
  }
  GetStorage().write('todos', todoController.todos.toList());
}

void unCheckAll() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    todoController.todos[i].done = false;
  }
  GetStorage().write('todos', todoController.todos.toList());
}
