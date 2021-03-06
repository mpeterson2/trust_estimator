library Github;

import "dart:async";
import "dart:convert";
import "package:trust_estimator/http.dart";
import "package:intl/intl.dart";

part "github/org.dart";
part "github/repo.dart";
part "github/user.dart";


class GitHub {
  static final API = "https://api.github.com";
  static HttpClient client = new HttpClient()..rateLimit = rateLimit;
  static int requestsRemaining = 5000;
  static int requestsThisHour = 0;
  static int maxRequestsPerHour = 5000;
  static final DATEFORMAT = new DateFormat.jms();
  static String auth;

  static Future<String> _get(String url, {bypass: false}) {
    var com = new Completer();

    client.get(url, headers: {
      "Authorization": "token $auth"
    }, bypass: bypass).then((ret) {
      requestsRemaining--;
      requestsThisHour++;
      com.complete(ret);
    }).catchError((_) => rateLimit());

    return com.future;
  }

  static Future rateLimit() {
    return _get("$API/rate_limit", bypass: true)..then((str) {
          var json = JSON.decode(str);
          maxRequestsPerHour = json["resources"]["core"]["limit"];
          requestsRemaining = json["resources"]["core"]["remaining"];
          requestsThisHour = maxRequestsPerHour - requestsRemaining;
          client.requestsRemaining = requestsRemaining;
          var resetTime = json["resources"]["core"]["reset"];
          DateTime reset = new DateTime.fromMillisecondsSinceEpoch(resetTime * 1000, isUtc: true);
          reset = reset.toLocal();

          print("RATELIMIT: This hour: ${requestsThisHour}, Left: ${requestsRemaining}, Reset: ${DATEFORMAT.format(reset)}");
        });
  }

}
