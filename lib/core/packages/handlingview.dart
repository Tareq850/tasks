import 'package:assessment/core/packages/statusrequest.dart';
import 'package:flutter/material.dart';


class HandlingView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;

  const HandlingView({super.key, required this.statusRequest, required this.widget});

  Widget _handleStatus(BuildContext context, StatusRequest status) {
    switch (status) {
      case StatusRequest.loading:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator(),),
            SizedBox(height: 20),
            Text(
              'Please wait..',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        );
      case StatusRequest.serverError:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            Text(
              'خطأ في الخادم، حاول مرة أخرى لاحقاً.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        );
      case StatusRequest.error:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            Text(
              'حدث خطأ غير متوقع!',
              style: TextStyle(color: Colors.redAccent),

            ),
          ],
        );
      case StatusRequest.internetNotFound:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            Text(
              'لا يوجد اتصال بالإنترنت.',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ],
        );
      default:
        return widget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _handleStatus(context, statusRequest),
    );
  }
}


