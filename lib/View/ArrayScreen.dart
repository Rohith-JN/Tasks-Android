// ignore_for_file: file_names

import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/Controller.dart';
import 'package:tasks/models/Array.dart';

class ArrayScreen extends StatefulWidget {
  final int? index;

  const ArrayScreen({Key? key, this.index}) : super(key: key);

  @override
  State<ArrayScreen> createState() => _ArrayScreenState();
}

class _ArrayScreenState extends State<ArrayScreen> {
  final ArrayController arrayController = Get.find();

  @override
  Widget build(BuildContext context) {
    String title = '';

    if (widget.index != null) {
      title = arrayController.arrays[widget.index!].title;
    }

    TextEditingController titleEditingController =
        TextEditingController(text: title);

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text((widget.index == null) ? 'New List' : 'Edit List',
            style: menuTextStyle),
        leadingWidth: 90.0,
        leading: Center(
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: menuTextStyleGreen,
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
                if (widget.index == null && _formKey.currentState!.validate()) {
                  arrayController.arrays.add(Array(
                      title: titleEditingController.text,
                      id: UniqueKey().hashCode,
                      todos: []));
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
                if (widget.index != null && _formKey.currentState!.validate()) {
                  var editing = arrayController.arrays[widget.index!];
                  editing.title = titleEditingController.text;
                  arrayController.arrays[widget.index!] = editing;
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
              },
              child: Text((widget.index == null) ? 'Add' : 'Update',
                  style: menuTextStyleGreen),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 37, 37, 37),
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
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
                            decoration: InputDecoration(
                                counterStyle: counterTextStyle,
                                hintText: "Title",
                                hintStyle: hintTextStyle,
                                border: InputBorder.none),
                            style: todoScreenStyle),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
