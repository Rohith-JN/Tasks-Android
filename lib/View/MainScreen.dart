import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/services/Notification.service.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/view/DeleteScreen.dart';
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
          title: Text("Lists",
              style: GoogleFonts.notoSans(
                fontSize: 30,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    backgroundColor: tertiaryColor,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.only(top: 15.0),
                        height: 310,
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
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                          )),
                          const SizedBox(height: 15.0),
                          dividerStyle,
                          ListTile(
                            title: Text(
                              "Change theme",
                              style: optionsTextStyle,
                            ),
                            leading: Icon(
                              Icons.color_lens_sharp,
                              color: primaryColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              showDialog<String>(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 37, 37, 37),
                                  title: const Text('Pick a color',
                                      style: TextStyle(color: Colors.white)),
                                  actions: [
                                    ColorPicker(
                                        showLabel: false,
                                        pickerColor: primaryColor,
                                        onColorChanged: (color) {
                                          setState(() {
                                            primaryColor = color;
                                          });
                                        }),
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, 'Select Color'),
                                      child: const Text('Select Color',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
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
                                builder: (BuildContext context) => AlertDialog(
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
                icon: menuIcon)
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: GetX<ArrayController>(
              init: Get.put<ArrayController>(ArrayController()),
              builder: (ArrayController arrayController) {
                return (arrayController.arrays.isEmpty)
                    ? Center(
                        child:
                            Text("Add new lists", style: buttonTextStyleWhite))
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                              onLongPress: () {
                                Navigator.of(context).push(
                                    Routes.routeToArrayScreenIndex(index,
                                        arrayController.arrays[index].id));
                              },
                              onTap: () {
                                Navigator.of(context)
                                    .push(Routes.routeToHomeScreen(index));
                              },
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (_) {
                                  HapticFeedback.heavyImpact();
                                  Database().deleteArray(uid,
                                      arrayController.arrays[index].id ?? '');
                                  for (var i = 0;
                                      i <
                                          arrayController
                                              .arrays[index].todos!.length;
                                      i++) {
                                    NotificationService()
                                        .flutterLocalNotificationsPlugin
                                        .cancel(arrayController
                                            .arrays[index].todos![i].id!);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                      color: tertiaryColor,
                                      borderRadius:
                                          BorderRadius.circular(14.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            arrayController
                                                    .arrays[index].title ??
                                                '',
                                            style: GoogleFonts.notoSans(
                                                color: Colors.white,
                                                fontSize: 25.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${arrayController.arrays[index].todos!.length}',
                                                style: GoogleFonts.notoSans(
                                                    color: primaryColor,
                                                    fontSize: 27.0),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: primaryColor,
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
                        separatorBuilder: (_, __) => const SizedBox(
                              height: 15.0,
                            ),
                        itemCount: arrayController.arrays.length);
              }),
        ),
        floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(Routes.routeToArrayScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                  color: tertiaryColor,
                  borderRadius: BorderRadius.circular(14.0)),
              width: 140.0,
              height: 55.0,
              child: Center(
                child: Text('Add list',
                    style: TextStyle(color: primaryColor, fontSize: 23.0)),
              ),
            )));
  }
}
