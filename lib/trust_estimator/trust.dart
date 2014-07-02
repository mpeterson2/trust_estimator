part of TrustEstimator;

class Trust {
  final String loginA;
  final String loginB;
  int followingTrust;
  int orgTrust;
  int starredTrust;
  int watchingTrust;
  
  int get trust => followingTrust + orgTrust + starredTrust + watchingTrust;
  
  Trust(this.loginA, this.loginB);
  
  Trust.fromMap(Map map)
      : loginA = map["loginA"],
        loginB = map["loginB"];
  
  Map toMap() {
    return {
      "loginA": loginA,
      "loginB": loginB,
      "trust": trust,
      "followingTrust": followingTrust,
      "orgTrust": orgTrust,
      "starredTrust": starredTrust,
      "watchingTrust": watchingTrust
    };
  }
  
  String toString() => "$loginA trusts $loginB $trust much";
}