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
  
  var logins = [];
  db.open()
  //.then((_) => db.clear())
  .then((_) => new File("../github-employees.json").readAsString().then((str) => logins = JSON.decode(str)))
  .then((_) => Trust.grabUsers(db, logins))
  //.then((_) => Trust.printAllTrust(db, users))
  .then((_) => Trust.printAllTrustAsJson(db, logins))
  .then((_) => shutdown(db));
}

void shutdown(Database db) {
  db.close();
  GitHub.client.close();
}