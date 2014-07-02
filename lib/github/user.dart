part of Github;

class GitHubUser {
  GitHub gitHub;
  static List<GitHubUser> allUsers;
  String login, name, email, company, location;
  String followersUrl, followingUrl, starredUrl, organizationsUrl, reposUrl, watchingUrl;
  List<GitHubUser> following, followers;
  List<GitHubOrg> orgs;
  List<GitHubRepo> starredRepos, watchingRepos;
  
  GitHubUser() {
    gitHub = new GitHub();
  }
  
  GitHubUser.fromMap(Map user) {
    gitHub = new GitHub();
    
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
    
    if(user["followers"] is List) {
      followers = user["followers"].map((l) => new GitHubUser()..login = l).toList();
    }
    
    if(user["following"] is List) {
      following = user["following"].map((l) => new GitHubUser()..login = l).toList();
    }
    
    if(user["orgs"] is List) {
      orgs = user["orgs"].map((id) => new GitHubOrg()..id = id).toList();
    }
    
    if(user["stars"] is List) {
      starredRepos = user["stars"].map((id) => new GitHubRepo()..id = id).toList();
    }
    
    if(user["watch"] is List) {
      watchingRepos = user["watch"].map((id) => new GitHubRepo()..id = id).toList();
    }
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
    
    GitHub._get(url).then((res) {
      var users = new List();
      
      for(var map in JSON.decode(res)) {
        users.add(new GitHubUser()..login = map["login"]);
      }
      
      com.complete(users);
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
      return _getPeople("${GitHub.API}/users")
          ..then((users) => allUsers = users);
    }
  }
  
  static Future<GitHubUser> getUser(String login) {
    Completer com = new Completer();
    
    GitHub._get("${GitHub.API}/users/$login").then((res) {
      GitHubUser user = new GitHubUser.fromJson(res);      
      
      com.complete(user);
    });
    
    return com.future;
  }
  
  String toString() {
    return login;
  }
}