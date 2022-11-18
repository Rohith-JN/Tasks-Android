// ignore_for_file: file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Todo.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/services/functions.services.dart';
import 'package:tasks/utils/widgets.dart';

class TodoScreen extends StatefulWidget {
  final int? todoIndex;
  final int? arrayIndex;

  const TodoScreen({Key? key, this.todoIndex, this.arrayIndex})
      : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ArrayController arrayController = Get.find();
  final AuthController authController = Get.find();
  final String uid = Get.find<AuthController>().user!.uid;

  bool done = false;

  @override
  Widget build(BuildContext context) {
    String title = '';
    String detail = '';
    String date = '';
    String? time = '';

    if (widget.todoIndex != null) {
      title = arrayController
              .arrays[widget.arrayIndex!].todos![widget.todoIndex!].title ??
          '';
      detail = arrayController
              .arrays[widget.arrayIndex!].todos![widget.todoIndex!].details ??
          '';
      date = arrayController
          .arrays[widget.arrayIndex!].todos![widget.todoIndex!].date!;
      time = arrayController
          .arrays[widget.arrayIndex!].todos![widget.todoIndex!].time;
    }

    TextEditingController titleEditingController =
        TextEditingController(text: title);
    TextEditingController detailEditingController =
        TextEditingController(text: detail);
    TextEditingController _dateController = TextEditingController(text: date);
    TextEditingController _timeController = TextEditingController(text: time);

    late String _setTime, _setDate;
    late String _hour, _minute, _time;
    late String dateTime;
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay(
        hour: (TimeOfDay.now().minute > 55)
            ? TimeOfDay.now().hour + 1
            : TimeOfDay.now().hour,
        minute: (TimeOfDay.now().minute > 55) ? 0 : TimeOfDay.now().minute + 5);

    Future<DateTime?> _selectDate() => showDatePicker(
        builder: (context, child) {
          return datePickerTheme(child);
        },
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));

    Future<TimeOfDay?> _selectTime() => showTimePicker(
        builder: (context, child) {
          return timePickerTheme(child);
        },
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.input);

    Future _pickDateTime() async {
      DateTime? date = await _selectDate();
      if (date == null) return;
      if (date != null) {
        selectedDate = date;
        _dateController.text = DateFormat("MM/dd/yyyy").format(selectedDate);
      }
      TimeOfDay? time = await _selectTime();
      if (time == null) {
        _timeController.text = formatDate(
            DateTime(
                DateTime.now().year,
                DateTime.now().day,
                DateTime.now().month,
                DateTime.now().hour,
                DateTime.now().minute + 5),
            [hh, ':', nn, " ", am]).toString();
      }
      if (time != null) {
        selectedTime = time;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      }
    }

    final _formKey = GlobalKey<FormState>();

