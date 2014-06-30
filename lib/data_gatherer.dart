library GithubDataGather;

import "dart:async";
import "dart:convert";
import "dart:io";
import "package:trust_estimator/trust_from_file.dart";
import "package:trust_estimator/github.dart" hide client;
import "package:trust_estimator/github.dart" as GitHub show client;

Map userToMap(GitHubUser user) {
  var orgs = user.orgs.map((org) => org.login).toList();
  var followers = user.followers.map((u) => u.login).toList();
  var following = user.following.map((u) => u.login).toList();
  var stars = user.starredRepos.map((r) => {
    "name": r.name,
    "owner": r.owner.login,
    "id": r.id
  }).toList();
  var watch = user.watchingRepos.map((r) => {
    "name": r.name,
    "owner": r.owner.login,
    "id": r.id
  }).toList();

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

Future<String> addUserToFile(File file, String login) {
  var com = new Completer();
  readFromFile(file).then((_) {
    GitHubUser.getUser(login).then((user) {
      user.getMoreInfo().then((_) {
        com.complete(userToMap(user));
      });
    });
  });
  
  return com.future;
}

Future<File> addUsersToFile(File file, List<String> logins) {
  var com = new Completer();
  var waitFor = [];
  
  readFromFile(file).then((_) {
    for(var login in logins) {
      if(!users.any((u) => u.login == login)) {
        waitFor.add(addUserToFile(file, login));
      }
    }
    
    Future.wait(waitFor).then((newUsers) {
      GitHub.client.end();
      var allUsers = newUsers.toList();
      for(var user in users) {
        allUsers.add(userToMap(user));
      }
      
      com.complete(file.writeAsString(JSON.encode(allUsers)));
    });
  });
  
  return com.future;
}