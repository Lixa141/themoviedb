import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/library/widgets/inherited/provider.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list__model.dart';
import 'package:flutter_themoviedb/widgets/news/news.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();

  void onSelectedTab(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: const MovieList(),
          ),
          const News(),
          // const Text(
          //   'TV Shows',
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation), label: 'Films'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Logout',
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.movie_creation), label: 'Films'),
          // BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Shows'),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
