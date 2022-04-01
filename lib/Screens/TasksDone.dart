// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Tasks/controllers/TodoController.dart';
import 'package:timezone/timezone.dart' as tz;

class TasksDone extends StatefulWidget {
  const TasksDone({ Key? key }) : super(key: key);

  @override
  _TasksDoneState createState() => _TasksDoneState();
}

class _TasksDoneState extends State<TasksDone> {
  TodoController todoController = Get.put(TodoController());

  @override
  void initState() {
    todoController.getDoneTodos();
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
          child: Text("Completed", style: Theme.of(context).textTheme.headline1),
        ),
      ),
      body: (todoController.doneTodos.isEmpty)
                ? Center(
                    child: Text("No completed tasks",
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
                                          todoController.doneTodos[index].title,
                                          style: GoogleFonts.notoSans(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontSize: 23.0,
                                              decoration: (todoController
                                                      .doneTodos[index].done)
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
                                                  .doneTodos[index].done,
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
                                          todoController.doneTodos[index].details,
                                          style: GoogleFonts.notoSans(
                                            color:
                                                Theme.of(context).hintColor,
                                            fontSize: 20.0,
                                            decoration: (todoController
                                                    .doneTodos[index].done)
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          )),
                                    ),
                                    Visibility(
                                      visible: todoController.doneTodos[index].date == '' &&
                                               todoController.doneTodos[index].time == ''
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
                                              visible: todoController.doneTodos[index].date == '' && 
                                              todoController.doneTodos[index].time == '' ? false : true,
                                              child: Obx(() => Text(
                                                  (todoController.doneTodos[index]
                                                              .date !=
                                                          now)
                                                      ? '${todoController.doneTodos[index].date!}, ${todoController.doneTodos[index].time}'
                                                      : 'Today, ${todoController.doneTodos[index].time}',
                                                  style: GoogleFonts.notoSans(
                                                    color: (run(todoController.doneTodos[index].date,
                                                                todoController.doneTodos[index].time)
                                                                .compareTo(tz.TZDateTime.now(tz.local)) >0)
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : Colors.redAccent,
                                                    fontSize: 20.0,
                                                    decoration: (todoController
                                                            .doneTodos[index].done)
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                  ))),
                                            ),
                                            Visibility(
                                              visible: todoController.doneTodos[index].date == '' && 
                                              todoController.doneTodos[index].time == '' ? false : true,
                                              child: Switch(activeColor: Theme.of(context).textTheme.headline1!.color,onChanged: (value) {}, value: todoController.doneTodos[index].dateAndTimeEnabled,
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
                    itemCount: todoController.doneTodos.length,
          ),
    ));
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