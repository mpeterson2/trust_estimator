library GithubDataGather;

import "dart:async";
import "dart:convert";
import "dart:io";
import "package:trust_estimator/github.dart";

int _numUsers = 0;

/**
 * Gathers data from GitHub.
 * 
 * bool overwrite: use this to gather data if the file aleady exists. Default: false. 
 */ 
Future<File> gatherData(List users, File fileToSave, {bool overwrite: false}) {
  if(!overwrite && fileToSave.existsSync()) {
    var com = new Completer();
    com.complete(fileToSave);
    return com.future;
  }
  
  List json = [];

  for (var login in users) {
    GitHubUser.getUser(login).then((user) {
      user.getMoreInfo().then((_) {

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

        json.add(userMap);

        _numUsers++;
      });
    });
  }

  return _startTimer(json, users.length, fileToSave);
}

Future<File> _startTimer(List json, int totalusers, File file) {
  var com = new Completer();

  new Timer.periodic(new Duration(seconds: 1), (timer) {
    if (_numUsers == totalusers) {
      timer.cancel();

      file.create().then((file) {
        String str = JSON.encode(json);
        file.writeAsString(str).then((file) => com.complete(file));
      });
    }
  });

  return com.future;
}
