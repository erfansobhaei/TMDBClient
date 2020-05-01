import 'package:rxdart/rxdart.dart';
import 'package:tmdbclient/src/bloc/bloc.dart';
import 'package:tmdbclient/src/model/ItemModel.dart';
import 'package:tmdbclient/src/resource/repository.dart';

class MovieBloc extends Bloc{
  Repository _repository = Repository();

  final _movieFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allMovies => _movieFetcher.stream;

  fetchAllMovies() async{
    ItemModel itemModel = await _repository.fetchAllMovies();
    _movieFetcher.sink.add(itemModel);
  }


  @override
  void dispose() {
    _movieFetcher.close();
  }
}

final bloc = MovieBloc();