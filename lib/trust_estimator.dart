library TrustEstimator;

import "package:trust_estimator/github.dart" show GitHubOrg, GitHubRepo, GitHubUser;

part "trust_estimator/estimate.dart";

bool printInfo = false;
List<String> users = [];

void _print(Object object) {
  if(printInfo)
    print(object);
}