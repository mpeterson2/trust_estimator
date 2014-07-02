library Database;

import "dart:async";
import "package:mongo_dart/mongo_dart.dart";
import "package:trust_estimator/github.dart";

part "database/org.dart";
part "database/repo.dart";
part "database/user.dart";

class Database {
  Db mongoDb;
  _UserDb users;
  _RepoDb repos;
  _OrgDb orgs;
  
  Database([String dbName="trust-estimator"]) {
    mongoDb = new Db("mongodb://127.0.0.1:27017/$dbName");
    users = new _UserDb(this);
    repos = new _RepoDb(this);
    orgs = new _OrgDb(this);
  }
  
  Future open() {
    return mongoDb.open();
  }
  
  Future close() {
    return mongoDb.close();
  }
  
  Future clear() {
    var waitFor = [users.clear(), repos.clear(), orgs.clear()];
    
    return Future.wait(waitFor);
  }
}

abstract class ObjectDb {
  Database db;
  DbCollection collection;
  ObjectDb(this.db);

  Future clear() => collection.drop();
  
  Cursor find([var selector]) => collection.find(selector);
  Future<Map> findOne([var selector]) => collection.findOne(selector);
}