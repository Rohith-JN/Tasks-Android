// ignore_for_file: file_names, empty_statements

import 'package:tasks/controllers/Controller.dart';
import 'package:tasks/services/Functions.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/view/TodoScreen.dart';
import 'package:flutter/services.dart';
import 'package:tasks/services/Notification.service.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  final int index;
  const HomeScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String now = DateFormat("MM/dd/yyyy").format(DateTime.now());
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final ArrayController arrayController = Get.put(ArrayController());
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(arrayController.arrays[widget.index].title,
              style: titleStyle),
          actions: [
            Obx(() => (arrayController.arrays[widget.index].todos == null)
                ? Container()
                : IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        backgroundColor: Color.fromARGB(255, 37, 37, 37),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            height: 80,
                            child: ListView(children: [
                              ListTile(
                                title: Text(
                                  "Delete all",
                                  style: optionsTextStyle,
                                ),
                                leading: const Icon(
                                  Icons.delete,
                                  color: primaryColor,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 37, 37, 37),
                                      title: const Text(
                                        'Delete all tasks',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                          'Are you sure you want to delete all tasks?',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 187, 187, 187))),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              arrayController
                                                  .arrays[widget.index].todos!
                                                  .clear();
                                              NotificationService()
                                                  .flutterLocalNotificationsPlugin
                                                  .cancelAll();
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: primaryColor),
                                            )),
                                      ],
                                    ),
                                  );
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
              child: (arrayController.arrays[widget.index].todos == null)
                  ? Center(child: Text("Add new tasks", style: alertTextStyle))
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Get.to(() => TodoScreen(
                                    todoIndex: index,
                                    arrayIndex: widget.index,
                                  ));
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) {
                                HapticFeedback.heavyImpact();
                                NotificationService()
                                    .flutterLocalNotificationsPlugin
                                    .cancel(arrayController
                                        .arrays[widget.index].todos![index].id);
                                arrayController.arrays[widget.index].todos!
                                    .removeAt(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.5, right: 6.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 37, 37, 37),
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
                                              arrayController
                                                  .arrays[widget.index]
                                                  .todos![index]
                                                  .title,
                                              style: todoTitleStyle(
                                                  arrayController
                                                      .arrays[widget.index]
                                                      .todos![index]
                                                      .done)),
                                          Transform.scale(
                                            scale: 1.3,
                                            child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Color.fromARGB(
                                                          255, 187, 187, 187)),
                                              child: Checkbox(
                                                  shape: CircleBorder(),
                                                  checkColor: Colors.white,
                                                  activeColor: primaryColor,
                                                  value: arrayController
                                                      .arrays[widget.index]
                                                      .todos![index]
                                                      .done,
                                                  side: Theme.of(context)
                                                      .checkboxTheme
                                                      .side,
                                                  onChanged: (value) {
                                                    var changed =
                                                        arrayController
                                                            .arrays[
                                                                widget.index]
                                                            .todos![index];
                                                    changed.done = value!;
                                                    arrayController
                                                        .arrays[widget.index]
                                                        .todos![index] = changed;
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      dividerStyle,
                                      Text(
                                          arrayController.arrays[widget.index]
                                              .todos![index].details,
                                          style: todoDetailsStyle(
                                              arrayController
                                                  .arrays[widget.index]
                                                  .todos![index]
                                                  .done)),
                                      Visibility(
                                          visible: arrayController
                                                          .arrays[widget.index]
                                                          .todos![index]
                                                          .date ==
                                                      '' &&
                                                  arrayController
                                                          .arrays[widget.index]
                                                          .todos![index]
                                                          .time ==
                                                      ''
                                              ? false
                                              : true,
                                          child: dividerStyle),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: arrayController
                                                            .arrays[
                                                                widget.index]
                                                            .todos![index]
                                                            .date ==
                                                        '' &&
                                                    arrayController
                                                            .arrays[
                                                                widget.index]
                                                            .todos![index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                            child: Obx(() => Text(
                                                (arrayController.arrays[widget.index].todos![index].date !=
                                                        now)
                                                    ? '${arrayController.arrays[widget.index].todos![index].date!}, ${arrayController.arrays[widget.index].todos![index].time}'
                                                    : 'Today, ${arrayController.arrays[widget.index].todos![index].time}',
                                                style: todoTimeStyle(
                                                    parse(
                                                                arrayController
                                                                    .arrays[widget
                                                                        .index]
                                                                    .todos![
                                                                        index]
                                                                    .date,
                                                                arrayController
                                                                    .arrays[widget.index]
                                                                    .todos![index]
                                                                    .time)
                                                            .compareTo(tz.TZDateTime.now(tz.local)) >
                                                        0,
                                                    arrayController.arrays[widget.index].todos![index].done))),
                                          ),
                                          Visibility(
                                            visible: arrayController
                                                            .arrays[
                                                                widget.index]
                                                            .todos![index]
                                                            .date ==
                                                        '' &&
                                                    arrayController
                                                            .arrays[
                                                                widget.index]
                                                            .todos![index]
                                                            .time ==
                                                        ''
                                                ? false
                                                : true,
                                            child: Switch(
                                              activeColor: primaryColor,
                                              onChanged: (value) {
                                                var changed = arrayController
                                                    .arrays[widget.index]
                                                    .todos![index];
                                                changed.dateAndTimeEnabled =
                                                    value;
                                                arrayController
                                                    .arrays[widget.index]
                                                    .todos![index] = changed;
                                                if (arrayController
                                                        .arrays[widget.index]
                                                        .todos![index]
                                                        .dateAndTimeEnabled ==
                                                    false) {
                                                  NotificationService()
                                                      .flutterLocalNotificationsPlugin
                                                      .cancel(arrayController
                                                          .arrays[widget.index]
                                                          .todos![index]
                                                          .id);
                                                } else {
                                                  // showNotification();
                                                }
                                              },
                                              value: arrayController
                                                  .arrays[widget.index]
                                                  .todos![index]
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
                      itemCount:
                          arrayController.arrays[widget.index].todos!.length),
            )),
        floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(_routeToTodoScreen(widget.index));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 37, 37, 37),
                  borderRadius: BorderRadius.circular(14.0)),
              width: 140.0,
              height: 55.0,
              child: Center(
                child: Text('Add task', style: buttonTextStyle),
              ),
            )));
  }
}

Route _routeToTodoScreen(arrayIndex) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        TodoScreen(arrayIndex: arrayIndex),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