    final StreamController<bool> checkBoxController = StreamController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text((widget.todoIndex == null) ? 'New Task' : 'Edit Task',
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
              style: TextStyle(fontSize: 20.0, color: primaryColor),
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
              onPressed: () async {
                if (widget.todoIndex == null &&
                    _formKey.currentState!.validate()) {
                  var finalId = UniqueKey().hashCode;
                  arrayController.arrays[widget.arrayIndex!].todos!.add(Todo(
                      title: titleEditingController.text,
                      details: detailEditingController.text,
                      id: finalId,
                      date: _dateController.text,
                      time: _timeController.text,
                      dateAndTimeEnabled: (_dateController.text != '' &&
                              _timeController.text != '')
                          ? true
                          : false,
                      done: false,
                      dateCreated: Timestamp.now()));
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("arrays")
                      .doc(arrayController.arrays[widget.arrayIndex!].id)
                      .set({
                    "title": arrayController.arrays[widget.arrayIndex!].title,
                    "dateCreated":
                        arrayController.arrays[widget.arrayIndex!].dateCreated,
                    "todos": arrayController.arrays[widget.arrayIndex!].todos!
                        .map((todo) => todo.toJson())
                        .toList()
                  });
                  Database().addAllTodo(
                      uid,
                      finalId,
                      arrayController.arrays[widget.arrayIndex!].title!,
                      titleEditingController.text,
                      detailEditingController.text,
                      Timestamp.now(),
                      _dateController.text,
                      _timeController.text,
                      false,
                      (_dateController.text != '' && _timeController.text != '')
                          ? true
                          : false,
                      finalId);
                  Get.back();
                  HapticFeedback.heavyImpact();
                  if (_dateController.text.isNotEmpty &&
                      _timeController.text.isNotEmpty) {
                        // Todo set notification at finalId
                  }
                }
                if (widget.todoIndex != null &&
                    _formKey.currentState!.validate()) {
                  var editing = arrayController
                      .arrays[widget.arrayIndex!].todos![widget.todoIndex!];
                  editing.title = titleEditingController.text;
                  editing.details = detailEditingController.text;
                  editing.date = _dateController.text;
                  editing.time = _timeController.text;
                  editing.done = done;
                  editing.dateAndTimeEnabled =
                      (titleEditingController.text != '' &&
                              detailEditingController.text != '')
                          ? true
                          : false;
                  arrayController.arrays[widget.arrayIndex!]
                      .todos![widget.todoIndex!] = editing;
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("arrays")
                      .doc(arrayController.arrays[widget.arrayIndex!].id)
                      .set({
                    "title": arrayController.arrays[widget.arrayIndex!].title,
                    "dateCreated":
                        arrayController.arrays[widget.arrayIndex!].dateCreated,
                    "todos": arrayController.arrays[widget.arrayIndex!].todos!
                        .map((todo) => todo.toJson())
                        .toList()
                  });
                  Database().updateAllTodo(
                      uid,
                      arrayController.arrays[widget.arrayIndex!]
                          .todos![widget.todoIndex!].id!, // get doc id
                      arrayController.arrays[widget.arrayIndex!].title!,
                      titleEditingController.text,
                      detailEditingController.text,
                      Timestamp.now(),
                      _dateController.text,
                      _timeController.text,
                      done,
                      (_dateController.text != '' && _timeController.text != '')
                          ? true
                          : false,
                      arrayController.arrays[widget.arrayIndex!]
                          .todos![widget.todoIndex!].id!);
                  Get.back();
                  HapticFeedback.heavyImpact();
                  if (_dateController.text.isNotEmpty &&
                      _timeController.text.isNotEmpty) {
                    // Todo set notification at arrayController.arrays[widget.arrayIndex!].todos![widget.todoIndex!].id!
                  }
                }
              },
              child: Text((widget.todoIndex == null) ? 'Add' : 'Update',
                  style: TextStyle(fontSize: 20.0, color: primaryColor)),
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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            validator: Validator.titleValidator,
                            controller: titleEditingController,
                            autofocus: true,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            maxLines: 1,
                            maxLength: 25,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                counterStyle: counterTextStyle,
                                hintStyle: hintTextStyle,
                                hintText: "Title",
                                border: InputBorder.none),
                            style: todoScreenStyle),
                        primaryDivider,
                        TextField(
                            controller: detailEditingController,
                            maxLines: null,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                counterStyle: counterTextStyle,
                                hintStyle: hintTextStyle,
                                hintText: "Notes",
                                border: InputBorder.none),
                            style: todoScreenDetailsStyle),
                      ],
                    ),
                  )),
              Visibility(
                visible: (widget.todoIndex != null) ? true : false,
                child: Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(14.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Completed",
                            style: todoScreenStyle,
                          ),
                          Transform.scale(
                            scale: 1.3,
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor:
                                      const Color.fromARGB(255, 187, 187, 187)),
                              child: StreamBuilder(
                                  stream: checkBoxController.stream,
                                  initialData: (widget.todoIndex == null)
                                      ? false
                                      : arrayController
                                          .arrays[widget.arrayIndex!]
                                          .todos![widget.todoIndex!]
                                          .done,
                                  builder:
                                      (context, AsyncSnapshot<bool> snapshot) {
                                    return Checkbox(
                                        shape: const CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: primaryColor,
                                        value: snapshot.data,
                                        side: Theme.of(context)
                                            .checkboxTheme
                                            .side,
                                        onChanged: (value) {
                                          checkBoxController.sink.add(value!);
                                          done = value;
                                        });
                                  }),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () async {
                  await _pickDateTime();
                },
                child: Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 15.0),
                    decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(14.0)),
                    child: Column(
                      children: [
                        TextField(
                          enabled: false,
                          controller: _dateController,
                          onChanged: (String val) {
                            _setDate = val;
                          },
                          decoration: InputDecoration(
                              hintText: "Date",
                              hintStyle: hintTextStyle,
                              border: InputBorder.none),
                          style: todoScreenStyle,
                        ),
                        primaryDivider,
                        TextField(
                          onChanged: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          controller: _timeController,
                          decoration: InputDecoration(
                              hintText: "Time",
                              hintStyle: hintTextStyle,
                              border: InputBorder.none),
                          style: todoScreenStyle,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
