// ignore_for_file: file_names, empty_statements

import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/controllers/todoController.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/view/TodoScreen.dart';
import 'package:flutter/services.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController todoController = Get.put(TodoController());
  final AuthController authController = Get.find();
  final String uid = Get.find<AuthController>().user!.uid;

  String now = DateFormat("MM/dd/yyyy").format(DateTime.now());
  TimeOfDay currentTime = TimeOfDay.now();

  tz.TZDateTime parse(date, time) {
    String value = '$date $time';
    String currentFormat = "MM/dd/yyyy hh:mm a";
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        bool isUtc = false;
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {}
    }
    String parsed = dateTime!.toString();
    return tz.TZDateTime.parse(tz.local, parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Tasks',
              style: GoogleFonts.notoSans(
                fontSize: 30,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              )),
        ),
        extendBodyBehindAppBar: true,
        body: Obx(() => Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: (todoController.todos.isEmpty)
                  ? const Center(
                      child: Text("Add new tasks",
                          style:
                              TextStyle(color: Colors.white, fontSize: 23.0)))
                  : GetX<TodoController>(
                      init: Get.put<TodoController>(TodoController()),
                      builder: (TodoController todoController) {
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        Routes.routeToTodoScreenIndex(index,
                                            todoController.todos[index].id));
                                  },
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (_) {
                                      HapticFeedback.heavyImpact();
                                      Database().deleteTodo(
                                          uid, todoController.todos[index].id!);
                                      NotificationService()
                                          .flutterLocalNotificationsPlugin
                                          .cancel(todoController
                                              .todos[index].intId!);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6.5, right: 6.5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: tertiaryColor,
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 6.0),
                                            Text(
                                                todoController
                                                        .todos[index].title ??
                                                    '',
                                                style: todoTitleStyle(
                                                    todoController
                                                        .todos[index].done)),
                                            const SizedBox(height: 6.0),
                                            dividerStyle,
                                            const SizedBox(height: 6.0),
                                            Text(
                                                todoController
                                                        .todos[index].details ??
                                                    '',
                                                style: todoDetailsStyle(
                                                    todoController
                                                        .todos[index].done)),
                                            const SizedBox(height: 6.0),
                                            Visibility(
                                                visible: todoController
                                                                .todos[index]
                                                                .date ==
                                                            '' &&
                                                        todoController
                                                                .todos[index]
                                                                .time ==
                                                            ''
                                                    ? false
                                                    : true,
                                                child: dividerStyle),
                                            const SizedBox(height: 6.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                  visible: todoController
                                                                  .todos[index]
                                                                  .date ==
                                                              '' &&
                                                          todoController
                                                                  .todos[index]
                                                                  .time ==
                                                              ''
                                                      ? false
                                                      : true,
                                                  child: Obx(() => Text(
                                                      (todoController
                                                                  .todos[index]
                                                                  .date !=
                                                              now)
                                                          ? '${todoController.todos[index].date!}, ${todoController.todos[index].time}'
                                                          : 'Today, ${todoController.todos[index].time}',
                                                      style: todoTimeStyle(
                                                          todoController
                                                              .todos[index]
                                                              .done))),
                                                ),
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
                            itemCount: todoController.todos.length);
                      }),
            )),
        floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(Routes.routeToTodoScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                  color: tertiaryColor,
                  borderRadius: BorderRadius.circular(14.0)),
              width: 140.0,
              height: 55.0,
              child: Center(
                child: Text('Add task',
                    style: TextStyle(color: primaryColor, fontSize: 23.0)),
              ),
            )));
  }
}
