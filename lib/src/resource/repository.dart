import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/resource/movie_api_provider.dart';

class Repository{
  final MovieApiProvider provider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => provider.fetchMovieList();
}