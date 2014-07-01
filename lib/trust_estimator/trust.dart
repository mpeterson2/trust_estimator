part of TrustEstimator;

class Trust {
  final String loginA;
  final String loginB;
  final int trust;
  
  Trust(this.loginA, this.loginB, this.trust);
  
  Trust.fromMap(Map map)
      : loginA = map["loginA"],
        loginB = map["loginB"],
        trust  = map["trust"];
  
  String toString() {
    return "$loginA trusts $loginB $trust much";
  }
}