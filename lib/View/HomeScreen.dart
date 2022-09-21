// ignore_for_file: file_names, empty_statements

import 'package:Tasks/services/functions.dart';
import 'package:Tasks/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Tasks/View/TodoScreen.dart';
import 'package:Tasks/controllers/TodoController.dart';
import 'package:flutter/services.dart';
import 'package:Tasks/services/notification_service.dart';
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
          centerTitle: false,
          title: Text("Tasks", style: titleStyle),
          actions: [
            Obx(() => (todoController.todos.isEmpty)
                ? Container()
                : IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            height: (todoController.todos.isEmpty) ? 80 : 255,
                            child: ListView(children: [
                              ListTile(
                                title:
                                    Text("Check all", style: optionsTextStyle),
                                enabled: true,
                                leading: const Icon(Icons.check_box),
                                onTap: () {
                                  setState(() {
                                    checkAll();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                enabled: true,
                                title: Text("Uncheck all",
                                    style: optionsTextStyle),
                                leading:
                                    const Icon(Icons.check_box_outline_blank),
                                onTap: () {
                                  setState(() {
                                    unCheckAll();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text(
                                  "Delete all",
                                  style: optionsTextStyle,
                                ),
                                leading: const Icon(Icons.delete),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Delete all tasks'),
                                      content: const Text(
                                          'Are you sure you want to delete all tasks?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              todoController.todos.clear();
                                              NotificationService()
                                                  .flutterLocalNotificationsPlugin
                                                  .cancelAll();
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK')),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                title: Text(
                                  "Cancel all notifications",
                                  style: optionsTextStyle,
                                ),
                                leading: const Icon(Icons.notifications_off),
                                onTap: () {
                                  NotificationService()
                                      .flutterLocalNotificationsPlugin
                                      .cancelAll();
                                  setState(() {
                                    turnOffSwitch();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ]),
                          );
                        },
                      );
                    },
                    icon: menuIcon))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Obx(() => Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: (todoController.todos.isEmpty)
                  ? Center(child: Text("Add new tasks", style: alertTextStyle))
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Get.to(() => TodoScreen(index: index));
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) {
                                HapticFeedback.heavyImpact();
                                NotificationService()
                                    .flutterLocalNotificationsPlugin
                                    .cancel(todoController.todos[index].id);
                                todoController.todos.removeAt(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.5, right: 6.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
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
                                              style: todoTitleStyle(
                                                  todoController
                                                      .todos[index].done)),
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
                                      dividerStyle,
                                      Text(todoController.todos[index].details,
                                          style: todoDetailsStyle(todoController
                                              .todos[index].done)),
                                      Visibility(
                                          visible: todoController
                                                          .todos[index].date ==
                                                      '' &&
                                                  todoController
                                                          .todos[index].time ==
                                                      ''
                                              ? false
                                              : true,
                                          child: dividerStyle),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: todoController.todos[index]
                                                            .date ==
                                                        '' &&
                                                    todoController.todos[index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                            child: Obx(() => Text(
                                                (todoController.todos[index]
                                                            .date !=
                                                        now)
                                                    ? '${todoController.todos[index].date!}, ${todoController.todos[index].time}'
                                                    : 'Today, ${todoController.todos[index].time}',
                                                style: todoTimeStyle(
                                                    parse(
                                                                todoController
                                                                    .todos[
                                                                        index]
                                                                    .date,
                                                                todoController
                                                                    .todos[
                                                                        index]
                                                                    .time)
                                                            .compareTo(
                                                                tz.TZDateTime.now(tz.local)) >
                                                        0,
                                                    todoController.todos[index].done))),
                                          ),
                                          Visibility(
                                            visible: todoController.todos[index]
                                                            .date ==
                                                        '' &&
                                                    todoController.todos[index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                            child: Switch(
                                              activeColor: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color,
                                              onChanged: (value) {
                                                var changed =
                                                    todoController.todos[index];
                                                changed.dateAndTimeEnabled =
                                                    value;
                                                todoController.todos[index] =
                                                    changed;
                                                if (todoController.todos[index]
                                                        .dateAndTimeEnabled ==
                                                    false) {
                                                  NotificationService()
                                                      .flutterLocalNotificationsPlugin
                                                      .cancel(todoController
                                                          .todos[index].id);
                                                } else {
                                                  showNotification();
                                                }
                                              },
                                              value: todoController.todos[index]
                                                  .dateAndTimeEnabled,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
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
                  color: const Color(0xFF414141),
                  borderRadius: BorderRadius.circular(14.0)),
              width: 140.0,
              height: 55.0,
              child: Center(
                child: Text('Add task', style: buttonTextStyle),
              ),
            )));
  }
}
