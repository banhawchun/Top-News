import 'package:flutter/material.dart';
import 'package:newsapp/helper/news_api.dart';
import 'package:newsapp/utility/news_card.dart';

class NewsPageEntertainment extends StatefulWidget {
  @override
  _NewsPageEntertainmentState createState() => _NewsPageEntertainmentState();
}

class _NewsPageEntertainmentState extends State<NewsPageEntertainment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Container(
        color: Colors.grey[200],
        child: FutureBuilder<NewsApi>(
          future: getNewsDataByCategory(category: 'entertainment', cacheName: 'cacheEntertainment'),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text('Something went wrong!'),
              );
            else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildListView(snapshot.data.articles);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }

  _buildListView(List<Article> articles) {
    String category = 'Entertainment';
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return kBuildListItemTopSideImg(articles[index], context, category);
      },
    );
  }

}
