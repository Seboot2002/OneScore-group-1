import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onescore/controllers/auth_controller.dart';
import 'package:onescore/pages/all_albums/all_albums_page.dart';
import 'package:onescore/pages/all_artist/all_artists_page.dart';
import 'package:onescore/pages/change_password/change_password_page.dart';
import 'package:onescore/pages/profile/profile_page.dart';
import 'package:onescore/pages/results/results_page.dart';
import 'package:onescore/pages/suggest/suggest_page.dart';
import 'pages/log_in/log_in_page.dart';
import 'pages/sign_up/sign_up_page.dart';
import 'pages/home/home_page.dart';
import 'pages/search_bar/search_bar_page.dart';
import 'pages/album_result/album_result_page.dart';
import 'pages/artist_result/artist_result_page.dart';
import 'pages/user_result/user_result_page.dart';
import 'pages/edit_profile/edit_profile_page.dart';
import 'package:onescore/controllers/bottom_navigation_controller.dart';

void main() {
  Get.put(BottomNavigationController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onescore',
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/log-in',
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      getPages: [
        GetPage(name: '/log-in', page: () => LogInPage()),
        GetPage(name: '/sign-up', page: () => SignUpPage()),
        GetPage(name: '/results', page: () => ResultsPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/searching', page: () => SearchBarPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/suggest', page: () => SuggestPage()),
        GetPage(name: '/all_albums', page: () => AllAlbumsPage()),
        GetPage(name: '/all_artists', page: () => AllArtistsPage()),
        GetPage(name: '/album-result', page: () => AlbumResultPage()),
        GetPage(name: '/artist-result', page: () => ArtistResultPage()),
        GetPage(name: '/user-result', page: () => UserResultPage()),
        GetPage(name: '/edit-profile', page: () => EditProfilePage()),
        GetPage(name: '/change-password', page: () => ChangePasswordPage()),
      ],
    );
  }
}
