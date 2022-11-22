// ignore_for_file: file_names, empty_statements

import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/services/functions.services.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/routes.dart';
import 'package:flutter/services.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/TodoScreen.dart';

class HomeScreen extends StatefulWidget {
  final int? index;
  const HomeScreen({Key? key, this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ArrayController arrayController = Get.put(ArrayController());
  final String uid = Get.find<AuthController>().user!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(arrayController.arrays[widget.index!].title!,
              style: appBarTextStyle),
        ),
        extendBodyBehindAppBar: true,
        body: Obx(() => Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: (arrayController.arrays[widget.index!].todos!.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Icon(Icons.task,
                              color: Colors.white, size: 120.0),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Center(
                            child: Text('Add new tasks', style: infoTextStyle)),
                      ],
                    )
                  : GetX<ArrayController>(
                      init: Get.put<ArrayController>(ArrayController()),
                      builder: (ArrayController arrayController) {
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(Routes.route(
                                        TodoScreen(
                                          arrayIndex: widget.index,
                                          todoIndex: index,
                                        ),
                                        const Offset(0.0, 1.0)));
                                  },
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (_) async {
                                      HapticFeedback.heavyImpact();
                                      NotificationService()
                                          .flutterLocalNotificationsPlugin
                                          .cancel(arrayController
                                              .arrays[widget.index!]
                                              .todos![index]
                                              .id!);
                                      Functions.deleteTodo(arrayController, uid,
                                          widget.index, index);
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                arrayController
                                                        .arrays[widget.index!]
                                                        .todos![index]
                                                        .title ??
                                                    '',
                                                style: todoTitleStyle(
                                                    arrayController
                                                        .arrays[widget.index!]
                                                        .todos![index]
                                                        .done)),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (_, __) => const SizedBox(
                                  height: 15.0,
                                ),
                            itemCount: arrayController
                                .arrays[widget.index!].todos!.length);
                      }),
            )),
        floatingActionButton: secondaryButton(() {
          Navigator.of(context).push(Routes.route(
              TodoScreen(arrayIndex: widget.index), const Offset(0.0, 1.0)));
        }, 'Add task', context));
  }
}
