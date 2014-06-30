part of Github;

class GitHubOrg {
  GitHub gitHub;
  int id;
  String login;
  
  GitHubOrg();
  
  GitHubOrg.fromMap(Map map) {
    id = map["id"];
    login = map["login"];
    gitHub = new GitHub();
  }
  
  factory GitHubOrg.fromJson(String json) {
    return new GitHubOrg.fromMap(JSON.decode(json));
  }
  
  static Future<List<GitHubOrg>> getOrgs(String url) {
    var com = new Completer();
    
    GitHub._get(url).then((res) {
      var orgs = []; 
      for(Map map in JSON.decode(res)) {
        var org = new GitHubOrg.fromMap(map);
        if(GitHub._orgs.containsKey(org.id)) {
          orgs.add(GitHub._orgs[org.id]);
        }
        else {
          GitHub._orgs[org.id] = org;
          orgs.add(org);
        }
      }
      
      com.complete(orgs);
    });
    
    return com.future;
  }
  
  String toString() {
    return "$login ($id)";
  }
}