// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduledTodos extends StatefulWidget {
  const ScheduledTodos({ Key? key }) : super(key: key);

  @override
  _ScheduledTodosState createState() => _ScheduledTodosState();
}

class _ScheduledTodosState extends State<ScheduledTodos> {
  TodoController todoController = Get.put(TodoController());

  @override
  void initState() {
    todoController.getScheduledTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      String now = DateFormat("MM/dd/yyyy").format(DateTime.now());

    return  Scaffold(
      appBar: AppBar(
        leadingWidth: 30.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 30.0,), onPressed: () {
            Navigator.pop(context);
          },),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.3),
          child: Text("Scheduled", style: Theme.of(context).textTheme.headline1),
        ),
      ),
      body: (todoController.scheduledTodos.isEmpty)
                ? Center(
                    child: Text("No scheduled tasks",
                        style: GoogleFonts.notoSans(
                            fontSize: 20.0,
                            color:
                                Theme.of(context).textTheme.headline1!.color)))
                : Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: () {},
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
                                          todoController.scheduledTodos[index].title,
                                          style: GoogleFonts.notoSans(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 23.0,
                                              decoration: (todoController
                                                      .scheduledTodos[index].done)
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
                                                  .scheduledTodos[index].done,
                                              side: Theme.of(context)
                                                  .checkboxTheme
                                                  .side,
                                              onChanged: (value) {}),
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
                                          todoController.scheduledTodos[index].details,
                                          style: GoogleFonts.notoSans(
                                            color:
                                                Theme.of(context).hintColor,
                                            fontSize: 20.0,
                                            decoration: (todoController
                                                    .scheduledTodos[index].done)
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          )),
                                    ),
                                    Visibility(
                                      visible: todoController.scheduledTodos[index].date == '' &&
                                               todoController.scheduledTodos[index].time == ''
                                              ? false
                                              : true,
                                      child: const Divider(
                                        color: Color(0xFF707070),
                                        thickness: 1.0,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                              visible: todoController.scheduledTodos[index].date == '' && 
                                              todoController.scheduledTodos[index].time == '' ? false : true,
                                              child: Obx(() => Text(
                                                  (todoController.scheduledTodos[index]
                                                              .date !=
                                                          now)
                                                      ? '${todoController.scheduledTodos[index].date!}, ${todoController.scheduledTodos[index].time}'
                                                      : 'Today, ${todoController.scheduledTodos[index].time}',
                                                  style: GoogleFonts.notoSans(
                                                    color: (run(todoController.scheduledTodos[index].date,
                                                                todoController.scheduledTodos[index].time)
                                                                .compareTo(tz.TZDateTime.now(tz.local)) >0)
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : Colors.redAccent,
                                                    fontSize: 20.0,
                                                    decoration: (todoController
                                                            .scheduledTodos[index].done)
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                  ))),
                                            ),
                                            Visibility(
                                              visible: todoController.scheduledTodos[index].date == '' && 
                                              todoController.scheduledTodos[index].time == '' ? false : true,
                                              child: Switch(activeColor: Theme.of(context).textTheme.headline1!.color,onChanged: (value) {}, value: todoController.scheduledTodos[index].dateAndTimeEnabled,
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
                    itemCount: todoController.scheduledTodos.length,
          ),
    ));
  }
  showNotification() {
    TodoController todoController = Get.put(TodoController());
    for (var i = 0; i < todoController.scheduledTodos.length; i++) {
      NotificationService().showNotification(
          todoController.scheduledTodos[i].id,
          'Task done',
          todoController.scheduledTodos[i].details,
          run(todoController.scheduledTodos[i].date, todoController.scheduledTodos[i].time));
    }
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