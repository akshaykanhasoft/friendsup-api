var express = require("express");
var router = express.Router();
var app = express();
var trim = require("trim");
const knex = require("../knex/knex");
var moment = require("moment");
const md5 = require('md5');
var uniqid = require('uniqid');
//Authentication libraries
var nodemailer = require("nodemailer");
const passport = require('passport');
const passportJwt = require('passport-jwt');
const JwtStrategy = passportJwt.Strategy;
const ExtractJwt = passportJwt.ExtractJwt;
const jwt = require('jsonwebtoken');
var multer = require('multer')
var fs = require('fs');
var secretOrKey = 'c542e4078b0503ee7caa8a30b926997dedb1c200'
var transporter = nodemailer.createTransport({
	service: "gmail",
	auth: {
		user: "friendsupapp@gmail.com",
		pass: "friendsup963"
	}
});

const opts = {
	jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
	secretOrKey: secretOrKey
};

const strategy = new JwtStrategy(opts, (payload, next) => {
	if (payload.id) {
		next(null, true);
	} else {
		next(null, false);
	}
});

var upload = multer({
	dest: 'public/uploads/'
});

passport.use(strategy);
app.use(passport.initialize());

// router.post("/login", function (req, res) {
// 	//  console.log("req ", req.body);
// 	var userEmail = trim(req.body.username);
// 	var userPass = trim(req.body.password);
// 	if (!userEmail || !userPass) {
// 		res.status(422).send('Email or password missing.');
// 	} else {
// 		if (userEmail == "admin@gmail.com" && userPass == "admin") {
// 			const payload = {
// 				id: 155
// 			};
// 			const token = jwt.sign(payload, secretOrKey, {
// 				expiresIn: '60m'
// 			});
// 			res.status(200).send({
// 				email: userEmail,
// 				password: userPass,
// 				auth_accessToken: token
// 			});
// 		} else {
// 			res.status(422).send('wrong Email or password.');
// 		}
// 		// var Udata = {
// 		// 	"user_email" : userEmail
// 		// }
// 		// knex('users').where(Udata).select('*').then((response)=>{
// 		// 	bcrypt.compare(userPass,response[0].user_pass, function(e,r) {
// 		// 		if(r == true){
// 		// 			const payload = {id:response[0].id};
// 		// 		  	const token = jwt.sign(payload,secretOrKey);

// 		// 		  	response[0].auth_accessToken=token
// 		// 			res.status(200).send(response);
// 		// 		}else{
// 		// 			res.status(200).send('Incorrect password.');
// 		// 		}	
// 		// 	});
// 		// }).catch((err)=>{
// 		// 	if(err){
// 		// 		res.status(422).send('wrong Email or password.');
// 		// 	}
// 		// })
// 	}
// });

router.post('/getData', function (req, res) {
	try {
		jwt.verify(req.token, secretOrKey, (err) => {
			if (err) {
				res.sendStatus(403)
			} else {
				knex("admin").where({
					id: req.body.id
				}).then(rows => {
					res.status(200).send(rows)
				})
				let request = { email: "admin@friendsup.com", password: "Admim@123" }
				adminLogin(request)
			}
		})

	} catch (error) {
		console.log("error", error.message)
		res.status(200).send("Error");
	}
})


// //verify token
// function verifyToken(req,res,next){
// 	const bearerHeader = req.headers['authorization']
// 	if(typeof bearerHeader !== 'undefined'){
// 	//splie at the  space			
// 	const bearer = bearerHeader.split(' ');
// 	// get token from  array
// 	const bearerToken = bearer[1];
// 	//set the token
// 	req.token = bearerToken
// 	//next middleware
// 	jwt.verify(req.token, 'secretkey', (err) => {
// 		if(err){
// 			res.sendStatus(403)
// 		}else{
// 			next();
// 		}
// 	})

// 	}else{
// 		//forbidden
// 		res.sendStatus(403)
// 	}
// }

