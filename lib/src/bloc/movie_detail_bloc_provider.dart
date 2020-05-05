import 'package:flutter/material.dart';
import 'package:tmdbclient/src/bloc/movie_detail_bloc.dart';

class MovieDetailBlocProvider extends InheritedWidget {
  final MovieDetailBloc bloc;

  MovieDetailBlocProvider({Key key, Widget child})
      : bloc = MovieDetailBloc(),
        super(key: key, child: child);

  static MovieDetailBloc of(BuildContext context) {
    // ignore: deprecated_member_use
    return (context.inheritFromWidgetOfExactType(MovieDetailBlocProvider)
            as MovieDetailBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(_) {
    return true;
  }
}
