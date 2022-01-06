// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/TasksDone.dart';
import 'package:todo_app/Screens/TodayTodos.dart';
import 'package:todo_app/Screens/scheduledTodos.dart';
import 'package:todo_app/controllers/TodoController.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TodoController todoController = Get.put(TodoController());

  @override
  void initState() {
    todoController.getDoneTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        centerTitle: false,
        title: Text("Tasks", style: Theme.of(context).textTheme.headline1),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const HomeScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 9.0, right: 15.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Obx(() => Text('${todoController.todos.length}', style: Theme.of(context).textTheme.headline1,)),
                      Text("All", style: Theme.of(context).textTheme.headline1)
                    ],),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    height: 138.0,
                    width: double.infinity,
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
                        BorderRadius.circular(14.0))
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const TasksDone());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Icon(Icons.done, size: 40.0),
                      Text("Completed", style: Theme.of(context).textTheme.headline1)
                    ],),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    height: 138.0,
                    width: double.infinity,
                     decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(2.5, 2.5),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                              ), 
                          ],
                        borderRadius:
                        BorderRadius.circular(14.0))
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ScheduledTodos());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 14.0, right: 12.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Icon(Icons.calendar_today, size: 40.0),
                      Text("Scheduled", style: Theme.of(context).textTheme.headline1)
                    ],),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    height: 138.0,
                    width: double.infinity,
                     decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(2.5, 2.5),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                              ), 
                          ],
                        borderRadius:
                        BorderRadius.circular(14.0))
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const TodayTodos());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 14.0, right: 12.0),
                  child: Container(
                    child: Stack(
                      children: [
                      Positioned(
                        left: 10.0,
                        top: 11.5,
                        child: Text('${DateFormat("dd").format(DateTime.now())}', style: GoogleFonts.notoSans(
                          fontSize: 17.0,
                          color: Theme.of(context).textTheme.headline1!.color,
                        )),
                      ),
                      const Positioned(child: Icon(Icons.calendar_today, size: 40.0)),
                      Positioned(top: 60.0, child: Text("Today", style: Theme.of(context).textTheme.headline1))
                    ],),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    height: 138.0,
                    width: double.infinity,
                     decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  offset: const Offset(2.5, 2.5),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                              ), 
                          ],
                        borderRadius:
                        BorderRadius.circular(14.0))
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}