function adminLogin(res, req) {
	try {
		knex("admin").where({
			email: req.body.email,
			password: md5(req.body.password)
		}).then(rows => {
			if (rows.length > 0) {
				var token = jwt.sign({ id: rows[0].id }, 'my_secret_key', {
					//expiresIn: 86400 // expires in 24 hours
					expiresIn: '43200' // expires in 12 hours
				});
				// const token = jwt.sign(user, config.secret, { expiresIn: config.tokenLife})
				// const refreshToken = jwt.sign(user, config.refreshTokenSecret, { expiresIn: config.refreshTokenLife})
				//res.status(200).send({ code: 200, error: "false", message: "login successfully", resp: rows, token: token });
			} else {
				//res.status(200).send({ code: 200, error: "true", message: "Authentication fail", resp: rows });
			}
		})
	} catch (error) {
		//res.status(200).send({ code: 400, error: "true", message: "wrong credential", resp: error.message });
	}
}

router.post("/adminLogin", function (req, res) {
	try {
		knex("admin").where({
			email: req.body.email,
			password: md5(req.body.password)
		}).then(rows => {
			if (rows.length > 0) {
				var token = jwt.sign({ id: rows[0].id }, secretOrKey, {
					//expiresIn: 86400 // expires in 24 hours
					expiresIn: '1d' // expires in 12 hours
				});
				// const token = jwt.sign(user, config.secret, { expiresIn: config.tokenLife})
				// const refreshToken = jwt.sign(user, config.refreshTokenSecret, { expiresIn: config.refreshTokenLife})
				res.status(200).send({ code: 200, error: "false", message: "login successfully", resp: rows, token: token });
			} else {
				res.status(200).send({ code: 200, error: "true", message: "Authentication fail", resp: rows });
			}
		})
	} catch (error) {
		res.status(200).send({ code: 400, error: "true", message: "wrong credential", resp: error.message });
	}
})

router.post("/login", function (req, res) {
	//console.log("req ", req.body);

	// const users = {
	// 	id: 1,
	// 	email: "akki@gmail.com",
	// 	password: "123456",
	// 	expiresIn: '24h'
	// }
	knex('users').where({
		email: req.body.email,
		password: md5(req.body.password),
		is_admin: 1
	}).then((rows) => {
		//console.log("rows_akki", rows);
		var data = rows[0]
		var access_data = {
			user_id: data.id,
			token: trim(uniqid()),
			time: Math.floor(new Date().getTime() / 1000),
			status: 0
		}

		var fcmToken = req.body.token == undefined ? "" : req.body.token
		knex('user_fcm_token').insert({
			userid: data.id,
			fcm_token: fcmToken,
			platform: req.body.userplatform
		}).then(() => {
			let query = knex('user_access_token').returning('*').insert(access_data).then((result) => {
				knex.select('*').from('users').leftJoin('user_access_token', 'users.id', 'user_access_token.user_id').where({
					token: trim(result[0].token)
				}).then((response) => {
					let resp = []
					jwt.sign({ email: req.body.email, password: req.body.password }, 'secretkey', (err, gettoken) => {
						resp.push({
							new_token: gettoken,
							id: response[0].id,
							email: response[0].email,
							username: response[0].username,

						})
						//res.status(200).send(resp);
						res.status(200).send({ code: 200, error: "false", message: "login successfully", resp: resp });
					})
				})
			});

		})
	}).catch((error) => {
		console.log("error ", error);
		res.status(200).send({ code: 200, error: "true", message: "wrong credential", resp: error.message });
	});
})

router.post("/userslist", passport.authenticate('jwt', {
	session: false
}), function (req, res) {
	knex.select("*")
		.from("users")
		.leftJoin("user_photos", function () {
			this.on("user_photos.userid", "users.id")
				.andOn(
					"user_photos.profile_picture", 1
				);
		}).then((result) => {
			res.status(200).send(result);
		})
})

router.post("/allevents", passport.authenticate('jwt', {
	session: false
}), function (req, res) {
	knex.select("*")
		.from("events")
		.then((result) => {
			res.status(200).send(result);
		})
})

router.post("/deleteUploadPostByUser", function (req, res) {
	let query = knex("groups_post")
		.where("id", req.body.id).del()
	query.then(rows => {
		res.sendStatus(200)
	}).catch(error => {
		console.log("error", error)
	})
})

