#Trust Estimator

This project is designed to estimate the amount of trust one GitHub user may have in another. This may be useful in a recommendation system.

##How To Use

###Install
 - Install [Dart](https://www.dartlang.org/)
 - Clone the project
 - Get a GitHub auth key ([here](https://github.com/settings/applications/new), [more info](https://developer.github.com/v3/oauth/))
 - Create a file in `bin` called `github_auth.dart`.
 - In that file, put `final auth = "[your auth code]";`


### Run

 - Run `dart bin/main {-o -f filepath} [newUsers]`
   - users is a list of usernames to run the estimation over
   - filepath is the file you would like to pull/store the GitHub data in
 - See results printed to the screen

### Args
- \-h, \-\-[no-]help: Display this message.
- \-f, \-\-file: The file to store/pull GitHub data to/from (defaults to "trust.json")
- \-r, \-\-[no\-]rate-limit: Display GitHub rate limit info
- rest: The new users to add to the estimation

### Tests
  - Be sure you have setup your auth code (described in the install section)
  - cd into the `test` folder
  - run `dart test.dart`