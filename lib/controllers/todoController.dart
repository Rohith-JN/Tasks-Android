import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Todo.dart';

class TodoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<Todo> todos = RxList<Todo>([]);

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    collectionReference =
        _firestore.collection("users").doc(uid).collection("todos");
    todos.bindStream(getTodos());
  }

  Stream<List<Todo>> getTodos() {
    return collectionReference
        .snapshots()
        .map((query) => query.docs.map((item) => Todo.fromMap(item)).toList());
  }
}
