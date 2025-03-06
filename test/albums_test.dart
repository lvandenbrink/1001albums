import 'package:albums/models/album.dart';
import 'package:albums/models/settings.dart';
import 'package:albums/models/sort.dart';
import 'package:albums/screens/albums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Albums View Tests', () {
    testWidgets('Should render', (tester) async {
      List<Album> albums = [
        anAlbum(
          artist: 'Muddy Waters',
          albumTitle: 'The Anthology, 1947-1972',
        )
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AlbumsPage(
            isLoading: false,
            albums: albums,
            updateListened: (Album album, bool listened) {},
            updateRating: (Album album, double rating) {},
            settings: Settings(0, Sort.album, true, true, true, true),
            updateSettings: updateSettings,
          ),
        ),
      ));

      expect(find.text('Muddy Waters'), findsOneWidget);
      expect(find.text('The Anthology, 1947-1972'), findsOneWidget);
    });

    testWidgets('Should change and callback listened', (tester) async {
      bool listenedClicked = false;

      List<Album> albums = [anAlbum(listened: true)];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AlbumsPage(
            isLoading: false,
            albums: albums,
            updateListened: (Album album, bool listened) {
              listenedClicked = true;
            },
            updateRating: (Album album, double rating) {},
            settings: Settings(0, Sort.artist, true, true, true, true),
            updateSettings: updateSettings,
          ),
        ),
      ));

      var checkBoxFinder = find.byType(Checkbox);

      expect(tester.widget<Checkbox>(checkBoxFinder).value, true);

      await tester.tap(checkBoxFinder);
      await tester.pump();

      expect(listenedClicked, true);
    });
  });
}

void updateSettings({
  Sort? sort,
  bool? sortAscending,
  bool? showListened,
  bool? show1001Albums,
  bool? showRollingStones,
}) {}

Album anAlbum({
  String artist = 'U2',
  String albumTitle = "All That You Can't Leave Behind",
  bool listened = false,
}) {
  return Album(
    1,
    'Both lists',
    artist,
    albumTitle,
    '2000',
    '139',
    '53:12:52',
    'Island',
    'Brian Eno / Daniel Lanois',
    'Steve Averill',
    'Ireland / UK',
    listened,
    null,
  );
}
