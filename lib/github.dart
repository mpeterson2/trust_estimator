library Github;

import "dart:async";
import "dart:convert";
import "package:trust_estimator/http.dart";
import "package:intl/intl.dart";

part "github/org.dart";
part "github/repo.dart";
part "github/user.dart";


class GitHub {
  static final API = "https://api.github.com";
  static HttpClient client = new HttpClient();
  static int requestsRemaining = 5000;
  static int requestsThisHour = 0;
  static int maxRequestsPerHour = 5000;
  static final DATEFORMAT = new DateFormat.jms();
  static String auth;
  
  static Map<String, GitHubUser> _users;
  static Map<int, GitHubOrg> _orgs;
  static Map<int, GitHubRepo> _repos;
  
  bool get _notSetup => _users == null;
  
  GitHub() {
    if(_notSetup) {
      _users = {};
      _orgs = {};
      _repos = {};
      client.rateLimit = rateLimit;
    }
  }
  
  void addUser(GitHubUser user) {
    _users[user.login] = user;
  }
  
  void removeUser(GitHubUser user) {
    _users.remove(user);
  }
  
  void addOrg(GitHubOrg org) {
    _orgs[org.id] = org;
  }
  
  void addRepo(GitHubRepo repo) {
    _repos[repo.id] = repo;
  }
  
  static Future<String> _get(String url, {bypass: false}) {
    var com = new Completer();

    client.get(url, headers: {"Authorization": "token $auth"}, bypass: bypass)
      .then((ret) {
        requestsRemaining--;
        requestsThisHour++;
        com.complete(ret);
      }).catchError((_) => rateLimit());
    
    return com.future;
  }
  
  static Future rateLimit() {    
    return _get("$API/rate_limit", bypass: true)
      ..then((str) {
        var json = JSON.decode(str);
        maxRequestsPerHour = json["resources"]["core"]["limit"];
        requestsRemaining = json["resources"]["core"]["remaining"];
        requestsThisHour = maxRequestsPerHour - requestsRemaining;
        client.requestsRemaining = requestsRemaining;
        var resetTime = json["resources"]["core"]["reset"];
        DateTime reset = new DateTime.fromMillisecondsSinceEpoch(resetTime * 1000, isUtc: true);
        reset = reset.toLocal();
  
        print("RATELIMIT: This hour: ${requestsThisHour}, Left: ${requestsRemaining}, Reset: ${DATEFORMAT.format(reset)}");
      });
  }

}