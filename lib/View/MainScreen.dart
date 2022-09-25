import 'package:Tasks/View/ArrayScreen.dart';
import 'package:Tasks/View/HomeScreen.dart';
import 'package:Tasks/controllers/Controller.dart';
import 'package:Tasks/widgets/themes.dart';
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
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "0",
                              style: GoogleFonts.notoSans(fontSize: 40.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Today",
                              style: GoogleFonts.notoSans(fontSize: 35.0),
                            ),
                          ),
                        ]),
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(14.0)),
                  ),
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "0",
                              style: GoogleFonts.notoSans(fontSize: 40.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "All",
                              style: GoogleFonts.notoSans(fontSize: 35.0),
                            ),
                          ),
                        ]),
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(14.0)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "0",
                          style: GoogleFonts.notoSans(fontSize: 40.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Scheduled",
                          style: GoogleFonts.notoSans(fontSize: 35.0),
                        ),
                      ),
                    ]),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(14.0)),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Lists", style: titleStyle)),
              Container(
                height: MediaQuery.of(context).size.height * 0.42,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(_routeToHomeScreen(index));
                          },
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (_) {
                              HapticFeedback.heavyImpact();
                              arrayController.arrays.removeAt(index);
                            },
                            child: Container(
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
                                        arrayController.arrays[index].title,
                                        style: GoogleFonts.notoSans(
                                            fontSize: 25.0),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        '${(arrayController.arrays[index].todos?.length == null) ? '0' : arrayController.arrays[index].todos?.length}',
                                        style: GoogleFonts.notoSans(
                                            fontSize: 27.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(14.0)),
                            ),
                          ),
                        ),
                    separatorBuilder: (_, __) => const SizedBox(
                          height: 15.0,
                        ),
                    itemCount: arrayController.arrays.length),
              )
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(_routeToArrayScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF414141),
                  borderRadius: BorderRadius.circular(14.0)),
              width: 140.0,
              height: 55.0,
              child: Center(
                child: Text('Add list', style: buttonTextStyle),
              ),
            )));
  }
}

Route _routeToArrayScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const ArrayScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _routeToHomeScreen(index) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
      index: index,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
