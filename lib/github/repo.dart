part of Github;

class GitHubRepo {
  GitHub gitHub;
  int id;
  String name;
  String ownerLogin;

  GitHubRepo() {
    gitHub = new GitHub();
  }
  
  GitHubRepo.fromMap(Map map) {
    id = map["id"];
    if(id == null)
      id = map["repoId"];
    
    name = map["name"];
    if(map["owner"] is Map)
      ownerLogin = map["owner"]["login"];
    else
      ownerLogin = map["owner"];
    
    gitHub = new GitHub();
  }

  static Future<List<GitHubRepo>> getRepos(String url) {
    var com = new Completer();

    GitHub._get(url).then((res) {
      var repos = [];
      var waitFor = [];

      for (var map in JSON.decode(res)) {
        repos.add(new GitHubRepo.fromMap(map));
      }

      Future.wait(waitFor).then((_) => com.complete(repos));
    });

    return com.future;
  }

  String toString() {
    return "$name - ($id)";
  }
}
