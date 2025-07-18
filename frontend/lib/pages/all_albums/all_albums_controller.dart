import 'package:get/get.dart';
import '../../services/userMusicData_service.dart';
import '../../models/entities/album.dart';

class AllAlbumsController extends GetxController {
  final UserMusicDataService _userMusicDataService = UserMusicDataService();

  var isLoading = true.obs;
  var allAlbums = <Album>[].obs;
  var ratedAlbums = <Album>[].obs;
  var pendingAlbums = <Album>[].obs;

  Future<void> loadUserAlbums(int userId) async {
    try {
      isLoading.value = true;
      final Map<String, List<Album>> albumsData = await _userMusicDataService
          .getUserAlbumsByState(userId);

      ratedAlbums.value = albumsData['valued'] ?? [];
      pendingAlbums.value = albumsData['pending'] ?? [];
      allAlbums.value = [...ratedAlbums, ...pendingAlbums];
    } catch (e) {
      print('Error cargando albums del usuario: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Album> getAlbumsByState(String state) {
    switch (state) {
      case 'todos':
        return allAlbums;
      case 'valorados':
        return ratedAlbums;
      case 'pendientes':
        return pendingAlbums;
      default:
        return allAlbums;
    }
  }

  // Nuevo método para obtener el rating promedio del álbum
  Future<double> getUserAlbumRating(int albumId, int userId) async {
    return await _userMusicDataService.getUserAlbumRating(albumId, userId);
  }
}
