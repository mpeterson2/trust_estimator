library TrustEstimator;

import "dart:async";
import "dart:convert";
import "package:trust_estimator/github.dart" show GitHubOrg, GitHubRepo, GitHubUser, GitHub;
import "package:trust_estimator/database.dart";

part "trust_estimator/estimate.dart";
part "trust_estimator/trust.dart";

Future printAllTrust(Database db, List<String> logins) {
  var com = new Completer();
  
  db.users.getList(logins).then((incompleteUsers) {
    setupUsers(db, incompleteUsers).then((users) {
      for(var userA in users) {
        print("\n$userA's Trust:");
        for(var userB in users) {
          if(userA.login != userB.login) {
            var trust = getTrust(userA, userB);
            print("\t$trust");
          }
        }
      }
      
      com.complete();
    });
  });
  
  return com.future;
}

Future printAllTrustAsJson(Database db, List<String> logins) {
  var com = new Completer();
  
  db.users.getList(logins).then((incompleteUsers) {
    setupUsers(db, incompleteUsers).then((users) {
      var trustMap = {};
      
      for(var userA in users) {
        var userAMap = {};
        for(var userB in users) {
          if(userA.login != userB.login) {
            var trust = getTrust(userA, userB);
            userAMap[userB.login] = trust.toMap();
          }
        }
        trustMap[userA.login] = userAMap;
      }
      
      print(JSON.encode(trustMap));
      
      com.complete();
    });
  });
  
  return com.future;
}

Future<List<GitHubUser>> setupUsers(Database db, List<GitHubUser> users) {
  var com = new Completer();

  var waitFor = [];
  for(var user in users) {
    for(var repo in user.starredRepos) {
      waitFor.add(db.repos.get(repo.id)..then((r) => _fillInRepo(repo, r)));
    }
    for(var repo in user.watchingRepos) {
      waitFor.add(db.repos.get(repo.id)..then((r) => _fillInRepo(repo, r)));
    }
  }
    
  Future.wait(waitFor)
    .then((_) => com.complete(users
        ..sort((a, b) => a.login.toLowerCase().compareTo(b.login.toLowerCase()))));
  
  return com.future;
}

void _fillInRepo(GitHubRepo toFill, GitHubRepo full) {
  toFill..name = full.name
        ..ownerLogin = full.ownerLogin;
}

Future grabUsers(Database db, List<String> users) {
  var waitFor = [];
  for(var login in users) {
    waitFor.add(grabUserAndSave(login, db));
  }
  
  return Future.wait(waitFor);
}

Future grabUserAndSave(String login, Database db) {
  var com = new Completer();
  
  db.users.exists(login).then((exists) {
    if(exists) {
      com.complete();
    }
    
    else {
      var waitFor = [];
      GitHubUser.getUser(login).then((user) {
        user.getMoreInfo().then((_) {
          waitFor.add(db.users.insert(user));
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

/**
 * This does "nothing".
 * 
 * For some reason, a method breaks if I do not call a method in it.
 * I think it has to be a print, so I just disable printing for a second,
 * print nothing, and reenable it if it was enabled.
 */ 
void empty() {
  bool oldPrintInfo = _falsey;
  _falsey = false;
  if(_falsey) print("");
  _falsey = oldPrintInfo;
}
bool _falsey = false;