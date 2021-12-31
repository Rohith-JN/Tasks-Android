// ignore_for_file: file_names, empty_statements

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/Screens/dialogBox.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String now = DateFormat("MM/dd/yyyy").format(DateTime.now());
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        centerTitle: false,
        title: Text("Tasks", style: Theme.of(context).textTheme.headline1),
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
                  accountName: Text('Tasks',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Theme.of(context).textTheme.headline1!.color,
                      )),
                  currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image(
                        image: AssetImage("assets/app_icon.png"),
                      )),
                  accountEmail: null,
                ),
                ListTile(
                  title: Text("Check all",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Theme.of(context).textTheme.headline1!.color)),
                  enabled: true,
                  leading: const Icon(Icons.check_box),
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
                  leading: const Icon(Icons.check_box_outline_blank),
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
                        : 'Change theme:  dark',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: const Icon(Icons.color_lens_sharp),
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
                  leading: const Icon(Icons.delete),
                  onTap: () {
                    todoController.todos.clear();
                  },
                ),
                ListTile(
                  title: Text(
                    "Cancel all notifications",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: const Icon(Icons.notifications_off),
                  onTap: () {
                    NotificationService()
                        .flutterLocalNotificationsPlugin
                        .cancelAll();
                  },
                ),
                ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context).textTheme.headline1!.color),
                  ),
                  leading: const Icon(Icons.info),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                              key: UniqueKey(),
                              title: "Tasks",
                              descriptions: "A simple Reminders/Todo app",
                              img: const Image(
                                  image: AssetImage("assets/app_icon.png")));
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
      body: Obx(() => Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: (todoController.todos.isEmpty)
                ? const Center(
                    child: Text(
                    "No tasks, Add new tasks",
                    style: TextStyle(color: Colors.black),
                  ))
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(TodoScreen(index: index));
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) {
                                HapticFeedback.heavyImpact();
                                todoController.todos.removeAt(index);
                                NotificationService()
                                    .flutterLocalNotificationsPlugin
                                    .cancel(todoController.todos[index].id);
                                log('dismissed at ${todoController.todos[index].id}');
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.5, right: 6.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          offset: const Offset(2.5, 2.5),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                        ), //B
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            todoController.todos[index].title,
                                            style: GoogleFonts.notoSans(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize: 23.0,
                                                decoration: (todoController
                                                        .todos[index].done)
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                          ),
                                          Transform.scale(
                                            scale: 1.3,
                                            child: Checkbox(
                                                shape: const CircleBorder(),
                                                checkColor: Colors.black,
                                                activeColor:
                                                    const Color(0xFFEAEAEA),
                                                value: todoController
                                                    .todos[index].done,
                                                side: Theme.of(context)
                                                    .checkboxTheme
                                                    .side,
                                                onChanged: (value) {
                                                  var changed = todoController
                                                      .todos[index];
                                                  changed.done = value!;
                                                  todoController.todos[index] =
                                                      changed;
                                                  if (changed.done == true) {
                                                    playLocalAsset();
                                                  }
                                                }),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      const Divider(
                                        color: Color(0xFF707070),
                                        thickness: 1.0,
                                      ),
                                      Visibility(
                                        child: Text(
                                            todoController.todos[index].details,
                                            style: GoogleFonts.notoSans(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 20.0,
                                              decoration: (todoController
                                                      .todos[index].done)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            todoController.todos[index].date ==
                                                        '' &&
                                                    todoController.todos[index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                        child: const Divider(
                                          color: Color(0xFF707070),
                                          thickness: 1.0,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            todoController.todos[index].date ==
                                                        '' &&
                                                    todoController.todos[index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                        child: Obx(() => Text(
                                            (todoController.todos[index].date !=
                                                    now)
                                                ? '${todoController.todos[index].date!}, ${todoController.todos[index].time}'
                                                : 'Today, ${todoController.todos[index].time}',
                                            style: GoogleFonts.notoSans(
                                              color: (run(
                                                              todoController
                                                                  .todos[index]
                                                                  .date,
                                                              todoController
                                                                  .todos[index]
                                                                  .time)
                                                          .compareTo(
                                                              tz.TZDateTime.now(
                                                                  tz.local)) >
                                                      0)
                                                  ? Theme.of(context).hintColor
                                                  : Colors.redAccent,
                                              fontSize: 20.0,
                                              decoration: (todoController
                                                      .todos[index].done)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ))),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (_, __) => const SizedBox(
                          height: 25.0,
                        ),
                    itemCount: todoController.todos.length),
          )),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(() => const TodoScreen());
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

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = AudioCache();
    return await cache.play("audio.mp3");
  }

  run(date, time) {
    String value = '${date} ${time}';
    String currentFormat = "MM/dd/yyyy hh:mm a";
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        bool isUtc = false;
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    String parsed = dateTime!.toString();
    return tz.TZDateTime.parse(tz.local, parsed);
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
