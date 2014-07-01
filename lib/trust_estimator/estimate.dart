part of TrustEstimator;


Trust getTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;
  
  trust += getFollowingTrust(userA, userB);
  trust += getOrgTrust(userA, userB);
  trust += getStarredTrust(userA, userB);
  trust += getWatchingTrust(userA, userB);

  return new Trust(userA.login, userB.login, trust);
}

int getFollowingTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;

  if(userA.following.any((u) => u.login == userB.login) || userB.followers.any((u) => u.login == userA.login)) {
    if(userA.followers.any((u) => u.login == userB.login) || userB.following.any((u) => u.login == userA.login)) {
      _print("\t\tFollowing Type: mutual");
      trust += 10;
    }
    else {
      _print("\t\tFollowing Type: follower");
      trust += 5;
    }
  }
  else if(userA.followers.any((u) => u.login == userB.login) || userB.following.any((u) => u.login == userA.login)) {
    _print("\t\tFollowing Type: leader");
    trust += 1;
  }
  else {
    _print("\t\tFollowing Type: none");
  }
  
  var bothFollowing = 0;
  
  for(var user in userA.following) {
    if(userB.following.any((u) => u.login == userB.login)) {
      bothFollowing++;
      trust += 3;
    }
  }
  
  _print("\t\tBoth following: $bothFollowing");
  _print("\tFollowing trust: $trust");
  return trust;
  
}

int getOrgTrust(GitHubUser userA, GitHubUser userB) {
  empty();
  var trust = 0;
  
  for(var org in userA.orgs) {
    if(userB.orgs.any((o) => o.id == org.id)) {
      trust += 5;
    }
  }
  
  _print("\t\tBoth in ${trust~/5} orgs");
  _print("\tOrgs trust:      $trust");
  return trust;
}

int getStarredTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;
  
  var userBStarredA = 0;
  for(var repo in userB.starredRepos) {
    if(repo.ownerLogin == userA.login) {
      trust += 1;
      userBStarredA++;
    }
  }
  
  _print("\t\t$userB starred $userA: $userBStarredA");
  
  
  var userAStarredUserB = 0;
  for(var repo in userA.starredRepos) {
    if(repo.ownerLogin == userB.login) {
      trust += 5;
      userAStarredUserB++;
    }
  }
  
  _print("\t\t$userA starred $userB: $userAStarredUserB");
  
  var bothStarred = 0;
  for(var repoA in userA.starredRepos) {
    for(var repoB in userB.starredRepos) {
      if(repoA.id == repoB.id) {
        trust += 3;
        bothStarred++;
      }
    }
  }
  
  _print("\t\tBoth starred: $bothStarred");
  _print("\tStarred trust:   $trust");
  
  return trust;
}

int getWatchingTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;
  
  var userBWatch = 0;
  for(var repo in userB.watchingRepos) {
    if(repo.ownerLogin == userA.login) {
      userBWatch++;
      trust += 1;
    }
  }
  
  _print("\t\t$userB watching $userA: $userBWatch");
  
  var userAWatch = 0;
  for(var repo in userA.watchingRepos) {
    if(repo.ownerLogin == userB.login) {
      userAWatch++;
      trust += 10;
    }
  }
  
  _print("\t\t$userA watching $userB: $userAWatch");
  
  var bothWatch = 0;
  for(var repoA in userA.watchingRepos) {
    for(var repoB in userB.watchingRepos) {
      if(repoA.id == repoB.id) {
        bothWatch++;
        trust += 7;
      }
    }
  }
  
  _print("\t\tBoth are watching: $bothWatch");
  _print("\tWatching trust:  $trust");
  
  return trust;
}