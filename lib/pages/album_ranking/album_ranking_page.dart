import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'album_ranking_controller.dart';

class AlbumRankingPage extends StatelessWidget {
  AlbumRankingController control = Get.put(AlbumRankingController());

  AlbumRankingPage({super.key});

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
