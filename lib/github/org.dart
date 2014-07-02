part of Github;

class GitHubOrg {
  GitHub gitHub;
  int id;
  String login;
  
  GitHubOrg();
  
  GitHubOrg.fromMap(Map map) {
    id = map["id"];
    if(id == null)
      id = map["orgId"];
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
        orgs.add(new GitHubOrg.fromMap(map));
      }
      
      com.complete(orgs);
    });
    
    return com.future;
  }
  
  String toString() {
    return "$login ($id)";
  }
}