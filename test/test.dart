import "dart:async";
import "package:unittest/unittest.dart";
import "package:trust_estimator/trust_estimator.dart";
import "package:trust_estimator/github.dart";
import "package:trust_estimator/database.dart";
import "../bin/github_auth.dart";

Database database;

void main() {
  GitHub.auth = auth;
  group("tests", () {
    setUp(setupTest);
    tearDown(teardownTest);
    
    test("Test Estimation", testEstimation);
  });
}

Future setupTest() {
  print("Setup");
  new GitHub();
  database = new Database("trust-estimator-test");
  return database.open();
}

Future teardownTest() {
  GitHub.client.close();
  return database.close();
}

// TODO Rewrite test.
void testEstimation() {
  
  var logins = ["mpeterson2", "dkuntz2"];
  grabUsers(database, logins)
  .then((_) => database.users.getList(logins))
  .then((users) => setupUsers(database, users))
  .then((expectAsync((users) {
    var loginA = logins[0];
    var loginB = logins[1];
    
    var userA = users[0];
    var userB = users[1];

    expect(userA.login, loginA);
    expect(userB.login, loginB);
    
    var trustA = getTrust(userA, userB);
    expect(trustA.followingTrust, 10);
    expect(trustA.orgTrust, 10);
    expect(trustA.starredTrust, 0);
    expect(trustA.watchingTrust, 17);
    
    var trustB = getTrust(userB, userA);
    expect(trustB.followingTrust, 10);
    expect(trustB.orgTrust, 10);
    expect(trustB.starredTrust, 0);
    expect(trustB.watchingTrust, 8);
  })));
}