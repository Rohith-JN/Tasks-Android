// ignore_for_file: file_names, empty_statements

import 'package:Tasks/controllers/Controller.dart';
import 'package:Tasks/services/functions.dart';
import 'package:Tasks/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Tasks/View/TodoScreen.dart';
import 'package:flutter/services.dart';
import 'package:Tasks/services/notification_service.dart';
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
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            height: (arrayController
                                    .arrays[widget.index].todos!.isEmpty)
                                ? 80
                                : 255,
                            child: ListView(children: [
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
                                              arrayController
                                                  .arrays[widget.index].todos!
                                                  .clear();
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
                                            child: Checkbox(
                                                shape: const CircleBorder(),
                                                checkColor: Colors.black,
                                                activeColor:
                                                    const Color(0xFFEAEAEA),
                                                value: arrayController
                                                    .arrays[widget.index]
                                                    .todos![index]
                                                    .done,
                                                side: Theme.of(context)
                                                    .checkboxTheme
                                                    .side,
                                                onChanged: (value) {
                                                  var changed = arrayController
                                                      .arrays[widget.index]
                                                      .todos![index];
                                                  changed.done = value!;
                                                  arrayController
                                                      .arrays[widget.index]
                                                      .todos![index] = changed;
                                                  if (changed.done == true) {
                                                    playLocalAsset();
                                                  }
                                                }),
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
                                              activeColor: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color,
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
