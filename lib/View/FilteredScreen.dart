// ignore_for_file: file_names, empty_statements

import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/HomeScreen.dart';

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
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                List<String?> arrays = [];
                                var arrayIndex = 0;
                                for (var i = 0;
                                    i < arrayController.arrays.length;
                                    i++) {
                                  arrays.add(arrayController.arrays[i].title);
                                }
                                for (var array in arrays) {
                                  if (array == widget.data[index].arrayTitle) {
                                    arrayIndex = arrays.indexOf(array);
                                  }
                                }
                                Navigator.of(context).push(Routes.route(
                                    HomeScreen(index: arrayIndex),
                                    const Offset(1.0, 0.0)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 6.5, right: 6.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: tertiaryColor,
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.data[index].title!,
                                          style: GoogleFonts.notoSans(
                                              color: Colors.white,
                                              fontSize: 25.0)),
                                      (widget.data[index].details != '')
                                          ? SizedBox(height: 5.0)
                                          : SizedBox(),
                                      Visibility(
                                        visible:
                                            widget.data[index].details == ''
                                                ? false
                                                : true,
                                        child: Text(widget.data[index].details!,
                                            style: GoogleFonts.notoSans(
                                              color: const Color(0xFFA8A8A8),
                                              fontSize: 20.0,
                                            )),
                                      ),
                                      Visibility(
                                          visible: widget.data[index].date ==
                                                      '' &&
                                                  widget.data[index].time == ''
                                              ? false
                                              : true,
                                          child: primaryDivider),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: widget.data[index].date ==
                                                        '' &&
                                                    widget.data[index].time ==
                                                        ''
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
                            ),
                        separatorBuilder: (_, __) => const SizedBox(
                              height: 15.0,
                            ),
                        itemCount: widget.data.length);
                  }),
        ));
  }
}
