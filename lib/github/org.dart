part of Github;

class GitHubOrg {
  int id;
  String login;
  
  GitHubOrg();
  
  GitHubOrg.fromMap(Map map) {
    id = map["id"];
    login = map["login"];
  }
  
  factory GitHubOrg.fromJson(String json) {
    return new GitHubOrg.fromMap(JSON.decode(json));
  }
  
  static Future<List<GitHubOrg>> getOrgs(String url) {
    var com = new Completer();
    
    _get(url).then((res) {
      var orgs = []; 
      for(Map map in JSON.decode(res)) {
        var org = new GitHubOrg.fromMap(map);
        if(_orgs.containsKey(org.id)) {
          orgs.add(_orgs[org.id]);
        }
        else {
          _orgs[org.id] = org;
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