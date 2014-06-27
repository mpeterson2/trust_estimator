library Github;

import "dart:async";
import "dart:convert";
import "package:trust_calc/http.dart";
import "package:intl/intl.dart";

part "github/org.dart";
part "github/repo.dart";
part "github/user.dart";

final API = "https://api.github.com";
String auth;

Map<String, GitHubUser> _users = {};
Map<int, GitHubOrg> _orgs = {};
Map<int, GitHubRepo> _repos = {};
HttpClient client = new HttpClient();
int requestsRemaining = 5000;
int requestsThisHour = 0;
int maxRequestsPerHour = 5000;
final DATEFORMAT = new DateFormat.jms();

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

Future<String> _get(String url) {
  return client.get(url, headers: {
    "Authorization": auth
  })..then((_) {
        requestsRemaining--;
        requestsThisHour++;
        //print("REQUESTS: remaining: $requestsRemaining, made: $requestsThisHour");
      }).catchError((_) => rateLimit());
}

Future<String> rateLimit() {
  return _get("$API/rate_limit")..then((str) {
        var json = JSON.decode(str);
        maxRequestsPerHour = json["resources"]["core"]["limit"];
        requestsRemaining = json["resources"]["core"]["remaining"];
        requestsThisHour = maxRequestsPerHour - requestsRemaining;
        var resetTime = json["resources"]["core"]["reset"];
        DateTime reset = new DateTime.fromMillisecondsSinceEpoch(resetTime * 1000, isUtc: true);
        reset = reset.toLocal();

        print("RATELIMIT: This hour: ${requestsThisHour}, Left: ${requestsRemaining}, Reset: ${DATEFORMAT.format(reset)}");
      });
}
