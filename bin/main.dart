import "dart:convert";
import "dart:io";
import "package:args/args.dart";
import "package:trust_estimator/data_gatherer.dart";
import "package:trust_estimator/trust_from_file.dart";
import "package:trust_estimator/github.dart";
import "github_auth.dart";

/**
 * Grabs data from the specified file, estimates trust, then prints it.
 */ 
void main(List<String> args) {
  // should be imported from `github_auth.dart.
  // See `github_auth.dart.example` for more info.
  GitHub.auth = auth;
  new GitHub();
  var argResults = parser.parse(args);
  
  var file = new File(argResults["file"]);
  
  var users = [];
  var usersFromFile = argResults["users"];
  if(usersFromFile != null) {
    String jsonList = new File(usersFromFile).readAsStringSync();
    users.addAll(JSON.decode(jsonList));
  }
  
  users.addAll(argResults.rest);
  
  addUsersToFile(file, users).then(printTrust);
}

ArgParser get parser {
  return new ArgParser(allowTrailingOptions: true)
    ..addFlag("help", abbr: "h", help: "Display this message.", defaultsTo: false, callback: showHelp)
    ..addOption("file", abbr: "f", help: "The file to store/pull GitHub data to/from", defaultsTo: "bin/trust.json")
    ..addOption("users", abbr: "u", help: "Specify a json list of users from a file.", defaultsTo: null)
    ..addFlag("rate-limit", abbr: "r", help: "Display GitHub rate limit info", defaultsTo: false, callback: showRateLimit);
}

void showHelp(bool h) {
  if(h) {
    print(parser.getUsage());
    print("\nrest\t\t\t The new users to add to the estimation");
    exit(1);
  }
}

void showRateLimit(bool r) {
  if(r) {
    GitHub.rateLimit().then((_) {
      GitHub.client.end();
      exit(1);
    });
  }
}