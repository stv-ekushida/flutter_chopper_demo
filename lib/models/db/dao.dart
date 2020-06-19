import 'package:moor/moor.dart';
import 'package:flutter_chopper_demo/models/db/database.dart';

part 'dao.g.dart';

@UseDao(tables: [ArticleEntities])
class NewsDao extends DatabaseAccessor<AppDatabase> with _$NewsDaoMixin {
  NewsDao(AppDatabase db) : super(db);

  Future clearDB() => delete(articleEntities).go();

  Future insertDB(List<ArticleEntity> articles) async {
    await batch((batch) {
      batch.insertAll(articleEntities, articles);
    });
  }

  Future<List<ArticleEntity>> get articleFromDB =>
      select(articleEntities).get();

  Future<List<ArticleEntity>> insertAndReadNewsFromDB(
          List<ArticleEntity> articles) =>
      transaction(() async {
        await clearDB();
        await insertDB(articles);
        return await articleFromDB;
      });
}
