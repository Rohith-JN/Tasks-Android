// ignore_for_file: file_names

import 'dart:async';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/controllers/todoController.dart';
import 'package:tasks/services/Notification.service.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/utils/validators.dart';
import 'package:timezone/timezone.dart' as tz;

class TodoScreen extends StatefulWidget {
  final int? index;
  final String? id;

  const TodoScreen({Key? key, this.index, this.id}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoController todoController = Get.find();
  final AuthController authController = Get.find();

  tz.TZDateTime parse(date, time) {
    String value = '$date $time';
    String currentFormat = "MM/dd/yyyy hh:mm a";
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        bool isUtc = false;
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {}
    }
    String parsed = dateTime!.toString();
    return tz.TZDateTime.parse(tz.local, parsed);
  }

  bool done = false;
  bool dateAndTimeEnabled = false;
  int intId = UniqueKey().hashCode;

  @override
  Widget build(BuildContext context) {
    String title = '';
    String detail = '';
    String date = '';
    String? time = '';

    if (widget.index != null) {
      title = todoController.todos[widget.index!].title ?? '';
      detail = todoController.todos[widget.index!].details ?? '';
      date = todoController.todos[widget.index!].date!;
      time = todoController.todos[widget.index!].time;
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
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                surface: primaryColor,
                secondary: primaryColor,
                onPrimary: Colors.white, // selected text color
                onSurface: Colors.white, // default text color
                primary: primaryColor, // circle color
              )),
              child: child!,
            );
          },
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          context: context,
          initialDate: selectedDate,
          initialDatePickerMode: DatePickerMode.day,
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 5));
      if (picked != null) {
        selectedDate = picked;
        _dateController.text = DateFormat("MM/dd/yyyy").format(selectedDate);
      }
    }

    Future<Null> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: const Color.fromARGB(255, 70, 70, 70),
                  dayPeriodTextColor: primaryColor,
                  hourMinuteTextColor: MaterialStateColor.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                          ? Colors.white
                          : Colors.white),
                  dialHandColor: primaryColor,
                  helpTextStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                  dialTextColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.white
                          : Colors.white),
                  entryModeIconColor: primaryColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => primaryColor)),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialTime: selectedTime,
          initialEntryMode: TimePickerEntryMode.input);
      if (picked != null) {
        selectedTime = picked;
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
    final StreamController<bool> dateAndTimeEnabledController =
        StreamController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text((widget.index == null) ? 'New Task' : 'Edit Task',
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
              onPressed: () {
                if (widget.index == null && _formKey.currentState!.validate()) {
                  Database().addTodo(
                      authController.user!.uid,
                      intId,
                      titleEditingController.text,
                      detailEditingController.text,
                      _dateController.text,
                      _timeController.text,
                      (_dateController.text != '' && _timeController.text != '')
                          ? true
                          : false,
                      false);
                  Get.back();
                  HapticFeedback.heavyImpact();
                  NotificationService().showNotification(
                      intId,
                      'Reminder',
                      titleEditingController.text,
                      parse(_dateController.text, _timeController.text));
                }
                if (widget.index != null && _formKey.currentState!.validate()) {
                  var editing = todoController.todos[widget.index!];
                  editing.title = titleEditingController.text;
                  editing.details = detailEditingController.text;
                  editing.date = _dateController.text;
                  editing.time = _timeController.text;
                  editing.done = done;
                  editing.dateAndTimeEnabled = dateAndTimeEnabled;
                  todoController.todos[widget.index!] = editing;
                  Database().updateTodo(
                      authController.user!.uid,
                      editing.title!,
                      editing.details!,
                      editing.date!,
                      editing.time!,
                      editing.dateAndTimeEnabled!,
                      editing.done!,
                      widget.id!);
                  Get.back();
                  HapticFeedback.heavyImpact();
                  NotificationService().showNotification(
                      todoController.todos[widget.index!].intId!,
                      'Reminder',
                      titleEditingController.text,
                      parse(_dateController.text, _timeController.text));
                }
              },
              child: Text((widget.index == null) ? 'Add' : 'Update',
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
                        dividerStyle,
                        TextFormField(
                            validator: Validator.titleValidator,
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
                visible: (widget.index != null) ? true : false,
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
                                  initialData: (widget.index == null)
                                      ? false
                                      : todoController
                                          .todos[widget.index!].done,
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
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Reminder",
                              style: todoScreenStyle,
                            ),
                            Transform.scale(
                              scale: 1.3,
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: const Color.fromARGB(
                                        255, 187, 187, 187)),
                                child: StreamBuilder(
                                    stream: dateAndTimeEnabledController.stream,
                                    initialData: (widget.index == null)
                                        ? false
                                        : todoController.todos[widget.index!]
                                            .dateAndTimeEnabled,
                                    builder: (context,
                                        AsyncSnapshot<bool> snapshot) {
                                      return Checkbox(
                                          shape: const CircleBorder(),
                                          checkColor: Colors.white,
                                          activeColor: primaryColor,
                                          value: snapshot.data,
                                          side: Theme.of(context)
                                              .checkboxTheme
                                              .side,
                                          onChanged: (value) {
                                            dateAndTimeEnabledController.sink
                                                .add(value!);
                                            if (value == false) {
                                              _timeController.clear();
                                              _dateController.clear();
                                              dateAndTimeEnabled = false;
                                            }
                                            if (_timeController.text != '' &&
                                                _dateController.text != '') {
                                              dateAndTimeEnabled = true;
                                            }
                                          });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                      dividerStyle,
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextField(
                          enabled: false,
                          controller: _dateController,
                          onChanged: (String val) {
                            _setDate = val;
                          },
                          decoration: InputDecoration(
                              hintText: "Select Date",
                              counterStyle: counterTextStyle,
                              hintStyle: hintTextStyle,
                              border: InputBorder.none),
                          style: todoScreenStyle,
                        ),
                      ),
                      dividerStyle,
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: TextFormField(
                          onChanged: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          controller: _timeController,
                          decoration: InputDecoration(
                              hintText: "Select Time",
                              counterStyle: counterTextStyle,
                              hintStyle: hintTextStyle,
                              border: InputBorder.none),
                          style: todoScreenStyle,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
