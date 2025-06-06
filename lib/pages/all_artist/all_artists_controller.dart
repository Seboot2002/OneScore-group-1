import 'package:get/get.dart';
import '../../services/userMusicData_service.dart';
import '../../models/entities/artist.dart';

class AllArtistsController extends GetxController {
  final UserMusicDataService _userMusicDataService = UserMusicDataService();

  var isLoading = true.obs;
  var allArtists = <Artist>[].obs;
  var listenedArtists = <Artist>[].obs;
  var pendingArtists = <Artist>[].obs;

  Future<void> loadUserArtists(int userId) async {
    try {
      isLoading.value = true;

      final Map<String, List<Artist>> artistsData = await _userMusicDataService
          .getUserArtistsByState(userId);

      listenedArtists.value = artistsData['listened'] ?? [];
      pendingArtists.value = artistsData['pending'] ?? [];

      allArtists.value = [...listenedArtists, ...pendingArtists];
    } catch (e) {
      print('Error cargando artistas del usuario: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Artist> getArtistsByState(String state) {
    switch (state) {
      case 'todos':
        return allArtists;
      case 'escuchados':
        return listenedArtists;
      case 'pendientes':
        return pendingArtists;
      default:
        return allArtists;
    }
  }
}
