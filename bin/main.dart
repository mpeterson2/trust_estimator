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
  
  var users = argResults.rest;
  if(users.isEmpty) {
    users = ["mpeterson2", "dkuntz2"];
  }
  
  var file = new File(argResults["file"]);
  var overwrite = argResults["overwrite"];
  
  gatherData(users, file, overwrite: overwrite).then(printTrust);
}

ArgParser get parser {
  return new ArgParser(allowTrailingOptions: true)
    ..addFlag("help", abbr: "h", help: "Display this message.", defaultsTo: false, callback: showHelp)
    ..addFlag("overwrite", abbr: "o", help: "Forces downloading data and overwrite the file even if it exists.", defaultsTo: false)
    ..addOption("file", abbr: "f", help: "The file to store/pull GitHub data to/from", defaultsTo: "trust.json");
}

void showHelp(bool h) {
  if(h) {
    print(parser.getUsage());
    print("\nrest\t\t\tThe list of usernames to estimate trust");
    exit(1);
  }
}