import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/services/functions.services.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/ArrayScreen.dart';
import 'package:tasks/view/HomeScreen.dart';
import '../controllers/authController.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthController authController = Get.find();
  final ArrayController arrayController = Get.put(ArrayController());
  final String uid = Get.find<AuthController>().user!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Tasks", style: appBarTextStyle),
          actions: [
            IconButton(
                onPressed: () {
                  Functions.showBottomSheet(context, authController);
                },
                icon: primaryIcon(Icons.menu))
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      filteredWidget(context, 'Scheduled', 'No scheduled tasks',
                          arrayController.scheduledTodos),
                      filteredWidget(
                          context,
                          'Today',
                          'No tasks scheduled for today',
                          arrayController.todayTodos),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      filteredWidget(context, 'Completed', 'No completed tasks',
                          arrayController.doneTodos),
                      filteredWidget(context, 'All', 'No tasks yet',
                          arrayController.allTodos)
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Lists", style: appBarTextStyle)),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: GetX<ArrayController>(
                            init: Get.put<ArrayController>(ArrayController()),
                            builder: (ArrayController arrayController) {
                              return (arrayController.arrays.isEmpty)
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.37,
                                      child: Center(
                                          child: Text("Add new lists",
                                              style: buttonTextStyleWhite)),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                            onLongPress: () {
                                              Navigator.of(context).push(
                                                  Routes.route(
                                                      ArrayScreen(
                                                          index: index,
                                                          docId: arrayController
                                                              .arrays[index]
                                                              .id),
                                                      const Offset(0.0, 1.0)));
                                            },
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  Routes.route(
                                                      HomeScreen(index: index),
                                                      const Offset(1.0, 0.0)));
                                            },
                                            child: Dismissible(
                                              key: UniqueKey(),
                                              direction:
                                                  DismissDirection.startToEnd,
                                              onDismissed: (_) {
                                                HapticFeedback.heavyImpact();
                                                Functions.deleteArray(uid,
                                                    arrayController, index);
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                                decoration: BoxDecoration(
                                                    color: tertiaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 25.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20.0),
                                                        child: Text(
                                                          arrayController
                                                                  .arrays[index]
                                                                  .title ??
                                                              '',
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      25.0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${arrayController.arrays[index].todos!.length}',
                                                              style: GoogleFonts
                                                                  .notoSans(
                                                                      color:
                                                                          primaryColor,
                                                                      fontSize:
                                                                          27.0),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                                  primaryColor,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                      itemCount: arrayController.arrays.length);
                            }),
                      ),
                    ],
                  )
                ],
              )),
        ),
        floatingActionButton: secondaryButton(() {
          Navigator.of(context)
              .push(Routes.route(const ArrayScreen(), const Offset(0.0, 1.0)));
        }, 'Add list'));
  }
}
