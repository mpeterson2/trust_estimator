import "dart:async";
import "dart:io";
import "dart:convert";
import "package:trust_estimator/github.dart";
import "package:trust_estimator/database.dart";
import "package:trust_estimator/trust_estimator.dart" as Trust;
import "github_auth.dart";

void main() {
  GitHub.auth = auth;
  GitHub github = new GitHub();
  
  var db = new Database();
  
  db.open()
  //.then((_) => db.clear())
  .then((_) => grabUsers(db))
  .then((_) => db.repos.all().then((repos) => repos.forEach((repo) => github.addRepo(repo))))
  .then((_) => db.users.all().then((users) => users.forEach((user) => github.addUser(user))))
  .then((_) => db.orgs.all().then((orgs) => orgs.forEach((org) => github.addOrg(org))))
  .then((_) => Trust.saveAllTrust(db))
  .then((_) => shutdown(db));
}

Future grabUsers(Database db) {
  var waitFor = [];
  
  var file = new File("../github-employees.json");
  var fileStr = file.readAsStringSync();
  var usersJson = JSON.decode(fileStr);
  
  for(var login in usersJson) {
    var existsFuture = db.users.exists(login);
    waitFor.add(grabUserAndInsert(login, db));
  }
  
  return Future.wait(waitFor);
}

Future grabUserAndInsert(String login, Database db) {
  var com = new Completer();
  
  db.users.exists(login).then((exists) {
    if(exists) {
      com.complete();
    }
    
    else {
      var waitFor = [];
      GitHubUser.getUser(login).then((user) {
        user.getMoreInfo().then((_) {
          db.users.insert(user);
          user.starredRepos.forEach((r) => waitFor.add(db.repos.insert(r)));
          user.watchingRepos.forEach((r) => waitFor.add(db.repos.insert(r)));
          user.orgs.forEach((o) => waitFor.add(db.orgs.insert(o)));
          
          Future.wait(waitFor).then((_) => com.complete());
        });
      });
    }
  });
  
  return com.future;
}

void shutdown(Database db) {
  print("Shutting Down");
  db.close();
  GitHub.client.close();
}