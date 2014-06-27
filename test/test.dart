import "dart:io";
import "package:unittest/unittest.dart";
import "package:trust_calc/trust_from_file.dart" as Trust;
//import "package:trust_calc/data_gatherer.dart";

void main() {
  //gatherData(["mpeterson2", "dkuntz2"], new File("test.json"));
  
  test("", testCalc);
}

void testCalc() {
  Trust.readFromFile(new File("test.json"))
    ..then(expectAsync((var _) {
      var loginA = "mpeterson2";
      var loginB = "dkuntz2";
      var userA = Trust.users.where((u) => u.login == loginA).first;
      var userB = Trust.users.where((u) => u.login == loginB).first;
      expect(userA.login, loginA);
      expect(userB.login, loginB);
      
      Trust.calcTrust(userA, userB);
      expect(Trust.watchingTrust, 17);
      expect(Trust.followingTrust, 10);
      expect(Trust.starredTrust, 0);
      expect(Trust.orgTrust, 10);
      
      Trust.calcTrust(userB, userA);
      expect(Trust.watchingTrust, 8);
      expect(Trust.followingTrust, 10);
      expect(Trust.starredTrust, 0);
      expect(Trust.orgTrust, 10);
    }));
}