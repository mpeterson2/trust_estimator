part of Github;

class GitHubRepo {
  GitHub gitHub;
  int id;
  String name;
  String ownerLogin;
  GitHubUser owner;

  GitHubRepo() {
    gitHub = new GitHub();
  }
  
  GitHubRepo.fromMap(Map map) {
    id = map["id"];
    name = map["name"];
    ownerLogin = map["owner"]["login"];
    gitHub = new GitHub();
  }

  Future getMoreInfo() {
    var waitFor = [];

    waitFor.add(_getOwner());

    return Future.wait(waitFor);
  }

  Future<GitHubUser> _getOwner() {
    return GitHubUser.getUser(ownerLogin)..then((user) => owner = user);
  }

  static Future<List<GitHubRepo>> getRepos(String url) {
    var com = new Completer();

    GitHub._get(url).then((res) {
      var repos = [];
      var waitFor = [];

      for (var map in JSON.decode(res)) {
        var repo = new GitHubRepo.fromMap(map);
        if (GitHub._repos.containsKey(repo.id)) {
          repos.add(GitHub._repos[repo.id]);
        } else {
          repos.add(repo);
          waitFor.add(repo.getMoreInfo());
        }
      }

      Future.wait(waitFor).then((_) => com.complete(repos));
    });

    return com.future;
  }

  String toString() {
    return "$name - ${owner.name}";
  }
}
