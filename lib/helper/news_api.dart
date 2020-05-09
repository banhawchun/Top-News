import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'internet_helper.dart';

Future<NewsApi> getNewsData({@required String cacheName}) async {
  String urlExplore = 'http://newsapi.org/v2/top-headlines?country=us&apiKey=526a3ca19b1548bdaea6aa95124b8cae';

  return readData(urlExplore, cacheName: cacheName);
}

Future<NewsApi> getNewsDataByCategory({@required String category,@required String cacheName}) async {
  /// Category name to load news by category,
  /// CacheName is to know which category to cache or else same news will be cache on different category
  String urlTechnology = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=526a3ca19b1548bdaea6aa95124b8cae';

  return readData(urlTechnology, cacheName: cacheName);
}

Future<NewsApi> readData(String url,{String cacheName}) async {
  if (await checkInternet() == true) {
    final http.Response response = await http.Client().get(url);
    if (response.statusCode == 200) {
      // has internet
//      print('has internet and saving $cacheName');
      saveCache(cacheName ,response.body);
      return compute(newsApiFromJson, response.body);
    } else {
      print('Internet on but error when reading API');
      throw Exception('Exception: Internet on but Error when reading API');
    }
  } else {
//    print('No Internet $cacheName'); // no internet
    if (await getCache(cacheName) == null) {
      // no cache
      print('No cache, error when reading API');
      throw Exception('Exception: Error when reading API');
    } else {
//      print('Read data from $cacheName');
      String cacheJsonCategory = await getCache(cacheName);
      return compute(newsApiFromJson, cacheJsonCategory);
    }
  }
}

Future<String> getCache(String cacheName) async {
  final prefs = await SharedPreferences.getInstance();
  final newsCache = prefs.getString(cacheName) ?? null;
  return newsCache;
}

Future saveCache(String cacheName, String jsonString,) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheName, jsonString);
}


NewsApi newsApiFromJson(String str) => NewsApi.fromMap(json.decode(str));

String newsApiToJson(NewsApi data) => json.encode(data.toMap());

class NewsApi {
  String status;
  int totalResults;
  List<Article> articles;

  NewsApi({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory NewsApi.fromMap(Map<String, dynamic> json) => NewsApi(
        status: json["status"],
        totalResults: json["totalResults"],
        articles:
            List<Article>.from(json["articles"].map((x) => Article.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toMap())),
      };
}

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromMap(Map<String, dynamic> json) => Article(
        source: Source.fromMap(json["source"]),
        author: json["author"] == null ? null : json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] == null ? null : json["content"],
      );

  Map<String, dynamic> toMap() => {
        "source": source.toMap(),
        "author": author == null ? null : author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content == null ? null : content,
      };
}

class Source {
  String id;
  String name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name,
      };
}
