import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  final String title;
  final posterUrl;
  final overview;
  final release;
  final String voteAverage;
  final int movieId;

  MovieDetail(
      {this.posterUrl,
      this.overview,
      this.release,
      this.title,
      this.voteAverage,
      this.movieId});

  @override
  _MovieDetailState createState() => _MovieDetailState(
    title: title,
    posterUrl: posterUrl,
    overview: overview,
    release: release,
    voteAverage: voteAverage,
    movieId: movieId
  );
}

class _MovieDetailState extends State<MovieDetail> {

  final posterUrl;
  final overview;
  final release;
  final String title;
  final String voteAverage;
  final int movieId;

  _MovieDetailState({this.posterUrl,
  this.overview,
  this.release,
  this.title,
  this.voteAverage,
  this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled){
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(background: Image.network(
                    "https://image.tmdb.org/t/p/w500$posterUrl",
                  fit: BoxFit.cover,
                ),),
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.0, right: 1.0),
                    ),
                    Text(
                      voteAverage,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    Text(
                      release,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(overview),
                  ],
                ),
            ),
          ),
        ),
      );
  }
}
