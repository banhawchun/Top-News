import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:newsapp/helper/news_api.dart';
import 'package:newsapp/utility/constant.dart';
import 'package:newsapp/utility/news_card.dart';
import 'package:newsapp/utility/news_content.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPage extends StatefulWidget {
  final Article article;
  final String category;

  DetailPage({this.article, this.category});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  bool _isNoBorderFavIcon = true;
  bool _isNoBorderBookmarkIcon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildListView(List<Article> articles) {
    String category = 'General';
    return ListView.builder(
      itemCount: articles.length - 12,
      itemBuilder: (context, index) {
        return kBuildListItem(articles[index], context, category);
      },
    );
  }

  _buildSliverAppBar() {
    return SliverAppBar(
//            title: Text('Details'),
//            textTheme: TextTheme(title: TextStyle(color: Colors.white, fontSize: 18)),
      expandedHeight: 320,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 12, 0),
          child: IconButton(
            onPressed: (){},
            icon: Icon(Icons.share),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: '${widget.article.urlToImage.toString()}',
          imageBuilder: (context, imageProvider) =>
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
          placeholder: (context, url) =>
              CachedNetworkImage(
                imageUrl:
                'https://i0.wp.com/frankmedilink.in/wp-content/uploads/2017/02/no-preview-big.jpg',
              ),
        ),
      ),
    );
  }

  _buildSliverList() {
    String content = widget.article.content;
    String description = widget.article.description;
    var publishDate = widget.article.publishedAt;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          // Everything is in this container after image
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // News Category, bookmark and favorite icon
                Row(
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      color: Colors.grey[350],
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.5,
                            bottom: 5.5,
                            left: 12.8,
                            right: 12.8),
                        child: Text(
                          widget.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: GFColors.DARK,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Use this to push icon to the end
                    Expanded(child: SizedBox()),
                    // Bookmark icon
                    IconButton(
                      icon: Icon(_isNoBorderBookmarkIcon
                          ? Icons.bookmark_border
                          : Icons.bookmark,),
                      onPressed: () {
                        setState(() {
                          _isNoBorderBookmarkIcon =
                          !_isNoBorderBookmarkIcon;
                        });
                      },
                    ),
                    SizedBox(width: 5,),
                    // Favorite icon
                    IconButton(
                      icon: Icon(
                        _isNoBorderFavIcon ? Icons.favorite_border : Icons
                            .favorite,
                        color: _isNoBorderFavIcon ? Colors.black : Colors
                            .red,),
                      onPressed: () {
                        setState(() {
                          _isNoBorderFavIcon = !_isNoBorderFavIcon;
                        });
                      },
                    ),
                    SizedBox(width: 5,),
                  ],
                ),
                SizedBox(height: 15,),
                // Article Published Date
                Row(
                  children: <Widget>[
                    SizedBox(width: 4,),
                    // Published Date icon
                    Icon(
                      Icons.timer,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 5,),
                    // Published Date
                    Text(
                      '${Jiffy(publishDate).format('dd MMMM - yyyy')}',
                      style: kNewsDetailDateTextStyle,
                    ),
                  ],
                ),
                // Article Title
                Padding(
                  padding: const EdgeInsets.only(left: 7, top: 5),
                  child: Text(
                    '${widget.article.title}',
                    style: kNewsDetailTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    width: 120,
                    height: 4,
                    child: Container(color: Colors.blue,),
                  ),
                ),
                // Article Description
                Padding(
                  padding: const EdgeInsets.only(
                      left: 7, top: 20, right: 10),
                  child: Text(
                      description == null
                          ? 'Description Not Available'
                          : '$description',
                    style: kNewsDetailDescriptionTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
                // Article Content
                Padding(
                  padding: const EdgeInsets.only(
                      left: 7, top: 20, right: 10),
                  child: Text(
                    content == null
                        ? 'Content Not Available'
                        : '${content.substring(
                        0, content.length - 15)}...',
                    style: kNewsDetailDescriptionTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            padding: EdgeInsets.all(10),
          ),
          // You Might Also Like
          Padding(
            padding: const EdgeInsets.only(left: 17, top: 50, bottom: 10),
            child: Text(
              'You Might Also Like',
              style: kNewsDetailSuggestArticleTextStyle,
            ),
          ),
          // Suggested Article
          Container(
            color: Colors.grey[200],
            height: 300,
            child: FutureBuilder<NewsApi>(
              future: getNewsDataByCategory(cacheName: 'cacheDetail', category: 'general'),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text('Something went wrong!'),
                  );
                else {
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    return _buildListView(snapshot.data.articles);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _buildBody() {
    return Center(
      child: CustomScrollView(
        slivers: <Widget>[
          // App bar that allows pic to expand over
          _buildSliverAppBar(),

          // News content as a SliverList
          _buildSliverList(),
        ],
      ),
    );
  }
}
