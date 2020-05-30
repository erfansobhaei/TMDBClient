import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tmdbclient/src/bloc/movie_list_bloc.dart';
import 'package:tmdbclient/src/bloc/movie_detail_bloc_provider.dart';
import 'package:tmdbclient/src/model/item_model.dart';
import 'package:tmdbclient/src/ui/movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.movieStream,
        builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildList(AsyncSnapshot<ItemModel> snapshot) {
    bool isLoading = false;
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          pageIndex++;
          print("go to $pageIndex");
          bloc.fetchAllMovies(pageIndex);
          //perform event
        }
      }
    });
    ItemModel itemModel = snapshot.data;
    String url = "https://image.tmdb.org/t/p/w500";

    return ListView.builder(
      controller: _scrollController,
      itemCount: itemModel.results.length,
      itemBuilder: (context, index) {
        String posterPath = itemModel.results[index].posterPath;
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Card(
                child: InkWell(
              onTap: () {
                _openDetailPage(itemModel, index);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      flex: 1,
                      child: Container(
                          child: CachedNetworkImage(
                            imageUrl: url + posterPath,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>  Icon(Icons.error),
                          ),)),
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            itemModel.results[index].title,
                            style: Theme.of(context).textTheme.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(
                            height: 8,
                          ),
                          Text(
                            itemModel.results[index].overview,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text("Release: " +
                              itemModel.results[index].releaseDate),
                          Text("%" +
                              itemModel.results[index].popularity.toString()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
          );
        }
      },
    );
  }

  _openDetailPage(ItemModel data, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
        child: MovieDetail(
          title: data.results[index].title,
          posterUrl: data.results[index].backdropPath,
          overview: data.results[index].overview,
          releaseDate: data.results[index].releaseDate,
          voteAverage: data.results[index].voteAverage.toString(),
          movieId: data.results[index].id,
        ),
      );
    }));
  }
}
