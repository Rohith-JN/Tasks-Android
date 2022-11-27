// ignore_for_file: file_names, empty_statements

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/services/functions.services.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/TodoScreen.dart';

class FilteredScreen extends StatefulWidget {
  final String title;
  final String infoText;
  final IconData icon;
  final data;
  const FilteredScreen(
      {Key? key,
      required this.title,
      required this.data,
      required this.infoText,
      required this.icon})
      : super(key: key);

  @override
  State<FilteredScreen> createState() => _FilteredScreenState();
}

class _FilteredScreenState extends State<FilteredScreen> {
  final ArrayController arrayController = Get.put(ArrayController());
  final String uid = Get.find<AuthController>().user!.uid;
  List<String> options = ['Never', 'Daily', 'Weekly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.title, style: appBarTextStyle),
        ),
        extendBodyBehindAppBar: true,
        body: Obx(() => Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: (widget.data.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(widget.icon,
                              color: Colors.white, size: 120.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Center(
                            child: Text(widget.infoText, style: infoTextStyle)),
                      ],
                    )
                  : GetX<ArrayController>(
                      init: Get.put<ArrayController>(ArrayController()),
                      builder: (ArrayController arrayController) {
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    var arrayIndex = 0;
                                    var todoIndex = 0;
                                    for (var array in arrayController.arrays) {
                                      if (array.title ==
                                          widget.data[index].arrayTitle) {
                                        arrayIndex = arrayController.arrays
                                            .indexOf(array);
                                      }
                                    }
                                    for (var todo in arrayController
                                        .arrays[arrayIndex].todos!) {
                                      if (widget.data[index].id == todo.id) {
                                        todoIndex = arrayController
                                            .arrays[arrayIndex].todos!
                                            .indexOf(todo);
                                      }
                                    }
                                    Navigator.of(context).push(Routes.route(
                                        TodoScreen(
                                          arrayIndex: arrayIndex,
                                          todoIndex: todoIndex,
                                        ),
                                        const Offset(0.0, 1.0)));
                                  },
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (_) async {
                                      HapticFeedback.heavyImpact();
                                      var arrayIndex = 0;
                                      var todoIndex = 0;
                                      for (var array
                                          in arrayController.arrays) {
                                        if (array.title ==
                                            widget.data[index].arrayTitle) {
                                          arrayIndex = arrayController.arrays
                                              .indexOf(array);
                                        }
                                      }
                                      for (var todo in arrayController
                                          .arrays[arrayIndex].todos!) {
                                        if (widget.data[index].id == todo.id) {
                                          todoIndex = arrayController
                                              .arrays[arrayIndex].todos!
                                              .indexOf(todo);
                                        }
                                      }
                                      NotificationService()
                                          .flutterLocalNotificationsPlugin
                                          .cancel(arrayController
                                              .arrays[arrayIndex]
                                              .todos![todoIndex]
                                              .id!);
                                      Functions.deleteTodo(arrayController, uid,
                                          arrayIndex, todoIndex);
                                    },
                                    child: Padding(
                                      padding:
                                          (MediaQuery.of(context).size.width <
                                                  768)
                                              ? const EdgeInsets.only(
                                                  left: 6.5, right: 6.5)
                                              : const EdgeInsets.only(
                                                  left: 20.0, right: 20.0),
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
                                            Text(widget.data[index].title!,
                                                style: GoogleFonts.notoSans(
                                                    color: Colors.white,
                                                    fontSize: 25.0)),
                                            (widget.data[index].details != '')
                                                ? const SizedBox(height: 5.0)
                                                : const SizedBox(),
                                            Visibility(
                                              visible:
                                                  widget.data[index].details ==
                                                          ''
                                                      ? false
                                                      : true,
                                              child: Text(
                                                  widget.data[index].details!,
                                                  style: GoogleFonts.notoSans(
                                                    color:
                                                        const Color(0xFFA8A8A8),
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Visibility(
                                                visible:
                                                    widget.data[index].date ==
                                                                '' &&
                                                            widget.data[index]
                                                                    .time ==
                                                                ''
                                                        ? false
                                                        : true,
                                                child: primaryDivider),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      widget.data[index].date ==
                                                                  '' &&
                                                              widget.data[index]
                                                                      .time ==
                                                                  ''
                                                          ? false
                                                          : true,
                                                  child: Obx(
                                                    () => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0),
                                                      child: Text(
                                                          (widget.data[index]
                                                                      .date !=
                                                                  DateFormat(
                                                                          "MM/dd/yyyy")
                                                                      .format(DateTime
                                                                          .now()))
                                                              ? '${widget.data[index].date!}, ${widget.data[index].time}}'
                                                              : 'Today, ${widget.data[index].time}}',
                                                          style:
                                                              todoScreenStyle),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            primaryDivider,
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child: Text(
                                                  'List: ${widget.data[index].arrayTitle}',
                                                  style: listInfoTextStyle),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (_, __) => const SizedBox(
                                  height: 15.0,
                                ),
                            itemCount: widget.data.length);
                      }),
            )));
  }
}
