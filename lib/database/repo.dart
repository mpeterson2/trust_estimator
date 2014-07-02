part of Database;

class _RepoDb extends ObjectDb {
  _RepoDb(Database db) : super(db) {
    collection = new DbCollection(db.mongoDb, "repos");
  }
  
  Future insert(GitHubRepo repo) {
    return collection.insert({"repoId": repo.id, "name": repo.name, "owner": repo.ownerLogin});
  }
  
  Future<GitHubRepo> get(int id) {
    var com = new Completer();
    collection.findOne({"repoId": id})
      .then((map) {
        if(map == null)
          com.complete();
        else
          com.complete(new GitHubRepo.fromMap(map));
      });
    
    return com.future;
  }
  
  Future<bool> exists(int id) {
    var com = new Completer();
    
    get(id).then((repo) {
      com.complete(repo != null);
    });
    
    return com.future;
  }
  
  Future<List<GitHubRepo>> all() {
    var com = new Completer();
    
    var repos = [];
    find()
      .forEach((map) => repos.add(new GitHubRepo.fromMap(map)))
      .whenComplete(() => com.complete(repos));
    
    return com.future;
  }
}