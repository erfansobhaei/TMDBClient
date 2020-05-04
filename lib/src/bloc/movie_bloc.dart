import 'package:rxdart/rxdart.dart';
import 'package:tmdbclient/src/bloc/bloc.dart';
import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/resource/repository.dart';

class MovieBloc extends Bloc{

  Repository _repository = Repository();
  PublishSubject _movieStreamController = PublishSubject<ItemModel>();

  Stream<ItemModel> get movieStream => _movieStreamController.stream;

  fetchAllMovies() async{
    ItemModel itemModel = await _repository.fetchAllMovies();
    _movieStreamController.sink.add(itemModel);
  }


  @override
  void dispose() {
    _movieStreamController.close();
  }
}

final bloc = MovieBloc();