router.post("/reportAbuserListByPostId", function (req, res) {
	var query = knex.select("report_abuse.id as r_id", "report_abuse.reported_by", "report_abuse.reported_to", "report_abuse.post_id", "report_abuse.reason", "report_abuse.created_date", "users.username", "user_photos.image_name")
		.from("report_abuse")
		.leftJoin("users", "report_abuse.reported_by", "users.id")
		.leftJoin("user_photos", "users.id", "user_photos.userid")
		.where("report_abuse.post_id", req.body.post_id)
		.andWhere("user_photos.position", 1)
	//console.log("query",query.toString())
	query.then(rows => {
		res.status(200).send(rows)
	}).catch(error => {
		res.status(400).send(error)
	})
})

router.get("/getinitialuserdata", function (req, res) {
	//console.log("request.apiToken api-users",request.apiToken)
	let query = knex.select("*",
               function () {
			this.select([
				knex.raw('array_agg(favourite.fav_user_id) AS fav_user_id')])
				.from("users")
				.leftJoin("favourite", "favourite.fav_user_id", "users.id")
				.where("users.id", knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw('array_agg(user_photos.image_name) AS user_images')])
				.from('user_photos')
				.where('user_photos.userid', knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('id', user_interest.interest, 'value',interest_sub_categories.value)) AS user_interests")
			])
				.from("user_interest")
				.leftJoin("interest_sub_categories", "user_interest.interest", "interest_sub_categories.id")
				.where('user_interest.user_id', knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('id', user_life_status.relation_status, 'value',life_status.value)) AS user_relation")
			])
				.from("user_life_status")
				.leftJoin("life_status", "user_life_status.relation_status", "life_status.id")
				.where('user_life_status.user_id', knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('id', user_looking_friends.looking_friends, 'value', master_looking_for_friends.value)) AS user_lookingFriends")
			])
				.from("user_looking_friends")
				.leftJoin("master_looking_for_friends", "user_looking_friends.looking_friends", "master_looking_for_friends.id")
				.where('user_looking_friends.user_id', knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('id', user_consider_myself.myself_status, 'value', master_myself.value)) AS user_considerMyself")
			])
				.from("user_consider_myself")
				.leftJoin("master_myself", "user_consider_myself.myself_status", "master_myself.id")
				.where('user_consider_myself.user_id', knex.column("userstable.id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('id', user_iam.iam_status, 'value', master_iam.value)) AS user_iam")
			])
				.from("user_iam")
				.leftJoin("master_iam", "user_iam.iam_status", "master_iam.id")
				.where('user_iam.user_id', knex.column("userstable.id"))
		},
		function () {
			this.count({
				group_count: "userfirebaseid"
			})
				.from("group_details")
				.where({
					userfirebaseid: knex.column("userstable.firebaseId"),
				});
		},
		function () {
			this.select([
				knex.raw('array_agg(interest_main_categories.value) AS mainCategory')])
				.from('user_interest')
				.leftJoin("interest_sub_categories", "user_interest.interest", "interest_sub_categories.id")
				.leftJoin("interest_main_categories", "interest_sub_categories.main_category_id", "interest_main_categories.id")
				//.where('interest_main_categories.id', knex.column("allevents.main_category_id"))
				.where('user_interest.user_id', knex.column("userstable.id"))
			//.andWhere('interest_main_categories.id', knex.column("allevents.main_category_id"))
		},
		function () {
			this.select([
				knex.raw("array_agg(json_build_object('gender',user_child.child_gender, 'age', user_child.child_age)) AS user_child")
			])
				.from("user_child")
				.where('user_child.user_id', knex.column("userstable.id"))
		}
	).from(function () {
		this.select("users.*", "user_photos.image_name as profileImage")
			.from("users")
			//.where(req.body.email != undefined && req.body.email != "" ? {email: req.body.email.trim()} : { id: req.body.id })
			.leftJoin("user_photos", function () {
				this.on("user_photos.userid", "users.id")
					.andOn(
						"user_photos.profile_picture", 1
					);
			})
			.as('userstable')
	})
	//console.log("query ", query.toString());
	query.then((rows) => {
		// console.log("rowssadasdjhasgdjhasgd gsadg asdasg dsgadg  ", rows);
		res.status(200).send(rows);
	})
		.catch(error => {
			res.status(404).send(error.message);
//			res.status(404).send(error);
		});
})

router.post("/userActiveDeactiveByAdmin", function (req, res) {
	knex("users")
		.where("id", req.body.id)
		.update("activeStatus", req.body.status == 1 ? 0 : 1)
		.returning("*")
		.then(rows => {
			res.status(200).send(rows);
		})
		.catch(error => {
			res.status(404).send(error);
		});
})


