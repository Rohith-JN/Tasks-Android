import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Array.dart';

class ArrayController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<Array> arrays = RxList<Array>([]);

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    collectionReference =
        _firestore.collection("users").doc(uid).collection("arrays");
    arrays.bindStream(getArrays());
  }

  Stream<List<Array>> getArrays() {
    return collectionReference
        .snapshots()
        .map((query) => query.docs.map((item) => Array.fromMap(item)).toList());
  }
}
