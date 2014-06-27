import "dart:io";
import "package:trust_estimator/data_gatherer.dart";
import "package:trust_estimator/trust_from_file.dart";
import "package:trust_estimator/github.dart" as GitHub;
import "github_auth.dart";

var users = ["pjhyett", "mojombo", "defunkt", "m"];
//var users = ["mpeterson2", "dkuntz2"];

/**
 * Grabs data from the specified file, estimates trust, then prints it.
 */ 
void main() {
  // should be imported from `github_auth.dart.
  // See `github_auth.dart.example` for more info.
  GitHub.auth = auth;
  
  gatherData(users, new File("trust.json")).then(printTrust);
}