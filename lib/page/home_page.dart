import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/page/news_entertainment.dart';
import 'package:newsapp/page/news_health.dart';
import 'package:newsapp/page/news_science.dart';
import 'package:newsapp/page/news_sports.dart';
import 'package:newsapp/utility/constant.dart';
import 'news_explore.dart';
import 'news_technology.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsPageExplore _newsPageExplore = NewsPageExplore();
  NewsPageTechnology _newsPageTechnology = NewsPageTechnology();
  NewsPageHealth _newsPageHealth = NewsPageHealth();
  NewsPageSports _newsPageSports = NewsPageSports();
  NewsPageEntertainment _newsPageEntertainment = NewsPageEntertainment();
  NewsPageScience _newsPageScience = NewsPageScience();
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Explore'),
    Tab(text: 'Technology'),
    Tab(text: 'Health'),
    Tab(text: 'Sports'),
    Tab(text: 'Entertainment'),
    Tab(text: 'Science'),
  ];



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(),
        body: _buildBody(),
      ),
    );
  }

  _buildAppBar(context) {
    return AppBar(
      bottom: TabBar(
        isScrollable: true,
        tabs: myTabs,
      ),
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: Image.asset('asset/images/menu.png'),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Top',
            style: kAppBarTitle1Style,
          ),
          SizedBox(width: 2),
          Text(
            'News',
            style: kAppBarTitle2Style,
          )
        ],
      ),
      titleSpacing: 3,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.notifications_none),
          padding: EdgeInsets.only(right: 2),
          onPressed: () {},
        ),
      ],
    );
  }

  _buildDrawer() {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[500],
                    Colors.purple[300],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        'https://i7.pngguru.com/preview/159/439/738/avatar-twitch-youtube-character-avatar.jpg'),
                    radius: 29,
                  ),
                  title: Text(
                    'Demaze',
                    style: kNameTextStyle,
                  ),
                  subtitle: Text(
                    'demaze@gmail.com',
                    style: kEmailTextStyle,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.category,
                  size: 25,
                ),
                title: Text('Categories'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.bookmark,
                  size: 25,
                ),
                title: Text('Bookmark'),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.new_releases,
                  size: 25,
                ),
                title: Text('About'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBody() {
    return TabBarView(
      children: <Widget>[
        _newsPageExplore,
        _newsPageTechnology,
        _newsPageHealth,
        _newsPageSports,
        _newsPageEntertainment,
        _newsPageScience,
      ],
    );
  }
}