router.post("/getAllModuleCountData", function (req, res) {
	//console.log("request.apiToken-module",request.apiToken)
	let query = knex.select("*",

		function () {
			this.count({
				users_count: "id"
			})
				.from("users")
				.where("users.activeStatus", 1)
		},
		function () {
			this.count({
				group_count: "id"
			})
				.from("groups")
		},
		function () {
			// this.count({
			// 	group_chat_count: "group_id"
			// })
			// 	.from("master_groups")
			this.select([
				knex.raw('array_agg(master_groups.group_id) AS group_chat_count')])
				.from('master_groups')
				.leftJoin("group_details", "master_groups.group_id", "group_details.groupid")
				.where("group_details.is_admin", 1)
		},
		function () {
			this.select([
				knex.raw('array_agg(master_event_category.id) AS category_count')])
				.from('master_event_category')
		},
		function () {
			this.count({
				event_count: "event_id"
			})
				.from("events")
		}
	).from(function () {
		this.select("users.*", "user_photos.image_name as profileImage")
			.from("users")
			.leftJoin("user_photos", function () {
				this.on("user_photos.userid", "users.id")
					.andOn(
						"user_photos.profile_picture", 1
					);
			})
			.as('userstable')
	})
	query.then((rows) => {
		// console.log("rows ", rows[0]);
		res.status(200).send(rows[0]);
	})
})


router.get("/filterEventData", function (req, res) {
	let current_timestamp = moment().unix()
	let query = knex.select("master_event_category.id as cat_id", "master_event_category.image_name", "master_event_category.category_name",
		function () {
			this.count({ cat_id_count: "tmp.cat_id" })
				.from(function () {
					this.select("event_category.*", "events.event_id", "events.timestamp")
						.from("event_category")
						.leftJoin("events", "events.event_id", "event_category.event_id")
						.where("events.timestamp", ">", current_timestamp)
						.as("tmp")
				})
				.where("tmp.cat_id", knex.column("master_event_category.id"))
		}
	)
		.from("master_event_category")
		.orderBy("master_event_category.category_name", "asc")
		.as("event_count")
	//console.log("query123", query.toString())
	query.then(rows => {
		//	console.log("rows ", rows);
		res.status(200).send(rows)
	}).catch((error) => {
		console.log("error ", error);
		res.status(400).send(error)
	})
});


router.post("/getGroups", function (req, res) {
	// knex
	// 	.select("master_groups.*", "group_details.*", "users.username")
	// 	.from("master_groups")
	// 	//.where("userfirebaseid", req.body.fireid)
	// 	.leftJoin("group_details", "master_groups.group_id", "group_details.groupid")
	// 	.leftJoin("users", "group_details.userfirebaseid", "users.firebaseId")
	// 	.where("group_details.is_admin", 1)
	// 	.then(rows => {
	// 		res.status(200).send(rows);
	// 	})
	// 	.catch(err => {
	// 		res.status(400).send(err);
	// 	});

	var query = knex
		.select(
			"*",
			function () {
				this.count({
					group_member_count: "groupid"
				})
					.from("group_details")
					.where({ groupid: knex.column("groupspost.group_id") });
			},
		).from(function () {
			this.select("master_groups.*", "group_details.*", "users.username")
				.from("master_groups")
				.leftJoin("group_details", "master_groups.group_id", "group_details.groupid")
				.leftJoin("users", "group_details.userfirebaseid", "users.firebaseId")
				.where("group_details.is_admin", 1)
				.as("groupspost");
		});
	//console.log("here",query.toString())
	query.then(rows => {
		res.status(200).send(rows)
	}).catch(error => {
		res.status(400).send(error)
	})
});

const category_image = upload.single('category_image')
router.post('/categoryimage', category_image, (req, res, next) => {
	var text = "";
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	for (var i = 0; i < 15; i++) {
		text += possible.charAt(Math.floor(Math.random() * possible.length));
	}
	var filename = text + '.jpg';
	var target_path = 'public/uploads/' + filename;

	var src = fs.createReadStream(req.file.path);
	var dest = fs.createWriteStream(target_path);
	src.pipe(dest);
	let query = knex("master_event_category")
		.update({
			image_name: filename
		})
		.returning("*")
		.where("id", req.body.id);
	query.then((rows) => {
		res.status(200).send(rows);
	})
		.catch((error) => {
			res.status(400).send(error);
		});
});



