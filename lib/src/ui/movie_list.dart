
import 'package:flutter/material.dart';
import 'package:tmdbclient/src/bloc/movie_bloc.dart';
import 'package:tmdbclient/src/model/item_model.dart';


class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  @override
  void initState() {
    bloc.fetchAllMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.movieStream,
        builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot ){
          if(snapshot.hasData){
            return _buildList(snapshot);
          }
          else if(snapshot.hasError){
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

  Widget _buildList(AsyncSnapshot<ItemModel> snapshot){
    ItemModel itemModel = snapshot.data;
    String url = "https://image.tmdb.org/t/p/w500";

    return ListView.builder(
      itemCount: itemModel.results.length,
      itemBuilder: (context, index){
        String posterPath = itemModel.results[index].poster_path;
        return Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Container(
                  child: Image.network(posterPath != null ? url + posterPath : "", fit: BoxFit.fitHeight,))),
              Flexible(
                flex: 2,
                child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(itemModel.results[index].title, style: Theme.of(context).textTheme.title,),
                    Divider(),
                    Text(itemModel.results[index].overview, overflow: TextOverflow.ellipsis, maxLines: 4,),
                    Divider(),
                    Text("Release: " + itemModel.results[index].release_date),
                    Text("%" + itemModel.results[index].popularity.toString()),



                  ],
                ),
              ),)
            ],
          )
        );
      },
    );
  }
}