import 'package:flutter/material.dart';
import 'package:newsapp/helper/news_api.dart';
import 'package:newsapp/utility/news_card.dart';

class NewsPageTechnology extends StatefulWidget {
  @override
  _NewsPageTechnologyState createState() => _NewsPageTechnologyState();
}

class _NewsPageTechnologyState extends State<NewsPageTechnology>
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
          future: getNewsDataByCategory(category: 'technology', cacheName: 'cacheTechnology'),
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
    String category = 'Technology';
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return kBuildListItemTopSideImg(articles[index], context, category);
      },
    );
  }

}
