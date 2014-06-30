import "dart:io";
import "package:unittest/unittest.dart";
import "package:trust_estimator/trust_from_file.dart" as Trust;
import "package:trust_estimator/data_gatherer.dart";
import "package:trust_estimator/github.dart";
import "../bin/github_auth.dart";

void main() {
  GitHub.auth = auth;
  test("", testEstimation);
}

void testEstimation() {
  addUsersToFile(new File("test.json"), ["mpeterson2", "dkuntz2"])
    .then(Trust.readFromFile)
    .then(expectAsync((_) {
      var loginA = "mpeterson2";
      var loginB = "dkuntz2";
      var userA = Trust.users.where((u) => u.login == loginA).first;
      var userB = Trust.users.where((u) => u.login == loginB).first;
      expect(userA.login, loginA);
      expect(userB.login, loginB);
      
      Trust.estimateTrust(userA, userB);
      expect(Trust.watchingTrust, 17);
      expect(Trust.followingTrust, 10);
      expect(Trust.starredTrust, 0);
      expect(Trust.orgTrust, 10);
      
      Trust.estimateTrust(userB, userA);
      expect(Trust.watchingTrust, 8);
      expect(Trust.followingTrust, 10);
      expect(Trust.starredTrust, 0);
      expect(Trust.orgTrust, 10);
    }));
}