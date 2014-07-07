#Trust Estimator

This project is designed to estimate the amount of trust one GitHub user may have in another. This may be useful in a recommendation system.

##How To Use

###Install
 - Install [Dart](https://www.dartlang.org/)
 - Install [MongoDB](http://www.mongodb.org/)
 - Clone the project
 - Get a GitHub auth key ([here](https://github.com/settings/applications/new), [more info](https://developer.github.com/v3/oauth/))
 - Create a file in `bin` called `github_auth.dart`.
 - In that file, put `final auth = "yourAuthCode";`


### Run

 - Run `dart bin/main {args} [users]`

#### Args
 - \-h, --[no-]help: Display this message.
 - \-r, --[no-]rate-limit: Display GitHub rate limit info.
 - \-c, --[no-]clear-db: Clear the database.
 - \-u, --users: Specify a file with a json list of users to estimate trust on.
 - \-f, --format: Specify the output format [json, readable (default)].

 - rest (anything typed after other args): Specify users to estimate trust on.


### Tests
  - Be sure you have followed the [Install](#install) section
  - run `dart test/test.dart`