router.post('/saveCategory', function (req, res) {
	var access_data = {
		category_name: req.body.c_name,
	}
	knex('master_event_category').returning('*').insert(access_data).then((rows) => {
		// res.status(200).send(rows);
		res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
	})
		.catch((error) => {
			res.status(400).send(error);
		});
});


const categoryUpdateImage = upload.single('category_update_image')
router.post('/category_images_update', categoryUpdateImage, (req, res, next) => {
	var text = "";
	var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	for (var i = 0; i < 15; i++) {
		text += possible.charAt(Math.floor(Math.random() * possible.length));
	}
	var filename = text + '.jpg';
	var target_path = 'public/uploads/' + filename;

	var src = fs.createReadStream(req.file.path);
	var dest = fs.createWriteStream(target_path);
	src.pipe(dest);
	let query = knex("master_event_category")
		.update({
			image_name: filename
		})
		.returning("*")
		.where("id", req.body.id);
	query.then((rows) => {
		res.status(200).send(rows);
	})
		.catch((error) => {
			res.status(400).send(error);
		});
});

router.post('/EditCategory', function (req, res) {
	let empty_image = null
	if (req.body.request.c_image == "") {
		empty_image = null
	}
	knex("master_event_category")
		.where({
			id: req.body.request.category_id
		})
		.update({
			category_name: req.body.request.c_name,
			image_name: empty_image
		})
		.returning("*")
		.then(rows => {
			//res.status(200).send(rows);
			res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
		})
		.catch(error => {
			res.send(404).send(error);
		});

	// console.log("req ", req.body);	
	// 	//console.log("file", req.file);
	// 	if (req.file !== undefined) {
	// 		console.log("same nie")
	// 		var text = "";
	// 		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	// 		for (var i = 0; i < 15; i++) {
	// 			text += possible.charAt(Math.floor(Math.random() * possible.length));
	// 		}
	// 		var filename = text + '.jpg';
	// 		var target_path = 'public/uploads/' + filename;

	// 		var src = fs.createReadStream(req.file.path);
	// 		var dest = fs.createWriteStream(target_path);
	// 		src.pipe(dest);

	// 		knex("master_event_category")
	// 			.where({
	// 				id: req.body.c_id,
	// 			})
	// 			.update({
	// 				category_name: req.body.c_name,
	// 				image_name: filename,
	// 			})
	// 			.returning("*")
	// 			.then(rows => {
	// 				//res.status(200).send(rows);
	// 				res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
	// 			})
	// 			.catch(error => {
	// 				res.send(404).send(error);
	// 			});
	// 	}else{
	// 		console.log("here amkki")
	// 		knex("master_event_category")
	// 			.where({
	// 				id: req.body.request.category_id
	// 			})
	// 			.returning("*")
	// 			.update({
	// 				category_name: req.body.request.c_name
	// 			})
	// 			.then(rows => {
	// 				res.status(200).send(rows);
	// 			})
	// 			.catch(error => {
	// 				res.send(404).send(error);
	// 			});
	// 	}

	// upload(req, res, function (err) {

	// 	if (req.file !== undefined) {
	// 		console.log("same")
	// 		var text = "";
	// 		var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

	// 		for (var i = 0; i < 15; i++) {
	// 			text += possible.charAt(Math.floor(Math.random() * possible.length));
	// 		}
	// 		var filename = text + '.jpg';
	// 		var target_path = 'public/uploads/' + filename;

	// 		var src = fs.createReadStream(req.file.path);
	// 		var dest = fs.createWriteStream(target_path);
	// 		src.pipe(dest);

	// 		knex("master_event_category")
	// 			.where({
	// 				id: req.body.c_id,
	// 			})
	// 			.update({
	// 				category_name: req.body.c_name,
	// 				image_name: filename,
	// 			})
	// 			.returning("*")
	// 			.then(rows => {
	// 				//res.status(200).send(rows);
	// 				res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
	// 			})
	// 			.catch(error => {
	// 				res.send(404).send(error);
	// 			});
	// 	} else {
	// 		if (req.body.category_image == null) {
	// 			knex("master_event_category")
	// 				.where({
	// 					id: req.body.c_id,
	// 				})
	// 				.update({
	// 					category_name: req.body.c_name,
	// 					image_name: "",
	// 				})
	// 				.returning("*")
	// 				.then(rows => {
	// 					//res.status(200).send(rows);
	// 					res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
	// 				})
	// 				.catch(error => {
	// 					res.send(404).send(error);
	// 				});
	// 		} else {
	// 			knex("master_event_category")
	// 				.where({
	// 					id: req.body.c_id,
	// 				})
	// 				.update({
	// 					category_name: req.body.c_name,
	// 					image_name: req.body.category_image,
	// 				})
	// 				.returning("*")
	// 				.then(rows => {
	// 					//res.status(200).send(rows);
	// 					res.status(200).send({ code: 200, error: "false", message: "success", resp: rows });
	// 				})
	// 				.catch(error => {
	// 					res.send(404).send(error);
	// 				});
	// 		}
	// 	}
	// })
});


