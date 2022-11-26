// ignore_for_file: file_names

import 'package:tasks/controllers/authController.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/widgets.dart';

final formKey = GlobalKey<FormState>();

class ArrayScreen extends StatefulWidget {
  final int? index;
  final String? docId;

  const ArrayScreen({Key? key, this.index, this.docId}) : super(key: key);

  @override
  State<ArrayScreen> createState() => _ArrayScreenState();
}

class _ArrayScreenState extends State<ArrayScreen> {
  final ArrayController arrayController = Get.find();
  final AuthController authController = Get.find();
  late TextEditingController titleEditingController;
  @override
  void initState() {
    super.initState();
    String? title = '';
    if (widget.index != null) {
      title = arrayController.arrays[widget.index!].title;
    }
    titleEditingController = TextEditingController(text: title);
  }

  @override
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              style: actionButtonTextStyle,
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
                if (widget.index == null && formKey.currentState!.validate()) {
                  for (var i = 0; i < arrayController.arrays.length; i++) {
                    if (titleEditingController.text.toLowerCase() ==
                        arrayController.arrays[i].title!.toLowerCase()) {
                      titleEditingController.text =
                          "${titleEditingController.text} - copy";
                    }
                  }
                  Database().addArray(
                      authController.user!.uid, titleEditingController.text);
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
                if (widget.index != null && formKey.currentState!.validate()) {
                  var editing = arrayController.arrays[widget.index!];
                  editing.title = titleEditingController.text;
                  arrayController.arrays[widget.index!] = editing;
                  Database().updateArray(
                      authController.user!.uid, editing.title!, widget.docId!);
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
              },
              child: Text((widget.index == null) ? 'Add' : 'Update',
                  style: actionButtonTextStyle),
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
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        primaryTextField(context, titleEditingController, 1, 25,
                            TextInputAction.done, "Title", todoScreenStyle)
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
