library TrustFromFile;

import "dart:async";
import "dart:io";
import "dart:convert";
import "package:trust_estimator/github.dart";
import "package:trust_estimator/trust_estimator.dart" as Trust;

List<GitHubUser> users = [];
Map<String, GitHubOrg> orgs = {};
Map<String, GitHubRepo> repos = {};
int watchingTrust;
int followingTrust;
int starredTrust;
int orgTrust;

Future printTrust(File file) {
  return readFromFile(file)..then((_) {
    _printTrust();
  });
}

Future readFromFile(File file) {
  file.createSync();
  return file.readAsString()..then((str) {
    if(str.isEmpty) return;
    List userList = JSON.decode(str);
    for(var userJson in userList) {
      var user = new GitHubUser.fromMap(userJson);
      
      user.orgs = new List();
      user.followers = userJson["followers"].map((str) => new GitHubUser()..login = str).toList();
      user.following = userJson["following"].map((str) => new GitHubUser()..login = str).toList();
      user.starredRepos = new List();
      user.watchingRepos = new List();
      
      for(var org in userJson["orgs"]) {
        orgs[org] = new GitHubOrg()..login = org;
        user.orgs.add(orgs[org]);
      }
      
      for(var map in userJson["stars"]) {
        GitHubRepo repo = new GitHubRepo()
          ..name = map["name"]
          ..owner = (new GitHubUser()..login = map["owner"])
          ..id = map["id"];
        repos[repo.name] = repo;
        user.starredRepos.add(repo);
      }
      
      for(var map in userJson["watch"]) {
        GitHubRepo repo = new GitHubRepo()
          ..name = map["name"]
          ..owner = (new GitHubUser()..login = map["owner"])
          ..id = map["id"];
        repos[repo.name] = repo;
        user.watchingRepos.add(repo);
      }
      
      users.add(user);
      
    }
  });
}


void _printTrust() {
  Trust.printInfo = true;
  
  for(var uA in users) {
    print("____$uA's Trust____");
    for(var uB in users) {
      if(uA.login != uB.login) {
        print("\n$uA's trust in $uB:");
        var trust = estimateTrust(uA, uB);
        print("\tTotal trust:    $trust");
      }
    }
    print("\n");
  }
}


int estimateTrust(GitHubUser uA, GitHubUser uB) {
  var trust = 0;
  followingTrust = Trust.getFollowingTrust(uA, uB);
  orgTrust = Trust.getOrgTrust(uA, uB);
  starredTrust = Trust.getStarredTrust(uA, uB);
  watchingTrust = Trust.getWatchingTrust(uA, uB);
  
  trust += followingTrust;
  trust += orgTrust;
  trust += starredTrust;
  trust += watchingTrust;
  
  return trust;
}



