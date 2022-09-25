// ignore_for_file: file_names

import 'package:Tasks/controllers/Controller.dart';
import 'package:Tasks/services/functions.dart';
import 'package:Tasks/widgets/themes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Tasks/models/Todo.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  final int? todoIndex;
  final int arrayIndex;

  const TodoScreen({Key? key, this.todoIndex, required this.arrayIndex})
      : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ArrayController arrayController = Get.find();

  @override
  Widget build(BuildContext context) {
    String title = '';
    String detail = '';
    String date = '';
    String? time = '';

    if (widget.todoIndex != null) {
      title = arrayController
          .arrays[widget.arrayIndex].todos![widget.todoIndex!].title;
      detail = arrayController
          .arrays[widget.arrayIndex].todos![widget.todoIndex!].details;
      date = arrayController
          .arrays[widget.arrayIndex].todos![widget.todoIndex!].date!;
      time = arrayController
          .arrays[widget.arrayIndex].todos![widget.todoIndex!].time;
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
        context: context,
        initialTime: selectedTime,
      );
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
              style: menuTextStyleBlue,
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
                if (widget.todoIndex == null &&
                    _formKey.currentState!.validate()) {
                  arrayController.arrays[widget.arrayIndex].todos?.add(Todo(
                    details: detailEditingController.text,
                    title: titleEditingController.text,
                    date: _dateController.text,
                    time: _timeController.text,
                    dateAndTimeEnabled: true,
                    id: UniqueKey().hashCode,
                  ));
                  Get.back();
                  HapticFeedback.heavyImpact();
                  // showNotification();
                }
                if (widget.todoIndex != null &&
                    _formKey.currentState!.validate()) {
                  var editing = arrayController
                      .arrays[widget.arrayIndex].todos![widget.todoIndex!];
                  editing.title = titleEditingController.text;
                  editing.details = detailEditingController.text;
                  editing.date = _dateController.text;
                  editing.time = _timeController.text;
                  editing.dateAndTimeEnabled = true;
                  arrayController.arrays[widget.arrayIndex]
                      .todos![widget.todoIndex!] = editing;
                  Get.back();
                  HapticFeedback.heavyImpact();
                  // showNotification();
                }
              },
              child: Text((widget.todoIndex == null) ? 'Add' : 'Update',
                  style: menuTextStyleBlue),
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
                      color: Theme.of(context).canvasColor,
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
                            decoration: const InputDecoration(
                                hintText: "Title", border: InputBorder.none),
                            style: todoScreenStyle),
                        dividerStyle,
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
                            style: todoScreenDetailsStyle),
                      ],
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: TextField(
                            enabled: false,
                            controller: _dateController,
                            onChanged: (String val) {
                              _setDate = val;
                            },
                            decoration: const InputDecoration(
                                hintText: "Date", border: InputBorder.none),
                            style: todoScreenStyle,
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: TextFormField(
                            onChanged: (String val) {
                              _setTime = val;
                            },
                            enabled: false,
                            controller: _timeController,
                            decoration: const InputDecoration(
                                hintText: "Time", border: InputBorder.none),
                            style: todoScreenStyle,
                          ),
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
