import 'package:flutter/material.dart';
import 'package:tasks/utils/global.dart';

class ListItem extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String count;
  final IconData icon;
  const ListItem(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.count,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        onTap: () => onPressed,
        trailing: Text(
          count,
          style: const TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        leading: Icon(icon, color: primaryColor, size: 40.0),
        minLeadingWidth: 10.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 25.0)),
        ),
        dense: false,
      ),
    );
  }
}
