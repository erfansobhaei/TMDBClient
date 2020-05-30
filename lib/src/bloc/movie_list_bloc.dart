import 'package:rxdart/rxdart.dart';
import 'package:tmdbclient/src/bloc/bloc.dart';
import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/resource/repository.dart';

class MovieListBloc extends Bloc {
  Repository _repository = Repository();
  PublishSubject _movieStreamController = PublishSubject<ItemModel>();
  ItemModel allItems;

  Stream<ItemModel> get movieStream => _movieStreamController.stream;

  fetchAllMovies(int pageIndex) async {
    if (allItems == null) {
      allItems = await _repository.fetchAllMovies(1);
    } else {
      ItemModel itemModel = await _repository.fetchAllMovies(pageIndex);
      allItems.addItems(itemModel);
    }
    _movieStreamController.sink.add(allItems);
  }

  @override
  void dispose() {
    _movieStreamController.close();
  }
}

final bloc = MovieListBloc();
