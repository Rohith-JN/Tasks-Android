// ignore_for_file: file_names, empty_statements

import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/widgets.dart';

class FilteredScreen extends StatefulWidget {
  final String title;
  final String infoText;
  final data;
  const FilteredScreen(
      {Key? key,
      required this.title,
      required this.data,
      required this.infoText})
      : super(key: key);

  @override
  State<FilteredScreen> createState() => _FilteredScreenState();
}

class _FilteredScreenState extends State<FilteredScreen> {
  final ArrayController arrayController = Get.put(ArrayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.title, style: appBarTextStyle),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: (widget.data.isEmpty)
              ? Center(child: Text(widget.infoText, style: infoTextStyle))
              : GetX<ArrayController>(
                  init: Get.put<ArrayController>(ArrayController()),
                  builder: (ArrayController arrayController) {
                    return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 6.5, right: 6.5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: tertiaryColor,
                                    borderRadius: BorderRadius.circular(14.0)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.data[index].title!,
                                        style: todoScreenStyle),
                                    const SizedBox(height: 5.0),
                                    primaryDivider,
                                    Visibility(
                                      child: Text(widget.data[index].details!,
                                          style: todoScreenStyle),
                                    ),
                                    Visibility(
                                        visible: widget.data[index].date ==
                                                    '' &&
                                                widget.data[index].time == ''
                                            ? false
                                            : true,
                                        child: primaryDivider),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                          visible: widget.data[index].date ==
                                                      '' &&
                                                  widget.data[index].time == ''
                                              ? false
                                              : true,
                                          child: Obx(
                                            () => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: Text(
                                                  (widget.data[index].date !=
                                                          DateFormat(
                                                                  "MM/dd/yyyy")
                                                              .format(DateTime
                                                                  .now()))
                                                      ? '${widget.data[index].date!}, ${widget.data[index].time}'
                                                      : 'Today, ${widget.data[index].time}',
                                                  style: todoScreenStyle),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    primaryDivider,
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Text(
                                          'List: ${widget.data[index].arrayTitle}',
                                          style: listInfoTextStyle),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        separatorBuilder: (_, __) => const SizedBox(
                              height: 15.0,
                            ),
                        itemCount: widget.data.length);
                  }),
        ));
  }
}
