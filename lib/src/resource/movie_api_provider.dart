import 'dart:convert';

import 'package:http/http.dart';
import 'package:tmdbclient/keys.dart';
import 'package:tmdbclient/src/model/ItemModel.dart';
class MovieApiProvider{
  final Client client = Client();
  static String _api_key = api_key;
  final String url = "http://api.themoviedb.org/3/movie/popular?api_key=$_api_key";

  Future<ItemModel> fetchMovieList() async{
    final respnose = await client.get(url);

    if(respnose.statusCode == 200){
      return ItemModel.fromJson(json.decode(respnose.body));
    }
    else{
      throw Exception("Faild to fetch movies");
    }
  }
}