import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tmdbclient/src/bloc/cast_list_bloc.dart';
import 'package:tmdbclient/src/bloc/movie_detail_bloc.dart';
import 'package:tmdbclient/src/bloc/movie_detail_bloc_provider.dart';
import 'package:tmdbclient/src/model/cast_model.dart';
import 'package:tmdbclient/src/model/trailer_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetail extends StatefulWidget {
  final posterUrl;
  final overview;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail({
    this.title,
    this.posterUrl,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  State<StatefulWidget> createState() {
    return MovieDetailState(
      title: title,
      posterUrl: posterUrl,
      overview: overview,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      movieId: movieId,
    );
  }
}

class MovieDetailState extends State<MovieDetail> {
  final posterUrl;
  final overview;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;
  MovieDetailBloc movieBloc;
  CastListBloc castListBloc;
  YoutubePlayerController controller;

  MovieDetailState({
    this.title,
    this.posterUrl,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  void didChangeDependencies() {
    movieBloc = MovieDetailBlocProvider.of(context);
    movieBloc.fetchTrailerById(movieId);
    castListBloc = CastListBloc(movieId);
    castListBloc.fetchCastList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: true,
                pinned: false,
                elevation: 10.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                  "https://image.tmdb.org/t/p/w500$posterUrl",
                  fit: BoxFit.cover,
                )),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child:
                        Text(title, style: Theme.of(context).textTheme.title),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        voteAverage.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        releaseDate,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(overview),
                  Divider(
                    height: 40,
                  ),
                  Text(
                    "Trailers",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: movieBloc.trailerStream,
                    builder: (context,
                        AsyncSnapshot<Future<TrailerModel>> snapshot) {
                      if (snapshot.hasData) {
                        return FutureBuilder(
                          future: snapshot.data,
                          builder:
                              (context, AsyncSnapshot<TrailerModel> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.results.length > 0) {
                                return SizedBox(
                                    height: 250,
                                    child: _trailerLayout(snapshot.data));
                              } else {
                                return _noTrailerLayout();
                              }
                            } else {
                              return Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Divider(
                    height: 40,
                  ),
                  Text(
                    "Cast",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: castListBloc.castStream,
                    builder: (context, AsyncSnapshot<CastModel> snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                            height: 250, child: _buildCastList(snapshot.data));
                      } else if (snapshot.hasError) {
                        print("there");
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    movieBloc.dispose();
    super.dispose();
  }

  Widget _noTrailerLayout() {
    return Center(
      child: Text("No trailers"),
    );
  }

  Widget _trailerLayout(TrailerModel data) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: data.results.length,
      itemBuilder: (context, index) {
        Result result = data.results[index];
        YoutubePlayerController controller = YoutubePlayerController(
          initialVideoId: result.key,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width * (3 / 4),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  result.name,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                            "https://img.youtube.com/vi/${result.key}/sddefault.jpg"),
                      ),
                      GestureDetector(
                        child: Image.asset("images/play_button.png"),
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  backgroundColor: Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: YoutubePlayer(
                                      thumbnailUrl:
                                          "https://img.youtube.com/vi/${result.key}/sddefault.jpg",
                                      bottomActions: <Widget>[],
                                      showVideoProgressIndicator: true,
                                      controller: controller,
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCastList(CastModel data) {
    String url = "https://image.tmdb.org/t/p/original";
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: data.cast.length,
      itemBuilder: (context, index) {
        print(MediaQuery.of(context).size.width / 2);
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width/ 2.5,
            padding: EdgeInsets.all( 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: data.cast[index].profile_path != null ? CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: url + data.cast[index].profile_path ,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>  Icon(Icons.error),
                  ):
                  Icon(Icons.person, size: 128,),
                ),
                Text(data.cast[index].name, overflow: TextOverflow.fade,softWrap: true, textAlign: TextAlign.center,),
                Text(data.cast[index].character, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
              ],
            ),
          ),
        );
      },
    );
  }
}
