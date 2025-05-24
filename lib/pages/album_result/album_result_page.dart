import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'album_result_controller.dart';

class AlbumResultPage extends StatelessWidget {
  AlbumResultController control = Get.put(AlbumResultController());

  AlbumResultPage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Un album… ¿quieres agregarlo?'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: _buildBody(context),
      ),
    );
  }
}
