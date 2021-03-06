import 'package:tmdbclient/src/model/cast_model.dart';
import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/model/trailer_model.dart';
import 'package:tmdbclient/src/resource/movie_api_provider.dart';

class Repository {
  final MovieApiProvider provider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies(int pageIndex) =>
      provider.fetchMovieList(pageIndex);

  Future<TrailerModel> fetchTrailer(int movieId) =>
      provider.fetchTrailer(movieId);

  Future<CastModel> fetchCastList(int movieId) =>
      provider.fetchCastList(movieId);
}
