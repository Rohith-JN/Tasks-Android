import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/models/Array.dart';
import '../models/FTodo.dart';

class ArrayController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;
  late CollectionReference allTodosCollectionReference;

  late Query doneQuery;
  late Query scheduledQuery;
  late Query todayQuery;

  RxList<Array> arrays = RxList<Array>([]);
  RxList<FTodo> allTodos = RxList<FTodo>([]);
  RxList<FTodo> doneTodos = RxList<FTodo>([]);
  RxList<FTodo> scheduledTodos = RxList<FTodo>([]);
  RxList<FTodo> todayTodos = RxList<FTodo>([]);

  @override
  void onInit() {
    super.onInit();
    String uid = Get.find<AuthController>().user!.uid;
    collectionReference =
        _firestore.collection("users").doc(uid).collection("arrays");
    allTodosCollectionReference =
        _firestore.collection("users").doc(uid).collection("allTodos");
    doneQuery = allTodosCollectionReference.where("done", isEqualTo: true);
    scheduledQuery = allTodosCollectionReference.where("dateAndTimeEnabled",
        isEqualTo: true);
    todayQuery = allTodosCollectionReference.where("date",
        isEqualTo: DateFormat("MM/dd/yyyy").format(DateTime.now()));
    arrays.bindStream(getArrays());
    allTodos.bindStream(getAllTodos());
    doneTodos.bindStream(getDoneTodos());
    scheduledTodos.bindStream(getScheduledTodos());
    todayTodos.bindStream(getTodayTodos());
  }

  Stream<List<Array>> getArrays() {
    return collectionReference
        .snapshots()
        .map((query) => query.docs.map((item) => Array.fromMap(item)).toList());
  }

  Stream<List<FTodo>> getAllTodos() {
    return allTodosCollectionReference.snapshots().map(
        (query) => query.docs.map((item) => FTodo.fromMap(item)).toList());
  }

  Stream<List<FTodo>> getDoneTodos() {
    return doneQuery.snapshots().map(
        (query) => query.docs.map((item) => FTodo.fromMap(item)).toList());
  }

  Stream<List<FTodo>> getScheduledTodos() {
    return scheduledQuery.snapshots().map(
        (query) => query.docs.map((item) => FTodo.fromMap(item)).toList());
  }

  Stream<List<FTodo>> getTodayTodos() {
    return todayQuery.snapshots().map(
        (query) => query.docs.map((item) => FTodo.fromMap(item)).toList());
  }
}
