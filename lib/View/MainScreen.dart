import 'package:tasks/authentication/auth.service.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/controllers/Controller.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ArrayController arrayController = Get.put(ArrayController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Tasks", style: titleStyle),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    backgroundColor: tertiaryColor,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.only(top: 15.0),
                        height: 140,
                        child: ListView(children: [
                          ListTile(
                            title: Text(
                              "Sign out",
                              style: optionsTextStyle,
                            ),
                            leading: const Icon(
                              Icons.logout,
                              color: primaryColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Authentication.signOut(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              "Delete account",
                              style: optionsTextStyle,
                            ),
                            leading: const Icon(
                              Icons.delete,
                              color: primaryColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Authentication.deleteAccount(context);
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(14.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "0",
                                style: GoogleFonts.notoSans(
                                    fontSize: 40.0, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Today",
                                style: GoogleFonts.notoSans(
                                    fontSize: 35.0, color: Colors.white),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          color: tertiaryColor,
                          borderRadius: BorderRadius.circular(14.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "0",
                                style: GoogleFonts.notoSans(
                                    fontSize: 40.0, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "All",
                                style: GoogleFonts.notoSans(
                                    fontSize: 35.0, color: Colors.white),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "0",
                            style: GoogleFonts.notoSans(
                                fontSize: 40.0, color: primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Scheduled",
                            style: GoogleFonts.notoSans(
                                fontSize: 35.0, color: Colors.white),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Lists", style: titleStyle)),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: [
                    Obx(() => (arrayController.arrays.isEmpty)
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.37,
                            child: Center(
                                child: Text("Add new lists",
                                    style: buttonTextStyleWhite)),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.37,
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onLongPress: () {
                                        Navigator.of(context).push(
                                            Routes.routeToArrayScreenIndex(
                                                index));
                                      },
                                      onTap: () {
                                        Navigator.of(context).push(
                                            Routes.routeToHomeScreen(index));
                                      },
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        direction: DismissDirection.startToEnd,
                                        onDismissed: (_) {
                                          HapticFeedback.heavyImpact();
                                          arrayController.arrays
                                              .removeAt(index);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                              color: tertiaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(14.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    arrayController
                                                        .arrays[index].title,
                                                    style: GoogleFonts.notoSans(
                                                        color: Colors.white,
                                                        fontSize: 25.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    '${(arrayController.arrays[index].todos?.length == null) ? '0' : arrayController.arrays[index].todos?.length}',
                                                    style: GoogleFonts.notoSans(
                                                        color: primaryColor,
                                                        fontSize: 27.0),
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
                                itemCount: arrayController.arrays.length),
                          )),
                  ],
                )
              ],
            ),
          ),
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
                child: Text('Add list', style: buttonTextStyle),
              ),
            )));
  }
}
