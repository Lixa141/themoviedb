import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/domain/factories/screen_factory.dart';
import 'package:flutter_themoviedb/widgets/movie_list/movie_list__model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  static final _screenFactory = ScreenFactory();
  int _selectedTab = 0;
  final movieListModel = MovieListViewModel();

  void onSelectedTab(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
    }
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
          _screenFactory.makeMovieList(),
          _screenFactory.makeNews(),
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
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
