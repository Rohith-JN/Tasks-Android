// ignore_for_file: file_names, empty_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/routes.dart';
import 'package:flutter/services.dart';
import 'package:tasks/services/notification.service.dart';
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
              child: (arrayController.arrays[widget.index!].todos!.isEmpty)
                  ? const Center(
                      child: Text("Add new tasks",
                          style:
                              TextStyle(color: Colors.white, fontSize: 23.0)))
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
                                      // Todo cancel notification at arrayController.arrays[widget.index!].todos![index].id!
                                      Database().deleteAllTodo(
                                          uid,
                                          arrayController.arrays[widget.index!]
                                              .todos![index].id!);
                                      arrayController
                                          .arrays[widget.index!].todos!
                                          .removeAt(index);
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(uid)
                                            .collection("arrays")
                                            .doc(arrayController
                                                .arrays[widget.index!].id)
                                            .set({
                                          "title": arrayController
                                              .arrays[widget.index!].title,
                                          "dateCreated": arrayController
                                              .arrays[widget.index!]
                                              .dateCreated,
                                          "todos": arrayController
                                              .arrays[widget.index!].todos!
                                              .map((todo) => todo.toJson())
                                              .toList()
                                        });
                                      } catch (e) {}
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
        floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(Routes.route(
                  TodoScreen(arrayIndex: widget.index),
                  const Offset(0.0, 1.0)));
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
