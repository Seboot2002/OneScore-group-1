import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'artist_result_controller.dart';

class ArtistResultPage extends StatelessWidget {
  ArtistResultController control = Get.put(ArtistResultController());

  ArtistResultPage({super.key});

  Widget _buildBody(BuildContext context) {
    return SafeArea(child: Text('Template Page'));
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
