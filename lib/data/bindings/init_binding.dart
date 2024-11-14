import 'package:get/get.dart';
import '../../core/packages/crud.dart';

class InitBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(Crud());
  }
}