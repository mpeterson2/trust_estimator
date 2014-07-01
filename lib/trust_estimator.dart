library TrustEstimator;

import "dart:async";
import "dart:convert";
import "dart:io";
import "package:trust_estimator/github.dart" show GitHubOrg, GitHubRepo, GitHubUser, GitHub;
import "package:trust_estimator/database.dart";

part "trust_estimator/estimate.dart";
part "trust_estimator/trust.dart";

bool printInfo = false;
List<String> users = [];

void _print(Object object) {
  if(printInfo)
    print(object);
}

void printAllTrust() {
  for(var userA in allUsers) {
    print("\n$userA's Trust:");
    for(var userB in allUsers) {
      if(userA.login != userB.login) {
        var trust = getTrust(userA, userB);
        print("\t$userA trusts $userB $trust much.");
      }
    }
  }
}

Future saveAllTrust(Database db) {
  var waitFor = [];
  var trusts = [];
  
  for(var userA in allUsers) {
    for(var userB in allUsers) {
      if(userA.login != userB.login) {
        var trust = getTrust(userA, userB);
        trusts.add(trust);
      }
    }
  }
  
  var trustJson = trusts.map((t) => {"loginA": t.loginA, "loginB": t.loginB, "trust": t.trust});
  return new File("work.json").writeAsString(JSON.encode(trustJson.toList()));
}

List<GitHubUser> get allUsers => GitHub.users.values.toList()..sort((a, b) => a.login.toLowerCase().compareTo(b.login.toLowerCase()));

void empty() {
  bool oldPrintInfo = printInfo;
  printInfo = false;
  _print("");
  printInfo = oldPrintInfo;
}