import 'package:albums/models/album.dart';
import 'package:albums/models/settings.dart';
import 'package:albums/models/sort.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import 'about.dart';
import 'album.dart';
import 'loading.dart';

class AlbumsPage extends StatelessWidget {
  final bool isLoading;
  final Iterable<Album>? albums;
  final Function(Album, bool) updateListened;
  final Function(Album, double) updateRating;
  final Settings settings;
  final Function({
    bool? show1001Albums,
    bool? showListened,
    bool? showRollingStones,
    Sort? sort,
    bool? sortAscending,
  }) updateSettings;

  final ScrollController _controller = ScrollController();

  AlbumsPage({
    super.key,
    required this.isLoading,
    required this.albums,
    required this.updateListened,
    required this.updateRating,
    required this.settings,
    required this.updateSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1001 Albums'),
      ),
      body: isLoading || albums == null ? const LoadingView() : albumsView(),
      drawer: _menuDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _filterMenu(context),
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget albumsView() {
    return DraggableScrollbar.semicircle(
      labelTextBuilder: (offset) {
        if (!_controller.hasClients) {
          return const Text('');
        }
        int currentIndex = (_controller.offset /
                _controller.position.maxScrollExtent *
                (albums!.length - 1))
            .floor();
        return Text(_scrollHint(currentIndex));
      },
      controller: _controller,
      child: ListView.builder(
        controller: _controller,
        itemCount: albums!.length,
        itemExtent: 65,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(albums!.elementAt(index).albumTitle),
            subtitle: Text(albums!.elementAt(index).artist),
            leading: Checkbox(
              visualDensity: VisualDensity.compact,
              value: albums!.elementAt(index).listened,
              onChanged: (checked) {
                updateListened(albums!.elementAt(index), checked ?? false);
              },
            ),
            visualDensity: VisualDensity.compact,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            onTap: () => _navigateAlbum(context, albums!.elementAt(index)),
          );
        },
      ),
    );
  }

  void _navigateAlbum(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumPage(
          album: album,
          updateListened: updateListened,
          updateRating: updateRating,
        ),
      ),
    );
  }

  String _scrollHint(int currentIndex) {
    switch (settings.sort) {
      case Sort.artist:
        return albums!.elementAt(currentIndex).artist.substring(0, 1);
      case Sort.year:
        var year = albums!.elementAt(currentIndex).releaseDate;
        return year.isNotEmpty ? year : '--';
      case Sort.rating:
        return '${albums!.elementAt(currentIndex).rating}';
      case Sort.ranking:
        var stoneRank = albums!.elementAt(currentIndex).rollingStoneRank;
        return stoneRank.isNotEmpty ? stoneRank : '--';
      case Sort.album:
        return albums!.elementAt(currentIndex).albumTitle.substring(0, 1);
    }
  }

  void _filterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Column(
          children: <Widget>[
            ListTile(
              title: const Text('Sort albums by'),
              trailing: DropdownButton<Sort>(
                value: settings.sort,
                onChanged: (Sort? value) {
                  if (value != null) {
                    updateSettings(sort: value);
                    Navigator.pop(context);
                  }
                },
                items: Sort.values.map<DropdownMenuItem<Sort>>((Sort value) {
                  return DropdownMenuItem<Sort>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text('Sort albums ascending'),
              trailing: Switch(
                value: settings.sortAscending,
                onChanged: (checked) {
                  updateSettings(sortAscending: checked);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Show listened'),
              trailing: Switch(
                value: settings.showListened,
                onChanged: (checked) {
                  updateSettings(showListened: checked);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Show only in 1001 Albums'),
              trailing: Switch(
                value: settings.show1001Albums,
                onChanged: (checked) {
                  updateSettings(show1001Albums: checked);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Show only in Rolling Stone 500'),
              trailing: Switch(
                value: settings.showRollingStones,
                onChanged: (checked) {
                  updateSettings(showRollingStones: checked);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Drawer _menuDrawer(BuildContext context) {
    var headerChild = DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Text(
        '',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.white),
      ),
    );

    return Drawer(
      child: ListView(
        children: [
          headerChild,
          _menuItem(context, Icons.info, 'About', AboutPage.routeName),
          const Divider(),
        ],
      ),
    );
  }

  ListTile _menuItem(
      BuildContext context, IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(routeName);
      },
    );
  }
}
