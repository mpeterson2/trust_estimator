part of Database;

class _OrgDb extends ObjectDb {
  _OrgDb(Database db) : super(db) {
    collection = new DbCollection(db.mongoDb, "orgs");
  }
  
  Future insert(GitHubOrg org) {
    return collection.insert({"orgId": org.id, "login": org.login});
  }
  
  Future<GitHubOrg> get(int id) {
    var com = new Completer();
    
    findOne({"orgId": id}).then((map) {
      if(map == null)
        com.complete();
      else
        com.complete(new GitHubOrg.fromMap(map));
    });
    
    return com.future;
  }
  
  Future<bool> exists(int id) {
    var com = new Completer();
    
    get(id).then((org) {
      com.complete(org != null);
    });
    
    return com.future;
  }
  
  Future<List<GitHubOrg>> all() {
    var com = new Completer();
    
    var orgs = [];
    find()
      .forEach((map) => orgs.add(new GitHubOrg.fromMap(map)))
      .whenComplete(() => com.complete(orgs));
    
    return com.future;
  }
}









