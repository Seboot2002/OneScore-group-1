import 'package:get/get.dart';
import '../../services/userMusicData_service.dart';
import '../../models/entities/album.dart';

class AllAlbumsController extends GetxController {
  final UserMusicDataService _userMusicDataService = UserMusicDataService();

  // Estados reactivos
  var isLoading = true.obs;
  var allAlbums = <Album>[].obs;
  var ratedAlbums = <Album>[].obs;
  var pendingAlbums = <Album>[].obs;

  // Método para cargar los albums del usuario
  Future<void> loadUserAlbums(int userId) async {
    try {
      isLoading.value = true;

      // Obtener albums valorados y pendientes del usuario
      final Map<String, List<Album>> albumsData = await _userMusicDataService
          .getUserAlbumsByState(userId);

      // Actualizar los observables
      ratedAlbums.value = albumsData['valued'] ?? [];
      pendingAlbums.value = albumsData['pending'] ?? [];

      // Combinar todos los albums
      allAlbums.value = [...ratedAlbums, ...pendingAlbums];
    } catch (e) {
      print('Error cargando albums del usuario: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para obtener albums por estado
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
}
