import 'package:flutter/material.dart';
import 'package:onescore/components/BackButtonWidget.dart';
import 'package:onescore/components/ButtonWidget.dart';
import 'package:onescore/components/CoverAlbumWidget.dart';
import 'package:onescore/components/EditableAvatarWidget.dart';
import 'package:onescore/components/FieldTextWidget.dart';
import 'package:onescore/components/MusicItemsGrid.dart';
import 'package:onescore/components/OneScoreCheckbox.dart';
import 'package:onescore/components/SearchingBarWidget.dart';
import 'package:onescore/components/StatisticsButton.dart';
import 'package:onescore/components/TitleWidget.dart';
import 'package:onescore/components/TrackListItemWidget.dart';
import 'package:onescore/components/BottomNavigationBar.dart';
import 'package:onescore/components/album_card.dart';
import 'package:onescore/components/artist_card.dart';
import 'package:onescore/components/user_card.dart'; // <-- asegúrate que este sea el nuevo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> trackNames = [
    'Overcompensate',
    'Next semester',
    'Backslide',
    'Midwest Indigo',
    'Routines in the Night',
    'Vignette',
    'The Craving',
    'Lavish',
    'Navigating',
    'Snap Back',
    'Oldies Station',
    'At the Risk of Feeling Dumb',
    'Paladin Strait',
  ];

  final List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < trackNames.length; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onCheckboxChanged(List<Map<String, dynamic>> updatedCheckboxes) {
      print(updatedCheckboxes);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleWidgetPreview(),
            FieldTextWidgetPreview(),
            ButtonWidgetPreview(),
            ButtonWidgetPreview2(),
            EditableAvatarWidgetPreview(),
            BackButtonWidgetPreview(),
            Wrap(
              spacing: MediaQuery.of(context).size.width * 0.08,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                StatisticsButtonWidgetPreview(),
                StatisticsButtonWidgetPreview2(),
                StatisticsButtonWidgetPreview(),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Lista de Canciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(trackNames.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TrackListItemWidget(
                    trackName: trackNames[index],
                    ratingController: controllers[index],
                  ),
                );
              }),
            ),
            TitleWidgetPreview(),
            ArtistCardPreview(),
            AlbumCardPreview(),
            UserCardPreview(),
            SearchingBarWidgetPreview(),
            MusicItemsGridPreview(),
            CoverAlbumWidgetPreview(),
            OneScoreCheckBoxPreview(
              checkboxesData: [
                {'value': true, 'label': 'Todos'},
                {'value': false, 'label': 'Albums'},
                {'value': false, 'label': 'Artistas'},
                {'value': false, 'label': 'Usuarios'},
              ],
              onCheckboxChanged: onCheckboxChanged,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(),
    );
  }
}
