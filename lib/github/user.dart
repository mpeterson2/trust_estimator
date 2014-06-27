part of Github;

class GitHubUser {
  static List<GitHubUser> allUsers;
  String login, name, email, company, location;
  String followersUrl, followingUrl, starredUrl, organizationsUrl, reposUrl, watchingUrl;
  List<GitHubUser> following, followers;
  List<GitHubOrg> orgs;
  List<GitHubRepo> starredRepos, watchingRepos;
  
  GitHubUser();
  
  GitHubUser.fromMap(Map user) {
    login = user["login"];
    name = user["name"];
    email = user["email"];
    company = user["company"];
    location = user["location"];
    
    followersUrl = user["followers_url"];
    
    followingUrl = user["following_url"];
    if(followersUrl != null)
      followingUrl = followingUrl.substring(0, followingUrl.indexOf("{"));
    
    watchingUrl = user["subscriptions_url"];
    
    starredUrl = user["starred_url"];
    if(starredUrl != null)
      starredUrl = starredUrl.substring(0, starredUrl.indexOf("{"));
    
    organizationsUrl = user["organizations_url"];
    reposUrl = user["repos_url"];
  }
  
  factory GitHubUser.fromJson(String json) {
    return new GitHubUser.fromMap(JSON.decode(json));
  }
  
  Future getMoreInfo() {
    List<Future> waitFor = [];
    waitFor.add(_getFollowers());
    waitFor.add(_getFollowing());
    waitFor.add(_getOrgs());
    waitFor.add(_getStarredRepos());
    waitFor.add(_getWatchingRepos());
    
    return Future.wait(waitFor);
  }
  
  Future<List<GitHubUser>> _getFollowing() {
    return _getPeople(followingUrl)
        ..then((users) => following = users);
  }
  
  Future<List<GitHubUser>> _getFollowers() {
    return _getPeople(followersUrl)
        ..then((users) => followers = users);
  }
  
  Future<List<GitHubOrg>> _getOrgs() {
    return GitHubOrg.getOrgs(organizationsUrl)
        ..then((orgs) => this.orgs = orgs);
  }
  
  Future<List<GitHubRepo>> _getStarredRepos() {
    return GitHubRepo.getRepos(starredUrl)
        ..then((repos) => starredRepos = repos);
  }
  
  Future<List<GitHubRepo>> _getWatchingRepos() {
    return GitHubRepo.getRepos(watchingUrl)
        ..then((repos) => watchingRepos = repos);
  }
  
  static Future<List<GitHubUser>> _getPeople(String url) {
    var waitFor = [];
    var com = new Completer();
    
    _get(url).then((res) {
      var users = new List();
      
      for(var map in JSON.decode(res)) {
        waitFor.add(getUser(map["login"]));
      }
      
      Future.wait(waitFor).then((users) {
        com.complete(users);
      });
    });
    
    return com.future;
  }
  
  static Future<List<GitHubUser>> getAllUserLogins() {
    var com = new Completer();
    if(allUsers != null)
    {
      com.complete(allUsers);
      return com;
    } 
    else {
      return _getPeople("$API/users")
          ..then((users) => allUsers = users);
    }
  }
  
  static Future<GitHubUser> getUser(String login) {
    Completer com = new Completer();
    
    if(_users.containsKey(login)) {
      com.complete(_users[login]);
    }
    
    else {
      _get("$API/users/$login").then((res) {
        if(!JSON.decode(res).containsKey("login")) {
          rateLimit();
          client.end();
        }
        
        else {
          GitHubUser user = new GitHubUser.fromJson(res);
          _users[user.login] = user;
          com.complete(_users[user.login]);
        }
      });
    }
    
    return com.future;
  }
  
  String toString() {
    return login;
  }
}