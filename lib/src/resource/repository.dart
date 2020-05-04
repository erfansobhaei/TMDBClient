import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/model/trailer_model.dart';
import 'package:tmdbclient/src/resource/movie_api_provider.dart';

class Repository{
  final MovieApiProvider provider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => provider.fetchMovieList();
  Future<TrailerModel> fetchTrailer(int movieId) => provider.fetchTrailer(movieId);
}