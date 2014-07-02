part of Database;

class _UserDb extends ObjectDb {
  
  _UserDb(Database db) : super(db) {
    collection = new DbCollection(db.mongoDb, "users");
  }
  
  Future insert(GitHubUser user) {
    return collection.insert(userToMap(user));
  }
  
  Future<GitHubUser> get(String login) {
    var com = new Completer();
    
    collection.findOne({"login": "$login"})
      .then((map) {
        if(map == null)
          com.complete();
        else
          com.complete(new GitHubUser.fromMap(map));
    });
    
    return com.future;
  }
  
  Future<List<GitHubUser>> getList(List<String> logins) {
    var com = new Completer();
    
    var users = [];
    collection.find(where.oneFrom("login", logins))
      .forEach((map) => users.add(new GitHubUser.fromMap(map)))
      .whenComplete(() => com.complete(users));
    
    return com.future;
  }
  
  Future<bool> exists(String login) {
    var com = new Completer();
    
    get(login).then((org) {
      com.complete(org != null);
    });
    
    return com.future;
  }
  
  Future<List<GitHubUser>> getN(int start, {int n: 10}) {
    var com = new Completer();
    
    var users = [];
    collection.find(where.skip(start).limit(10))
      .forEach((map) => users.add(new GitHubUser.fromMap(map)))
      .whenComplete(() => com.complete(users));
    
    return com.future;
  }
  
  Future<List<GitHubUser>> all() {
    var com = new Completer();
    
    var users = [];
    find()
      .forEach((map) => users.add(new GitHubUser.fromMap(map)))
      .whenComplete(() => com.complete(users));
    
    return com.future;
  }
  
  Map userToMap(GitHubUser user) {
    var orgs = user.orgs.map((org) => org.id).toList();
    var followers = user.followers.map((u) => u.login).toList();
    var following = user.following.map((u) => u.login).toList();
    var stars = user.starredRepos.map((r) => r.id).toList();
    var watch = user.watchingRepos.map((r) => r.id).toList();
  
    Map userMap = {
      "login": user.login,
      "name": user.name,
      "email": user.email,
      "orgs": orgs,
      "followers": followers,
      "following": following,
      "stars": stars,
      "watch": watch
    };
    
    return userMap;
  }
  
  GitHubUser mapToUser(Map user) {
    return new GitHubUser.fromMap(user);
  }
}