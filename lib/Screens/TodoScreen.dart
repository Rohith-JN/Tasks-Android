// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/controllers/TodoController.dart';
import 'package:todo_app/models/Todo.dart';

class TodoScreen extends StatelessWidget {
  final int? index;
  final TodoController todoController = Get.find();
  TodoScreen({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = '';
    String detail = '';

    if (index != null) {
      title = todoController.todos[index!].title;
      detail = todoController.todos[index!].details;
    }

    TextEditingController titleEditingController =
        TextEditingController(text: title);
    TextEditingController detailEditingController =
        TextEditingController(text: detail);

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text((index == null) ? 'New Reminder' : 'Edit Reminder',
            style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).textTheme.headline2!.color)),
        leadingWidth: 80.0,
        leading: Center(
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 20.0, color: Color(0xFF39A7FD)),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: TextButton(
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  if (index == null && _formKey.currentState!.validate()) {
                    todoController.todos.add(Todo(
                      details: detailEditingController.text,
                      title: titleEditingController.text,
                    ));
                    Get.back();
                  }
                  if (index != null && _formKey.currentState!.validate()) {
                    var editing = todoController.todos[index!];
                    editing.title = titleEditingController.text;
                    editing.details = detailEditingController.text;
                    todoController.todos[index!] = editing;
                    Get.back();
                  }
                },
                child: Text((index == null) ? 'Add' : 'Update',
                    style:
                        const TextStyle(color: Color(0xFF39A7FD), fontSize: 20.0))),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF414141),
                      offset: Offset(2.5, 2.5),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ), //B
                  ],
                  borderRadius: BorderRadius.circular(14.0)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      controller: titleEditingController,
                      autofocus: true,
                      autocorrect: false,
                      cursorColor: Colors.grey,
                      maxLines: 1,
                      maxLength: 25,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: "Title", border: InputBorder.none),
                      style: GoogleFonts.notoSans(
                          color: Theme.of(context).hintColor, fontSize: 23.0),
                    ),
                    const Divider(
                      color: Color(0xFF707070),
                      thickness: 1,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      controller: detailEditingController,
                      maxLines: null,
                      autocorrect: false,
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          hintText: "Notes", border: InputBorder.none),
                      style: GoogleFonts.notoSans(
                          color: Theme.of(context).hintColor, fontSize: 20.0),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
