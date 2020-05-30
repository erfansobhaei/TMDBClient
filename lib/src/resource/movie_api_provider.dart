import 'dart:convert';

import 'package:http/http.dart';
import 'package:tmdbclient/keys.dart';
import 'package:tmdbclient/src/model/cast_model.dart';
import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/model/trailer_model.dart';

class MovieApiProvider {
  final Client client = Client();
  static String _apiKey = api_key;
  final String _baseUrl = "https://api.themoviedb.org/3/movie/";

  Future<ItemModel> fetchMovieList(int pageIndex) async {
    final response = await client.get(_baseUrl + "popular?api_key=$_apiKey&page=$pageIndex&");

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch movies");
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    final response =
        await client.get(_baseUrl + "$movieId/videos?api_key=$_apiKey");
    if (response.statusCode == 200) {
      return TrailerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Faild to load trialers");
    }
  }

  Future<CastModel> fetchCastList(int movieId) async {
    final response = await client.get(_baseUrl + "$movieId/credits?api_key=$_apiKey");
    print(_baseUrl + "$movieId/credits?api_key=$_apiKey");

    if(response.statusCode == 200){
      return CastModel.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to fetch cast");
    }
  }
}
