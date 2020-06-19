import 'dart:io';

import 'package:flutter_chopper_demo/models/db/dao.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName("ArticleEntity")
class ArticleEntities extends Table {
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get url => text()();
  TextColumn get urlToImage => text()();
  TextColumn get publishDate => text()();
  TextColumn get content => text()();

  @override
  Set<Column> get primaryKey => {url};
}

@UseMoor(tables: [ArticleEntities], daos: [NewsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'news.db'));
    return VmDatabase(file);
  });
}
