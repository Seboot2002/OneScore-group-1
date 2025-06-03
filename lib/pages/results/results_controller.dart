import 'package:get/get.dart';
import '../../models/entities/album.dart';
import '../../models/entities/artist.dart';
import '../../models/entities/user.dart';

class ResultsController extends GetxController {
  List<dynamic> results = [];
  String searchType = '';
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final arguments = Get.arguments;
    if (arguments != null) {
      results = arguments['results'] ?? [];
      searchType = arguments['searchType'] ?? '';
      searchQuery = arguments['searchQuery'] ?? '';

      print("🔍 Tipo de búsqueda: $searchType");
      print("📝 Query de búsqueda: $searchQuery");
      print("📦 Cantidad de resultados: ${results.length}");
    }
  }

  String get displaySearchType {
    switch (searchType) {
      case 'Albums':
        return 'Álbumes';
      case 'Artistas':
        return 'Artistas';
      case 'Usuarios':
        return 'Usuarios';
      case 'Todos':
        return 'Todos los resultados';
      default:
        return searchType;
    }
  }

  List<Album> get albumResults {
    if (searchType == 'Todos') {
      return results
          .where((item) => item['type'] == 'album')
          .map((item) => item['data'] as Album)
          .toList();
    } else if (searchType == 'Albums') {
      return results.cast<Album>();
    }
    return [];
  }

  List<Artist> get artistResults {
    if (searchType == 'Todos') {
      return results
          .where((item) => item['type'] == 'artist')
          .map((item) => item['data'] as Artist)
          .toList();
    } else if (searchType == 'Artistas') {
      return results.cast<Artist>();
    }
    return [];
  }

  List<User> get userResults {
    if (searchType == 'Todos') {
      return results
          .where((item) => item['type'] == 'user')
          .map((item) => item['data'] as User)
          .toList();
    } else if (searchType == 'Usuarios') {
      return results.cast<User>();
    }
    return [];
  }

  bool get hasResults => results.isNotEmpty;

  int get totalResults => results.length;
}
