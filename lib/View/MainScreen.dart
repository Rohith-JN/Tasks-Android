import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/models/FTodo.dart';
import 'package:tasks/services/functions.services.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/ArrayScreen.dart';
import 'package:tasks/view/DeleteScreen.dart';
import 'package:tasks/view/HomeScreen.dart';
import 'package:tasks/view/TodoScreen.dart';
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
          title: Padding(
            padding: (MediaQuery.of(context).size.width < 768)
                ? const EdgeInsets.only(left: 0.0)
                : const EdgeInsets.only(left: 15.0),
            child: Text("Tasks", style: appBarTextStyle),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: primaryIcon(Icons.search)),
            Padding(
              padding: (MediaQuery.of(context).size.width < 768)
                  ? const EdgeInsets.only(right: 0.0)
                  : const EdgeInsets.only(right: 25.0),
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      backgroundColor: tertiaryColor,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.only(top: 15.0),
                          height: 260,
                          child: ListView(children: [
                            const SizedBox(height: 10.0),
                            Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 40.0,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Center(
                                child: Text(
                              authController.user!.email ?? '',
                              style: accountTextStyle,
                            )),
                            const SizedBox(height: 15.0),
                            primaryDivider,
                            ListTile(
                              title: Text(
                                "Sign out",
                                style: optionsTextStyle,
                              ),
                              leading: Icon(
                                Icons.logout,
                                color: primaryColor,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                authController.signOut(context);
                              },
                            ),
                            ListTile(
                              title: Text(
                                "Delete account",
                                style: optionsTextStyle,
                              ),
                              leading: Icon(
                                Icons.delete,
                                color: primaryColor,
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                                await showDialog<String>(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 37, 37, 37),
                                    title: const Text('Delete account',
                                        style: TextStyle(color: Colors.white)),
                                    content: const Text(
                                        'Are you sure you want to delete your account?',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 187, 187, 187))),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: Text('Cancel',
                                            style:
                                                TextStyle(color: primaryColor)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context, 'Ok');
                                          Get.to(const DeleteScreen());
                                        },
                                        child: Text('OK',
                                            style:
                                                TextStyle(color: primaryColor)),
                                      ),
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
                  icon: primaryIcon(Icons.menu)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              width: double.infinity,
              padding: (MediaQuery.of(context).size.width < 768)
                  ? const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0)
                  : const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      filteredWidget(context, 'Scheduled', 'No scheduled tasks',
                          arrayController.scheduledTodos, Icons.schedule),
                      filteredWidget(
                          context,
                          'Today',
                          'No tasks scheduled for today',
                          arrayController.todayTodos,
                          Icons.calendar_today),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      filteredWidget(context, 'Completed', 'No completed tasks',
                          arrayController.doneTodos, Icons.done_rounded),
                      filteredWidget(context, 'All', 'No tasks yet',
                          arrayController.allTodos, Icons.task)
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
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Center(
                                          child: Icon(Icons.list,
                                              color: Colors.white, size: 90.0),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Center(
                                            child: Text('Add new lists',
                                                style: buttonTextStyleWhite)),
                                      ],
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
        }, 'Add list', context));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Color(0xFFA8A8A8), fontSize: 20.0),
            border: InputBorder.none),
        appBarTheme: const AppBarTheme(backgroundColor: tertiaryColor));
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: primaryIcon(Icons.arrow_back));
  @override
  List<Widget> buildActions(BuildContext context) => [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
              onPressed: () {
                if (query.isEmpty) {
                  close(context, null);
                } else {
                  query = '';
                }
              },
              icon: primaryIcon(Icons.close)),
        )
      ];
  @override
  Widget buildResults(BuildContext context) => Container();
  @override
  Widget buildSuggestions(BuildContext context) {
    final ArrayController arrayController = Get.put(ArrayController());
    List<FTodo> filteredTodos = arrayController.allTodos.where((todo) {
      final title = todo.title!.toLowerCase();
      final details = todo.details!.toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input) || details.contains(input);
    }).toList();

    if (query == '') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.search, color: Colors.white, size: 100.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "Search for tasks",
                style: infoTextStyle,
              ),
            ),
          ],
        ),
      );
    } else if (query != '' && filteredTodos.isEmpty) {
      var message = '"$query"';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.search, color: Colors.white, size: 100.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "No task with $message",
                style: infoTextStyle,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      var arrayIndex = 0;
                      var todoIndex = 0;
                      for (var array in arrayController.arrays) {
                        if (array.title == filteredTodos[index].arrayTitle) {
                          arrayIndex = arrayController.arrays.indexOf(array);
                        }
                      }
                      for (var todo
                          in arrayController.arrays[arrayIndex].todos!) {
                        if (filteredTodos[index].id == todo.id) {
                          todoIndex = arrayController.arrays[arrayIndex].todos!
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
                    child: Padding(
                      padding: (MediaQuery.of(context).size.width < 768)
                          ? const EdgeInsets.only(left: 6.5, right: 6.5)
                          : const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius: BorderRadius.circular(14.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredTodos[index].title!,
                                style: GoogleFonts.notoSans(
                                    color: Colors.white, fontSize: 25.0)),
                            (filteredTodos[index].details != '')
                                ? const SizedBox(height: 5.0)
                                : const SizedBox(),
                            Visibility(
                              visible: filteredTodos[index].details == ''
                                  ? false
                                  : true,
                              child: Text(filteredTodos[index].details!,
                                  style: GoogleFonts.notoSans(
                                    color: const Color(0xFFA8A8A8),
                                    fontSize: 20.0,
                                  )),
                            ),
                            Visibility(
                                visible: filteredTodos[index].date == '' &&
                                        filteredTodos[index].time == ''
                                    ? false
                                    : true,
                                child: primaryDivider),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: filteredTodos[index].date == '' &&
                                          filteredTodos[index].time == ''
                                      ? false
                                      : true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                        (filteredTodos[index].date !=
                                                DateFormat("MM/dd/yyyy")
                                                    .format(DateTime.now()))
                                            ? '${filteredTodos[index].date!}, ${filteredTodos[index].time}'
                                            : 'Today, ${filteredTodos[index].time}',
                                        style: todoScreenStyle),
                                  ),
                                ),
                              ],
                            ),
                            primaryDivider,
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                  'List: ${filteredTodos[index].arrayTitle}',
                                  style: listInfoTextStyle),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (_, __) => const SizedBox(
                    height: 15.0,
                  ),
              itemCount: filteredTodos.length));
    }
  }
}
