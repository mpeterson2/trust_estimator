part of TrustEstimator;


Trust getTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;
  
  var fTrust = getFollowingTrust(userA, userB);
  var oTrust = getOrgTrust(userA, userB);
  var sTrust = getStarredTrust(userA, userB);
  var wTrust = getWatchingTrust(userA, userB);
  
  trust += fTrust;
  trust += oTrust;
  trust += sTrust;
  trust += wTrust;

  return new Trust(userA.login, userB.login)
    ..followingTrust = fTrust
    ..orgTrust = oTrust
    ..starredTrust = sTrust
    ..watchingTrust = wTrust;
}

int getFollowingTrust(GitHubUser userA, GitHubUser userB) {
  var trust = 0;

  if(userA.following.any((u) => u.login == userB.login) || userB.followers.any((u) => u.login == userA.login)) {
    if(userA.followers.any((u) => u.login == userB.login) || userB.following.any((u) => u.login == userA.login)) {
      trust += 10;
    }
    else {
      trust += 5;
    }
  }
  else if(userA.followers.any((u) => u.login == userB.login) || userB.following.any((u) => u.login == userA.login)) {
    trust += 1;
  }
  
  var bothFollowing = 0;
  
  for(var user in userA.following) {
    if(userB.following.any((u) => u.login == userB.login)) {
      bothFollowing++;
      trust += 3;
    }
  }
  
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
  
  var userAStarredUserB = 0;
  for(var repo in userA.starredRepos) {
    if(repo.ownerLogin == userB.login) {
      trust += 5;
      userAStarredUserB++;
    }
  }
  
  var bothStarred = 0;
  for(var repoA in userA.starredRepos) {
    for(var repoB in userB.starredRepos) {
      if(repoA.id == repoB.id) {
        trust += 3;
        bothStarred++;
      }
    }
  }
  
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
  
  var userAWatch = 0;
  for(var repo in userA.watchingRepos) {
    if(repo.ownerLogin == userB.login) {
      userAWatch++;
      trust += 10;
    }
  }
  
  var bothWatch = 0;
  for(var repoA in userA.watchingRepos) {
    for(var repoB in userB.watchingRepos) {
      if(repoA.id == repoB.id) {
        bothWatch++;
        trust += 7;
      }
    }
  }
  
  return trust;
}