router.post("/deleteCategory", function (req, res) {
	let query = knex("master_event_category")
		.where("id", req.body.delete_category_id)
		.del()
	query.then(rows => {
		res.sendStatus(200);
	})
		.catch(error => {
			res.status(400).send(error);
		});
})


router.post("/sendMailToUserbyAdmin", function (req, res) {
	//console.log("req ", req.body.subject);

	var mailOptions = {
		from: "friendsupapp@gmail.com",
		to: req.body.userEmail,
		subject: req.body.subject,
		text: req.body.mailBody
	};

	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
			res.status(400).send(error);
		} else {
			// console.log('Email sent: ' + info.response);
			res.status(200).send(info.response);
		}
	});
});


router.post("/sendMultipleMailToUsersbyAdmin", function (req, res) {
	let getAllEmail = ""
	let getUserEmail = []
	req.body.users_email.map((val, index) => {
		getUserEmail.push(val.email)
	})
	getAllEmail = getUserEmail.join(",");
	var mailOptions = {
		from: "friendsupapp@gmail.com",
		//to: "akshay.kanhasoft@gmail.com,ashish.kanhasoft@gmail.com",
		to: getAllEmail,
		subject: req.body.subject,
		text: req.body.mailBody
	};
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			console.log(error);
			res.status(400).send(error);
		} else {
			// console.log('Email sent: ' + info.response);
			//res.status(200).send(info.response);
			res.status(200).send({ code: 200, error: "false", message: "success", resp: info.response });
		}
	});
});

router.post("/getFcmTokens", function (req, res) {
	let fcmToken = []
	let usersid = []
	req.body.users_notification.map((val, index) => {
		usersid.push(val.id)
	})
	let query = knex.select("fcm_token", "platform").from("user_fcm_token").where("user_fcm_token.userid", "in", usersid)
	query.then(row => {
		res.status(200).send(row);
	}).catch(error => {
		res.status(400).send(error.message);
	});
});


router.post("/all_group_listing_data", function (req, res) {
	var query = knex
		.select(
			"*",
			function () {
				this.select([
					knex.raw('array_agg(user_photos.image_name) AS user_images')])
					.from('user_photos')
					.where('user_photos.position', 1)
					.andWhere('user_photos.userid', knex.column("allgroups.user_id"))
			},
			function () {
				this.count({
					group_member_count: "user_id"
				})
					.from("group_invitation_to_users")
					.leftJoin("users", "group_invitation_to_users.user_id", "users.id")
					.where({
						groupid: knex.column("allgroups.id")
					})
					.andWhere("users.activeStatus", 1);
			},
			function () {
				this.count({
					report_abuser_count: "group_id"
				})
					.from("report_abuse")
					.where({
						group_id: knex.column("allgroups.id")
					});
			},
			function () {
				this.select([
					knex.raw('array_agg(group_invitation_to_users.user_id) AS group_invited_user_id')])
					.from('group_invitation_to_users')
					.where({
						groupid: knex.column("allgroups.id"),
						"group_invitation_to_users.requested": 3
					});
			},
		).from(function () {
			this.select("groups.modified_date", "groups.user_id", "groups.created_date", "groups.group_desc", "groups.group_subject", "groups.group_name", "groups.group_profile", "groups.id", "group_invitation_to_users.userfirebaseid", "group_invitation_to_users.is_admin", "groups.group_status", "groups.approval", "users.username")
				.from("groups")
				.leftJoin("group_invitation_to_users", "groups.id", "group_invitation_to_users.groupid")
				.leftJoin("users", "groups.user_id", "users.id")
				.where("users.activeStatus", 1)
				.orderBy('groups.modified_date', 'desc')
				.as("allgroups");
		});
	query.then(rows => {
		res.status(200).send(rows)
	}).catch(error => {
		res.status(400).send(error)
	})
})

