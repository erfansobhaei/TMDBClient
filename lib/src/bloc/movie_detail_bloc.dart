import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tmdbclient/src/bloc/bloc.dart';
import 'package:tmdbclient/src/model/trailer_model.dart';
import 'package:tmdbclient/src/resource/repository.dart';

class MovieDetailBloc extends Bloc {
  final Repository _repository = Repository();
  final PublishSubject _movieId = PublishSubject<int>();
  final _trailers = BehaviorSubject<Future<TrailerModel>>();

  Function(int) get fetchTrailerById => _movieId.sink.add;

  Stream<Future<TrailerModel>> get movieTrailer => _trailers.stream;

  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
  }

  @override
  void dispose() async {
    _movieId.close();
    await _trailers.drain();
    _trailers.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Future<TrailerModel> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailer(id);
        return trailer;
      },
    );
  }
}
