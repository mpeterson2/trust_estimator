import "dart:io";
import "package:args/args.dart";
import "package:trust_estimator/data_gatherer.dart";
import "package:trust_estimator/trust_from_file.dart";
import "package:trust_estimator/github.dart" as GitHub;
import "github_auth.dart";

/**
 * Grabs data from the specified file, estimates trust, then prints it.
 */ 
void main(List<String> args) {
  // should be imported from `github_auth.dart.
  // See `github_auth.dart.example` for more info.
  GitHub.auth = auth;
  
  var argResults = parser.parse(args);
  
  var file = new File(argResults["file"]);

  var users = argResults.rest;
  if(users.isNotEmpty) {
    addUsersToFile(file, users).then(printTrust);
  }
  else {
    printTrust(file);
  }
}

ArgParser get parser {
  return new ArgParser(allowTrailingOptions: true)
    ..addFlag("help", abbr: "h", help: "Display this message.", defaultsTo: false, callback: showHelp)
    ..addOption("file", abbr: "f", help: "The file to store/pull GitHub data to/from", defaultsTo: "../test.json")
    ..addCommand("ratelimit");
}

void showHelp(bool h) {
  if(h) {
    print(parser.getUsage());
    print("\nrest\t\t   The new users to add to the estimation");
    exit(1);
  }
}