router.post("/group_post_listing", function (req, res) {

	var query = knex
		.select(
			"*",
			function () {
				this.select('user_photos.image_name AS user_images')
					.from('user_photos')
					.where('user_photos.position', 1)
					.andWhere('user_photos.userid', knex.column("groupspost.user_id"))
			},
			function () {
				this.count({
					report_count: "post_id"
				})
					.from("report_abuse")
					.where({
						post_id: knex.column("groupspost.id")
					});
			},
		).from(function () {
			this.select("groups_post.user_id", "groups_post.groups_id", "groups_post.group_post_text", "groups_post.group_post_location", "groups_post.id", "groups_post_image.groups_images", "groups_post_image.groups_post_id", "users.username", "groups_post.modified_date")
				.from("groups_post")
				.leftJoin("groups_post_image", "groups_post.id", "groups_post_image.groups_post_id")
				.leftJoin('users', 'groups_post.user_id', 'users.id')
				//.leftJoin('report_abuse', 'groups_post.id', '!=','report_abuse.post_id')
				// .leftJoin("report_abuse", function () {
				//   this.on("groups_post.id", '!=', "report_abuse.post_id")
				//     .andOn("report_abuse.reported_by", "users.id")
				// })
				.orderBy('groups_post.created_date', 'desc')
				.where("groups_post.groups_id", req.body.group_id)
				.andWhere("users.activeStatus", 1)
				//.andWhere("report_abuse.post_id", "!=", "groups_post")
				.as("groupspost");
		});
	//console.log("querysadasdasdasdasd", query.toString())
	query.then(rows => {
		res.status(200).send(rows)
	}).catch(error => {
		res.status(400).send(error)
	})
})


