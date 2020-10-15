import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:newsapp/helper/news_api.dart';
import 'package:newsapp/page/detail_page.dart';
import 'package:newsapp/utility/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget _buildArticleTitleAndDescription(Article article, String category) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Article Title
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              article.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: kNewsTitleTextStyle,
            ),
          ),
          SizedBox(height: 5),

          // Article category Text
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            color: Colors.grey[700],
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: Text(
                category,
                style: kNewsCategoryNameTextStyle,
              ),
            ),
          ),

          // Article Source's Image, Source, and date
          Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 4, left: 3, right: 8),
            child: Row(
              children: <Widget>[
                // Article Source's Image
                CachedNetworkImage(
                  imageUrl: '${article.urlToImage}',
                  imageBuilder: (context, imageProvider) => Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl:
                        'https://prestotype.com/prestotype/assets/No_Image_Available-0b31166fa63c54cbc95a4aeb46846021.gif',
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(width: 5),
                // Article Source's name + Date
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      article.source.id == null
                          ? 'Unknown - ${timeago.format(article.publishedAt)}'
                          : '${article.source.id.toUpperCase()} - ${timeago.format(article.publishedAt)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: kNewsSourceTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildArticleImage(Article article,
    {double imageWidth = 95, double imageHeight = 105}) {
  // Article Image
  return Padding(
    padding: const EdgeInsets.only(right: 8, left: 8),
    child: CachedNetworkImage(
      imageUrl: '${article.urlToImage}',
      imageBuilder: (context, imageProvider) => Container(
        height: imageHeight,
        width: imageWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => CachedNetworkImage(
        imageUrl:
            'https://prestotype.com/prestotype/assets/No_Image_Available-0b31166fa63c54cbc95a4aeb46846021.gif',
        width: 90,
        height: 95,
      ),
    ),
  );
  // This one use ImageProvider so can't get placeholder and show blank when image fetch from api failed
  /*Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(article.urlToImage),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );*/
}

List<Widget> _buildChildren(
    String imageSide, Article article, String category) {
  // build the card depend on imageSide, default is right side
  if (imageSide == 'right') {
    return <Widget>[
      _buildArticleTitleAndDescription(article, category),
      _buildArticleImage(article)
    ];
  } else if (imageSide == 'left') {
    return <Widget>[
      _buildArticleImage(article),
      _buildArticleTitleAndDescription(article, category)
    ];
  } else {
    return <Widget>[
      _buildArticleTitleAndDescription(article, category),
      _buildArticleImage(article)
    ];
  }
}

void _onTapContent(BuildContext context, Article article, String category) {
  // Press the Article card push to show detail
//  Navigator.of(context).push(
//    MaterialPageRoute(
//      builder: (build) => DetailPage(
//        article: article,
//        category: category,
//      ),
//    ),
//  );
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (build) => DetailPage(
          article: article,
          category: category,
        ),
      ));
}

/// Image side require String 'left' or 'right' in lowercase. The default one is right side
///
/// Category is the name of the news category that is currently viewing.
kBuildListItem(Article article, BuildContext context, String category,
    {String imageSide = 'right'}) {
  // Body of the card
  return Container(
    padding: EdgeInsets.all(5),
    height: 170,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {
          _onTapContent(context, article, category);
        },
        child: Row(
          children: _buildChildren(imageSide, article, category),
        ),
      ),
    ),
  );
}

kBuildListItemTopSideImg(
    Article article, BuildContext context, String category) {
  Widget _buildArticleSource() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: <Widget>[
          // Article Source's Image
          CachedNetworkImage(
            imageUrl: '${article.urlToImage}',
            imageBuilder: (context, imageProvider) => Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CachedNetworkImage(
              imageUrl:
                  'https://prestotype.com/prestotype/assets/No_Image_Available-0b31166fa63c54cbc95a4aeb46846021.gif',
              width: 20,
              height: 20,
            ),
          ),
          SizedBox(width: 5),
          // Article Source's name and Date
          Text(
            article.source.id == null
                ? 'Unknown - ${timeago.format(article.publishedAt)}'
                : '${article.source.id.toUpperCase()} - ${timeago.format(article.publishedAt)}',
            style: kNewsSourceTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    if (article.description == null || article.description == '') {
      return Column(
        children: <Widget>[
          // Article Description
          Text(
            'Description not found',
            style: kNewsSubTitleTopImgTextStyle,
          ),
          // Article Source, Image, date
          _buildArticleSource(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Article Description
          Text(
            article.description,
            style: kNewsSubTitleTopImgTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Article Source, Image, date
          _buildArticleSource(),
        ],
      );
    }
  }

  Widget _buildTitle() {
    return GFListTile(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(3, 9, 3, 10),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            article.title,
            style: kNewsTitleTopImgTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subTitle: _buildSubtitle());
  }

  Image _buildImage() {
    return Image(
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      image: CachedNetworkImageProvider(
        article.urlToImage == null
            ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRs0I6bqtE68WLQwZy2wC5rrmzmFkAV1Kl0M562ywbIqYVyFv3W&usqp=CAU'
            : article.urlToImage,
      ),
    );
  }

  return InkWell(
    onTap: () {
      _onTapContent(context, article, category);
    },
    child: GFCard(
      image: _buildImage(),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(1),
      title: _buildTitle(),
    ),
  );
}
