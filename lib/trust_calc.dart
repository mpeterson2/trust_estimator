library TrustCalc;

import "dart:async";
import "package:trust_calc/github.dart" show GitHubOrg, GitHubRepo, GitHubUser;
import "package:trust_calc/github.dart" as GitHub;

part "trust_calc/calc.dart";

bool printInfo = false;
List<String> users = [];

void _print(Object object) {
  if(printInfo)
    print(object);
}

/**
 * Calculates trust of [loginA] for [loginB]
 *  
 */ 
Future<int> calculateTrust(GitHubUser userA, GitHubUser userB) {
  Completer com = new Completer();
  
  var trust = 0;
  
  userA.getMoreInfo().then((_) {
    userB.getMoreInfo().then((_) {
      
      trust += getFollowingTrust(userA, userB);
      trust += getOrgTrust(userA, userB);
      trust += getStarredTrust(userA, userB);
      trust += getWatchingTrust(userA, userB);
      
      com.complete(trust);
    });
  });
  
  return com.future;
}


Future<int> calcuateAndPrintTrust(String loginA, String loginB) {
  var com = new Completer();
  
  GitHubUser.getUser(loginA).then((userA) {
    GitHubUser.getUser(loginB).then((userB) {
      calculateTrust(userA, userB).then((trust) {
        
        print("$loginA trusts $loginB: $trust much");
        
        com.complete(trust);
        
      });
    });
  });
  
  return com.future;
}


void calcAndPrintTrusts() {
  var waitFor = [];
  GitHub.rateLimit();
  
  for(var userA in users) {
    for(var userB in users) {
      if(userA != userB) {
        waitFor.add(calcuateAndPrintTrust(userA, userB));
      }
    }
  }
  
  
  Future.wait(waitFor).then((_) {
    GitHub.rateLimit().then((_) => GitHub.client.end());
  });
}