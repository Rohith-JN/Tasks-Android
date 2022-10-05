import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Array.dart';

class ArrayController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<ArrayModel> arrays = RxList<ArrayModel>([]);

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    collectionReference =
        _firestore.collection("users").doc(uid).collection("arrays");
    arrays.bindStream(getAllArrays());
  }

  Stream<List<ArrayModel>> getAllArrays() {
    return collectionReference.snapshots().map(
        (query) => query.docs.map((item) => ArrayModel.fromMap(item)).toList());
  }
}
