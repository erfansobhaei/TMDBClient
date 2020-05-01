import 'package:tmdbclient/src/model/ItemModel.dart';
import 'package:tmdbclient/src/resource/movie_api_provider.dart';

class Repository{
  final MovieApiProvider provider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => provider.fetchMovieList();
}