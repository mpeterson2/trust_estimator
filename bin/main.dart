import "dart:io";
import "package:trust_calc/data_gatherer.dart";
import "package:trust_calc/trust_from_file.dart";
import "package:trust_calc/github.dart" as GitHub;
import "github_auth.dart";

var users = ["pjhyett", "mojombo", "defunkt", "m"];
//var users = ["mpeterson2", "dkuntz2"];

/**
 * Grabs data from the specified file, estimates trust, then prints it.
 */ 
void main() {
  // should be imported from `github_auth.dart.
  // The format should be: "token [authCode]"
  GitHub.auth = auth;
  
  gatherData(users, new File("trust.json")).then(printTrust);
}