// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tasks/models/Array.dart';

class ArrayController extends GetxController {
  var arrays = <Array>[].obs;

  @override
  void onInit() {
    List? storedArrays = GetStorage().read<List>('arrays');

    if (storedArrays != null) {
      arrays.assignAll(storedArrays.map((e) => Array.fromJson(e)).toList());
    }
    ever(arrays, (_) {
      GetStorage().write('arrays', arrays.toList());
    });
    super.onInit();
  }
}
