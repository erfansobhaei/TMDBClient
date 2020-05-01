
import 'package:flutter/material.dart';
import 'package:tmdbclient/src/bloc/movie_bloc.dart';
import 'package:tmdbclient/src/model/item_model.dart';


class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
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

  Widget _buildList(AsyncSnapshot<ItemModel> snapshot){
    ItemModel itemModel = snapshot.data;
    String url = "https://image.tmdb.org/t/p/w500";

    return GridView.builder(
        itemCount: itemModel.results.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index){
          return Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(url + "${itemModel.results[index].poster_path}",
                  fit: BoxFit.fill,),
                ),
                Text(itemModel.results[index].title ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                ),),
              ],
            ),
          );
        }
    );
  }
}