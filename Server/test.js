var graph = require('fbgraph');
var conf = require('./config/facebook');

// var query = "SELECT name FROM user WHERE uid = me()";
// var options = {access_token: "EAAD5HLGKKfEBAHrBXqkxc9y6uXUE5whEC4SsNBzxsEyfw8uyXVHGETGQRAvuVqvdccAEzvcAjG1Lu3DceVgFWP99gn5kcRGf9i5ZBOLSH6NaG0IZBDlfhTR72f3wxo2NaUc9tUqt2qzoOiidhRbAOsSwwZBnAMRlkEPireCH9c0tOLQwRO8DZAPz7BsDZAeTS8TO5ME79xUEpsv7aPdFpz9H42QfZAV0lgl20jXPl16gZDZD"};

// graph.fql(query, options, function(err, res) {
//   console.log(res);
// });

graph.authorize({
	"client_id":      conf.facebook_api_key
	, "redirect_uri":   "http:"
	, "client_secret":  conf.facebook_api_secret
	// , "code":           req.query.code
}, function (err, facebookRes) {
		if(err) {
			console.log('err:');
			console.log(err)
		} else {
			console.log(facebookRes)
		}
});