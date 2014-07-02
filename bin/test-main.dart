import "dart:async";
import "dart:io";
import "dart:convert";
import "package:args/args.dart";
import "package:trust_estimator/github.dart";
import "package:trust_estimator/database.dart";
import "package:trust_estimator/trust_estimator.dart" as Trust;
import "github_auth.dart";

void main(List<String> rawArgs) {
  GitHub.auth = auth;
  GitHub github = new GitHub();
  var db = new Database();
  
  var args = parser.parse(rawArgs);
  
  var file = null;
  if(args["users"] != null) {
    file = new File(args["users"]);
  }
  
  var format = args["format"];
  var clearDb = args["clear-db"];
  var logins = args.rest.toList();
  
  db.open()
  .then((_) => maybeClearDb(db, clearDb))
  .then((_) => getLoginsFromFile(file).then((fileLogins) => logins.addAll(fileLogins)))
  .then((_) => Trust.grabUsers(db, logins))
  .then((_) => printTrust(format, db, logins))
  .then((_) => shutdown(db));
}

Future maybeClearDb(Database db, bool clearDb) {
  if(clearDb)
    return db.clear();
  
  var com = new Completer()..complete();
  return com.future;
}

Future printTrust(String format, Database db, List<String> logins) {
  if(format == "readable")
    return Trust.printAllTrust(db, logins);
  else
    return Trust.printAllTrustAsJson(db, logins);
}

Future<List<String>> getLoginsFromFile(File file) {
  var com = new Completer();
  if(file == null) {
    com.complete([]);
    return com.future;
  }
  
  file.readAsString().then((str) => com.complete(JSON.decode(str)));
  
  return com.future;
}

void shutdown(Database db) {
  db.close();
  GitHub.client.close();
}

ArgParser get parser {
  return new ArgParser(allowTrailingOptions: true)
    ..addFlag("help", abbr: "h", help: "Display this message.", defaultsTo: false, callback: showHelp)
    ..addFlag("rate-limit", abbr: "r", help: "Display GitHub rate limit info.", defaultsTo: false, callback: showRateLimit)
    ..addFlag("clear-db", abbr: "c", help: "Clear the database", defaultsTo: false)
    ..addOption("users", abbr: "u", help: "Specify a json list of users from a file.", defaultsTo: null)
    ..addOption("format", abbr: "f", help: "Specify the output format", allowed: ["json", "readable"], defaultsTo: "readable");
}

void showHelp(bool h) {
  if(h) {
    print(parser.getUsage());
    print("\nrest\t\t\t The new users to add to the estimation");
    exit(0);
  }
}

void showRateLimit(bool r) {
  if(r) {
    GitHub.rateLimit().then((_) {
      GitHub.client.close();
      exit(0);
    });
  }
}