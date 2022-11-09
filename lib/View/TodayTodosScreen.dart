// ignore_for_file: file_names, empty_statements

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodayTodosScreen extends StatefulWidget {
  const TodayTodosScreen({Key? key}) : super(key: key);

  @override
  State<TodayTodosScreen> createState() => _TodayTodosScreenState();
}

class _TodayTodosScreenState extends State<TodayTodosScreen> {
  final ArrayController arrayController = Get.put(ArrayController());
  String now = DateFormat("MM/dd/yyyy").format(DateTime.now());
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Today',
              style: GoogleFonts.notoSans(
                fontSize: 30,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              )),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: (arrayController.todayTodos.isEmpty)
              ? const Center(
                  child: Text("No tasks scheduled for today",
                      style: TextStyle(color: Colors.white, fontSize: 23.0)))
              : GetX<ArrayController>(
                  init: Get.put<ArrayController>(ArrayController()),
                  builder: (ArrayController arrayController) {
                    return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 6.5, right: 6.5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: tertiaryColor,
                                    borderRadius: BorderRadius.circular(14.0)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      arrayController.todayTodos[index].title!,
                                      style: GoogleFonts.notoSans(
                                        color: const Color(0xFFA8A8A8),
                                        fontSize: 23.0,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const Divider(
                                      color: Color(0xFF707070),
                                      thickness: 1.0,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Visibility(
                                      child: Text(
                                        arrayController
                                            .todayTodos[index].details!,
                                        style: GoogleFonts.notoSans(
                                          color: const Color(0xFFA8A8A8),
                                          fontSize: 23.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Visibility(
                                      visible: arrayController
                                                      .todayTodos[index].date ==
                                                  '' &&
                                              arrayController
                                                      .todayTodos[index].time ==
                                                  ''
                                          ? false
                                          : true,
                                      child: const Divider(
                                        color: Color(0xFF707070),
                                        thickness: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                          visible: arrayController
                                                          .todayTodos[index]
                                                          .date ==
                                                      '' &&
                                                  arrayController
                                                          .todayTodos[index]
                                                          .time ==
                                                      ''
                                              ? false
                                              : true,
                                          child: Obx(
                                            () => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Text(
                                                (arrayController
                                                            .todayTodos[index]
                                                            .date !=
                                                        now)
                                                    ? '${arrayController.allTodos[index].date!}, ${arrayController.allTodos[index].time}'
                                                    : 'Today, ${arrayController.allTodos[index].time}',
                                                style: GoogleFonts.notoSans(
                                                  color:
                                                      const Color(0xFFA8A8A8),
                                                  fontSize: 23.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xFF707070),
                                      thickness: 1.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Text(
                                        'List: ${arrayController.allTodos[index].arrayTitle!}',
                                        style: GoogleFonts.notoSans(
                                          color: primaryColor,
                                          fontSize: 23.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        separatorBuilder: (_, __) => const SizedBox(
                              height: 15.0,
                            ),
                        itemCount: arrayController.todayTodos.length);
                  }),
        ));
  }
}
