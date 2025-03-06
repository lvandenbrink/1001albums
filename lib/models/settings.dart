import 'package:albums/models/sort.dart';

class Settings {
  final int contentVersion;
  Sort sort;
  bool sortAscending;
  bool showListened;
  bool show1001Albums;
  bool showRollingStones;

  Settings(
    this.contentVersion,
    this.sort,
    this.sortAscending,
    this.showListened,
    this.show1001Albums,
    this.showRollingStones,
  );

  @override
  String toString() {
    return 'settings=[sort=$sort, ascending=$sortAscending, listened=$showListened, 1001albums=$show1001Albums, rollingStones=$showRollingStones, version=$contentVersion]';
  }
}