router.post("/alleventlisting", function (req, res) {
	var query = knex
		.select(
			"*",
			function () {
				this.count({
					goingusers: "going"
				})
					.from("event_invited_users")
					.where({
						event_id: knex.column("allevents.event_id"),
						going: 1
					});
			},
			function () {
				// subquery
				this.count({
					interestedusers: "interested"
				})
					.from("event_invited_users")
					.where({
						event_id: knex.column("allevents.event_id"),
						interested: 1
					});
			},
			function () {
				this.select([
					knex.raw('array_agg(event_images.image_name) AS event_image')])
					.from('event_images')
					.where('event_images.event_id', knex.column("allevents.event_id"))
			},
			function () {
				this.select([
					knex.raw('array_agg(user_photos.image_name) AS user_images')])
					.from('user_photos')
					.leftJoin('event_invited_users', 'user_photos.userid', 'event_invited_users.invited_user_id')
					.where('user_photos.position', 1)
					.andWhere('event_invited_users.interested', 1)
					.andWhere('event_invited_users.event_id', knex.column("allevents.event_id"))
					.limit(4)
			},
			function () {
				this.select([
					knex.raw('array_agg(event_invited_users.invited_user_id) as intrested_users')
				])
					.from("event_invited_users")
					.where("event_invited_users.event_id", knex.column("allevents.event_id"))
			}
		)
		.from(function () {
			this.select("events.*", "event_images.image_name as event_images", "users.id", "users.email", "users.firstname", "users.firebaseId", "users.username", "event_invited_users.id as event_invited_users_id", "event_invited_users.event_id as event_invited_users_event_id", "event_invited_users.interested as event_invited_users_intrested")
				.from("events")
				.leftJoin("event_images", "event_images.event_id", "events.event_id")
				.leftJoin("event_invited_users", "events.event_id", "event_invited_users.event_id")
				.leftJoin("users", "users.id", "events.created_by")
				.orderBy("events.event_start_date", "ASC")
				.as("allevents");
		});
	query.then(rows => {
		rows.map((val, index) => {
			if (
				moment(val.event_start_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000 <
				moment().unix() &&
				moment().unix() <
				moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000
			) {
				val.status = "running";
			}
			if (
				moment().unix() >
				moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000
			) {
				val.status = "completed";
			}
		});
		res.status(200).send(rows);
	})
		.catch(error => {
			res.status(400).send(error);
		});
});


router.post("/allevents", function (req, res) {
	var query = knex
		.select(
			"*",
			function () {
				this.count({
					goingusers: "going"
				})
					.from("event_invited_users")
					.where({
						event_id: knex.column("allevents.event_id"),
						going: 1
					});
			},
			function () {
				// subquery
				this.count({
					interestedusers: "interested"
				})
					.from("event_invited_users")
					.where({
						event_id: knex.column("allevents.event_id"),
						interested: 1
					});
			},
			function () {
				this.select([
					knex.raw('array_agg(event_images.image_name) AS event_image')])
					.from('event_images')
					.where('event_images.event_id', knex.column("allevents.event_id"))
			},
			function () {
				this.select([
					knex.raw('array_agg(user_photos.image_name) AS user_images')])
					.from('user_photos')
					.leftJoin('event_invited_users', 'user_photos.userid', 'event_invited_users.invited_user_id')
					.where('user_photos.position', 1)
					.andWhere('event_invited_users.interested', 1)
					.andWhere('event_invited_users.event_id', knex.column("allevents.event_id"))
					.limit(4)
			},
			function () {
				this.select([
					knex.raw('array_agg(event_invited_users.invited_user_id) as intrested_users')
				])
					.from("event_invited_users")
					.where("event_invited_users.event_id", knex.column("allevents.event_id"))
			}
		)
		.from(function () {
			this.select("events.*", "event_images.image_name as event_images", "users.id", "users.email", "users.firstname", "users.firebaseId", "users.username", "event_invited_users.id as event_invited_users_id", "event_invited_users.event_id as event_invited_users_event_id", "event_invited_users.interested as event_invited_users_intrested")
				.from("events")
				.leftJoin("event_images", "event_images.event_id", "events.event_id")
				.leftJoin("event_invited_users", "events.event_id", "event_invited_users.event_id")
				.leftJoin("users", "users.id", "events.created_by")
				.orderBy("events.event_start_date", "ASC")
				.as("allevents");
		});
	query.then(rows => {
		rows.map((val, index) => {
			if (
				moment(val.event_start_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000 <
				moment().unix() &&
				moment().unix() <
				moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000
			) {
				val.status = "running";
			}
			if (
				moment().unix() >
				moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000
			) {
				val.status = "completed";
			}
		});
		res.status(200).send(rows);
	})
		.catch(error => {
			res.status(400).send(error);
		});
});
/**
 * get user's going events
 */



router.post("/ResetpasswordByAdmin", function (req, res) {
	knex("admin")
		.where({
			email: 'friendsupapp@gmail.com'
		})
		.update({
			password: md5(req.body.password)
		})
		.returning("*")
		.then(rows => {
			res.status(200).send(rows);
		})
		.catch(error => {
			res.send(404).send(error);
		});
});


router.post("/checkResetPasswordUrl", function (req, res) {
 	knex("admin")
		.where({
			email: req.body.email
		})
		.update({
			//is_url: req.body.bool == 0 ? 0 : 1 
			is_url: req.body.bool
		})
		.returning("*")
		.then(rows => {
			res.status(200).send(rows);
		})
		.catch(error => {
			res.send(404).send(error);
		});
});


router.post("/getAdminData", function (req, res) {
	let query = knex.select("*")
		.from("admin")
		.where("email", req.body.email)
	query.then((rows) => {
		res.status(200).send(rows);
	})
		.catch((err) => {
			res.status(400).send(err);
		})
});


router.post("/resetPasswordCheckEmail", function (req, res) {
 	let query = knex.select("*")
		.from("admin")
		.where("email", req.body.email)
	query.then((rows) => {
 		if (rows.length > 0) {
			res.status(200).send({ code: 200, error: "false", message: "email is found", resp: rows });
		} else {
			res.status(200).send({ code: 400, error: "true", message: "email not found", resp: rows });
		}
	}).catch((err) => {
		res.status(400).send(err);
	})
});



module.exports = router;
