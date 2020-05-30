import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdbclient/src/bloc/bloc.dart';
import 'package:tmdbclient/src/model/cast_model.dart';
import 'package:tmdbclient/src/resource/repository.dart';

class CastListBloc extends Bloc{

  int movieId;
  Repository _repository = Repository();
  PublishSubject _castListStreamController = PublishSubject<CastModel>();
  CastModel castModel;


  CastListBloc(this.movieId);

  Stream<CastModel> get castStream => _castListStreamController.stream;

  void fetchCastList() async{
    castModel = await _repository.fetchCastList(movieId);
    _castListStreamController.sink.add(castModel);

  }


  @override
  void dispose() {
   _castListStreamController.close();
  }

}
