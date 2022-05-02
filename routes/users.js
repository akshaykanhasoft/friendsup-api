var express = require("express");
var router = express.Router();
const knex = require("../knex/knex");
var trim = require("trim");
var nodemailer = require("nodemailer");
var moment = require("moment");
var asyncLoop = require('node-async-loop');
var fs = require('fs');
var multer = require('multer');
var upload = multer({
  dest: 'public/uploads/'
});
const md5 = require('md5');

var transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "info@friendsupapp.com",
    pass: "FriendsUp123_"
  }
});

router.post("/getinitialuserdata", function (req, res) {
  //  console.log("getinitialuserdata ", req.body);
  let query = knex.select("*",
    // function () {
    //   this.select("favourite.fav_user_id")
    //     .from("users")
    //     .leftJoin("favourite", "favourite.fav_user_id", "users.id")
    //     .where("users.id", knex.column("userstable.id"))
    // },
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
        knex.raw("array_agg(json_build_object('id', user_interest.interest, 'value',interest_sub_categories.value, 'norway_value', interest_sub_categories.nr_value)) AS user_interests")
      ])
        .from("user_interest")
        .leftJoin("interest_sub_categories", "user_interest.interest", "interest_sub_categories.id")
        .where('user_interest.user_id', knex.column("userstable.id"))
    },
    function () {
      this.select([
        knex.raw("array_agg(json_build_object('id', user_life_status.relation_status, 'value',life_status.value, 'norway_value', life_status.nr_value)) AS user_relation")
      ])
        .from("user_life_status")
        .leftJoin("life_status", "user_life_status.relation_status", "life_status.id")
        .where('user_life_status.user_id', knex.column("userstable.id"))
    },
    function () {
      this.select([
        knex.raw("array_agg(json_build_object('id', user_looking_friends.looking_friends, 'value', master_looking_for_friends.value, 'norway_value', master_looking_for_friends.nr_value)) AS user_lookingFriends")
      ])
        .from("user_looking_friends")
        .leftJoin("master_looking_for_friends", "user_looking_friends.looking_friends", "master_looking_for_friends.id")
        .where('user_looking_friends.user_id', knex.column("userstable.id"))
    },
    function () {
      this.select([
        knex.raw("array_agg(json_build_object('id', user_consider_myself.myself_status, 'value', master_myself.value, 'norway_value', master_myself.nr_value)) AS user_considerMyself")
      ])
        .from("user_consider_myself")
        .leftJoin("master_myself", "user_consider_myself.myself_status", "master_myself.id")
        .where('user_consider_myself.user_id', knex.column("userstable.id"))
    },
    function () {
      this.select([
        knex.raw("array_agg(json_build_object('id', user_iam.iam_status, 'value', master_iam.value, 'norway_value', master_iam.nr_value)) AS user_iam")
      ])
        .from("user_iam")
        .leftJoin("master_iam", "user_iam.iam_status", "master_iam.id")
        .where('user_iam.user_id', knex.column("userstable.id"))
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
      .where(req.body.email != undefined && req.body.email != "" ? { email: req.body.email.trim() } : { id: req.body.id })
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
})

// router.post("/getinitialuserdata", function (req, res) {
//   //  console.log("getinitialuserdata ", req.body);
//   let query = knex.select("*",
//     function () {
//       this.select("favourite.fav_user_id")
//         .from("users")
//         .leftJoin("favourite", "favourite.fav_user_id", "users.id")
//         .where("users.id", knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw('array_agg(user_photos.image_name) AS user_images')])
//         .from('user_photos')
//         .where('user_photos.userid', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('id', user_interest.interest, 'value',interest_sub_categories.value)) AS user_interests")
//       ])
//         .from("user_interest")
//         .leftJoin("interest_sub_categories", "user_interest.interest", "interest_sub_categories.id")
//         .where('user_interest.user_id', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('id', user_life_status.relation_status, 'value',life_status.value)) AS user_relation")
//       ])
//         .from("user_life_status")
//         .leftJoin("life_status", "user_life_status.relation_status", "life_status.id")
//         .where('user_life_status.user_id', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('id', user_looking_friends.looking_friends, 'value', master_looking_for_friends.value)) AS user_lookingFriends")
//       ])
//         .from("user_looking_friends")
//         .leftJoin("master_looking_for_friends", "user_looking_friends.looking_friends", "master_looking_for_friends.id")
//         .where('user_looking_friends.user_id', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('id', user_consider_myself.myself_status, 'value', master_myself.value)) AS user_considerMyself")
//       ])
//         .from("user_consider_myself")
//         .leftJoin("master_myself", "user_consider_myself.myself_status", "master_myself.id")
//         .where('user_consider_myself.user_id', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('id', user_iam.iam_status, 'value', master_iam.value)) AS user_iam")
//       ])
//         .from("user_iam")
//         .leftJoin("master_iam", "user_iam.iam_status", "master_iam.id")
//         .where('user_iam.user_id', knex.column("userstable.id"))
//     },
//     function () {
//       this.select([
//         knex.raw("array_agg(json_build_object('gender',user_child.child_gender, 'age', user_child.child_age)) AS user_child")
//       ])
//         .from("user_child")
//         .where('user_child.user_id', knex.column("userstable.id"))
//     }
//   ).from(function () {
//     this.select("users.*", "user_photos.image_name as profileImage")
//       .from("users")
//       .where(req.body.email != undefined && req.body.email != "" ? { email: req.body.email.trim() } : { id: req.body.id })
//       .leftJoin("user_photos", function () {
//         this.on("user_photos.userid", "users.id")
//           .andOn(
//             "user_photos.profile_picture", 1
//           );
//       })
//       .as('userstable')
//   })
//   // console.log("query ", query.toString());
//   query.then((rows) => {
//     // console.log("rowssadasdjhasgdjhasgd gsadg asdasg dsgadg  ", rows);
//     res.status(200).send(rows);
//   })
// })

/* GET users listing. */
router.get("/", function (req, res, next) {
  res.send("respond with a resource");
});

router.post("/updateProfileStatus", function (req, res) {
  var data = {
    profile_completed: req.body.profile_completed
  }

  knex("users")
    .where("id", req.body.userid)
    .update(data)
    .then(rows => {
      res.status(200).send({ rows });
    })
    .catch(error => {
      res.status(404).send(error);
    });
})

/* edit user details */
router.post("/editUserdata", function (req, res) {
  console.log("edit user data req.body ", req.body);
  var data = {
    firstname: trim(req.body[0].name),
    username: trim(req.body[0].name),
    county: trim(req.body[1].county),
    dob: trim(req.body[0].dob),
    mystory: trim(req.body[0].mystory),
    gender: trim(req.body[0].gender),
    // location: trim(req.body[0].location),
    // iam: trim(req.body[1].iam),
    // consider: trim(req.body[1].consider),
    // workAndPosition: trim(req.body[1].workAndPos),
    work_place: trim(req.body[9].work_place),
    work_position: trim(req.body[9].work_position),
    // lookingForFriends: trim(req.body[1].lookingForFriends),
    // state: req.body[0].add_state,
    city: req.body[1].city,
    country: req.body[1].country,
    latitude: req.body[1].lat,
    longitude: req.body[1].lng,
    postcode: req.body[1].postcode,
    is_modified: 1,
    ageFrom: req.body[2].ageFrom,
    ageTo: req.body[2].ageTo,
    distance: req.body[2].distance
  };

  var inerest = [];
  var inerestString = "";
  for (var i = 0; i < req.body[4].interests.length; i++) {
    if (req.body[4].interests[i].id == undefined) {
      inerestString = inerestString + req.body[4].interests[i];
      inerest.push(req.body[4].interests[i]);
    } else {
      inerestString = inerestString + req.body[4].interests[i].id;
      inerest.push(req.body[4].interests[i].id);
    }
    if (req.body[4].interests.length - 1 != i) {
      inerestString = inerestString + ",";
    }
  }

  knex("user_interest")
    .where("user_id", req.body[0].userid)
    .del()
    .then(() => {
      for (var i = 0; i < inerest.length; i++) {
        knex("user_interest")
          .insert({
            user_id: req.body[0].userid,
            interest: inerest[i]
          })
          .catch(err => {
            console.log("first err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("second err ", err);
      res.status(500).send(err);
    });
  data.inerest = inerestString;

  knex("user_life_status")
    .where({
      user_id: req.body[0].userid
    })
    .del()
    .then(() => {
      for (var i = 0; i < req.body[5].relationship_status.length; i++) {
        knex("user_life_status")
          .insert({
            user_id: req.body[0].userid,
            relation_status: req.body[5].relationship_status[i]
          })
          .catch(err => {
            console.log("third err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("forth err ", err);
      res.status(500).send(err);
    });

  knex("user_looking_friends")
    .where({
      user_id: req.body[0].userid
    })
    .del()
    .then(() => {
      for (var i = 0; i < req.body[6].lookingForFriends.length; i++) {
        knex("user_looking_friends")
          .insert({
            user_id: req.body[0].userid,
            looking_friends: req.body[6].lookingForFriends[i]
          })
          .catch(err => {
            console.log("fifth err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("six err ", err);
      res.status(500).send(err);
    });

  knex("user_consider_myself")
    .where({
      user_id: req.body[0].userid
    })
    .del()
    .then(() => {
      for (var i = 0; i < req.body[7].consider.length; i++) {
        knex("user_consider_myself")
          .insert({
            user_id: req.body[0].userid,
            myself_status: req.body[7].consider[i]
          })
          .catch(err => {
            console.log("seven err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("eight err ", err);
      res.status(500).send(err);
    });

  knex("user_iam")
    .where({
      user_id: req.body[0].userid
    })
    .del()
    .then(() => {
      for (var i = 0; i < req.body[8].iam.length; i++) {
        knex("user_iam")
          .insert({
            user_id: req.body[0].userid,
            iam_status: req.body[8].iam[i]
          })
          .catch(err => {
            console.log("nine err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("ten err ", err);
      res.status(500).send(err);
    });

  knex("user_child")
    .where({
      user_id: req.body[0].userid
    })
    .del()
    .then(() => {
      for (var i = 0; i < req.body[3].child.length; i++) {
        knex("user_child")
          .insert({
            user_id: req.body[0].userid,
            child_name: req.body[3].child[i].name,
            child_gender: req.body[3].child[i].gender,
            child_age: req.body[3].child[i].age
          })
          .catch(err => {
            console.log("eleven err ", err);
            res.status(500).send(err);
          });
      }
    })
    .catch(err => {
      console.log("twelve err ", err);
      res.status(500).send(err);
    });

  knex("users")
    .where("id", req.body[0].userid)
    .update(data)
    .then(rows => {
      res.status(200).send({ rows });
    })
    .catch(error => {
      console.log("thirteen error ", error);
      res.status(404).send(error);
    });
});
/* End edit user details */

/* Get user's Photos */
router.post("/userphotos", function (req, res) {
  knex("user_photos")
    .where("userid", req.body.id)
    .select("*")
    .orderBy("position", "asc")
    .then(rows => {
      res.status(200).send({
        rows
      });
    })
    .catch(error => {
      res.status(404).send(error);
    });
});
/* End Get user's Photos */

/* get all friends of user */
router.post("/allfriends", function (req, res) {
  console.log("req.body.id -> ", req.body.id)
  knex("friends")
    .select("*")
    .leftJoin("users", "users.id", "friends.friend_user_id")
    .where("friends.user_id", req.body.id)
    .then(rows => {
      res.status(200).send({
        rows
      });
    })
    .catch(error => {
      res.status(404).send(error);
    });
});
/* End get all friends of user */

/* get user's interests */
router.post("/get_interest", function (req, res) {
  knex
    .select(
      "interest_sub_categories.id as subid",
      "interest_sub_categories.value as subvalue",
      "interest_main_categories.id as id",
      "interest_main_categories.value as name",
      "interest_main_categories.image_name as image",
      "interest_main_categories.nr_value as norway_value",
      "interest_sub_categories.nr_value as norway_sub_value",
    )
    .from("interest_sub_categories")
    .leftJoin(
      "interest_main_categories",
      "interest_main_categories.id",
      "interest_sub_categories.main_category_id"
    )
    .orderBy("interest_sub_categories.main_category_id", "asc")
    .orderBy('interest_sub_categories.value', 'asc')
    .then(rows => {
      res.status(200).send(rows);
    });
});
/* End get user's interests */

/* get relationship status */
router.post("/get_relationship_status", function (req, res) {
  knex
    .select(
      "user_life_status.id",
      "life_status.value as name",
      "user_life_status.relation_status as rel_id",
      "life_status.nr_value as norway_value",
    )
    .from("user_life_status")
    .leftJoin(
      "life_status",
      "life_status.id",
      "user_life_status.relation_status"
    )
    .where("user_life_status.user_id", req.body.id)
    .then(rows => {
      // console.log("rows ", rows);
      res.status(200).send(rows);
    });
});
/* End get relationship status */

/* get looking friends */
router.post("/get_looking_friends", function (req, res) {
  knex
    .select(
      "user_looking_friends.id",
      "master_looking_for_friends.value as name",
      "user_looking_friends.looking_friends as look_id",
      "master_looking_for_friends.nr_value as norway_value",
    )
    .from("user_looking_friends")
    .leftJoin(
      "master_looking_for_friends",
      "master_looking_for_friends.id",
      "user_looking_friends.looking_friends"
    )
    .where("user_looking_friends.user_id", req.body.id)
    //.orderBy('master_looking_for_friends.value', 'asc')
    .then(rows => {
      res.status(200).send(rows);
    });
});
/* End get looking friends */

/* get consider myself */
router.post("/get_consider_myself", function (req, res) {
  knex
    .select(
      "user_consider_myself.id",
      "master_myself.value as name",
      "user_consider_myself.myself_status as myself_id",
      "master_myself.nr_value as norway_value",
    )
    .from("user_consider_myself")
    .leftJoin(
      "master_myself",
      "master_myself.id",
      "user_consider_myself.myself_status"
    )
    .orderBy('master_myself.value', 'asc')
    .where("user_consider_myself.user_id", req.body.id)
    .then(rows => {
      res.status(200).send(rows);
    });
});
/* End get consider myself */

/* get i am */
router.post("/get_iam", function (req, res) {
  knex
    .select(
      "user_iam.id",
      "master_iam.value as name",
      "user_iam.iam_status as iam_id",
      "master_iam.nr_value as norway_value",
    )
    .from("user_iam")
    .leftJoin("master_iam", "master_iam.id", "user_iam.iam_status")
    .where("user_iam.user_id", req.body.id)
    .then(rows => {
      res.status(200).send(rows);
    });
});
/* End get i am */

/* find friend */
router.post("/find_friends", function (req, res) {
  let searchText = req.body.searchText.toLowerCase()
  var query = knex
    .distinct("users.id")
    .select("users.*", "user_photos.image_name")
    .from("users")
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "users.id").andOn(
        "user_photos.profile_picture",
        1
      );
    })
    .leftJoin("user_interest", "user_interest.user_id", "users.id")
    .leftJoin(
      "interest_sub_categories",
      "interest_sub_categories.id",
      "user_interest.interest"
    )
    .leftJoin("user_life_status", "user_life_status.user_id", "users.id")
    .leftJoin(
      "life_status",
      "life_status.id",
      "user_life_status.relation_status"
    )
    .where(function () {
      this.where("users.id", "!=", req.body.currentUser);
    })
    .andWhere(function () {
      this.where(knex.raw('LOWER("users"."firstname")'), "LIKE", "%" + searchText + "%")
        // knex.raw('LOWER("login") = ?', 'knex')
        .orWhere(knex.raw('LOWER("users"."lastname")'), "LIKE", "%" + searchText + "%")
        .orWhere(knex.raw('LOWER("users"."email")'), "LIKE", "%" + searchText + "%")
        .orWhere(knex.raw('LOWER("users"."city")'), 'LIKE', "%" + searchText + "%")
        .orWhere(knex.raw('LOWER("users"."state")'), "LIKE", "%" + searchText + "%")
        .orWhere(knex.raw('LOWER("users"."country")'), "LIKE", "%" + searchText + "%")
        .orWhere(
          knex.raw('LOWER("interest_sub_categories"."value")'),
          "LIKE",
          "%" + searchText + "%"
        )
        .orWhere(knex.raw('LOWER("life_status"."value")'), "LIKE", "%" + searchText + "%");
    })
    .orderBy("users.firstname", "ASC");
  // console.log("query123 ", query.toString());
  query.then(rows => {
    res.status(200).send(rows);
  });
});
/* End find friend */

/* send invitation from mail */
router.post("/sendMailWithEmail", function (req, res) {
  var mailOptions = {
    // from: "harul.kanhasoft@gmail.com",
    from: "<firebase-noreply@google.com>",
    to: req.body.email,
    subject: "Invitation for FriendsUp application.",
    text: "install it and make new friends."
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
/* End send invitation from mail */

/* send friend request */
router.post("/sendFriendRequest", function (req, res) {
  knex("friend_request")
    .insert({
      from_id: req.body.from_id,
      to_id: req.body.to_id,
      req_status: 1
    })
    .then(result => {
      knex("notification")
        .insert({
          from_id: req.body.from_id,
          to_id: req.body.to_id,
          notification_type: 1,
          notification_text: "fromuser send friend request.",
          time: Math.floor(new Date().getTime() / 1000),
          read_status: 1
        })
        .then(() => {
          knex
            .select("*")
            .from("friend_request")
            .where({
              from_id: req.body.from_id,
              req_status: 1
            })
            .then(row => {
              res.status(200).send(row);
            });
        });
    })
    .catch(err => {
      console.log("err ", err);
    });
});
/* End send friend request */

/* accept friend request */
router.post("/acceptFriendRequest", function (req, res) {
  knex("friend_request")
    .where("id", req.body.reqid)
    .update({
      req_status: 2
    })
    .then(result => {
      knex("friends")
        .insert({
          user_id: req.body.from_id,
          friend_user_id: req.body.to_id,
          created_at: Math.floor(new Date().getTime() / 1000)
        })
        .then(() => {
          knex("notification")
            .insert({
              from_id: req.body.from_id,
              to_id: req.body.to_id,
              notification_type: 1,
              notification_text: "fromuser accept friend request.",
              time: Math.floor(new Date().getTime() / 1000),
              read_status: 1
            })
            .then(() => {
              knex
                .select("*")
                .from("friend_request")
                .where({
                  req_status: 1
                })
                .then(row => {
                  res.status(200).send(row);
                });
            });
        });
      // res.status(200).send(result);
    })
    .catch(err => {
      console.log("err ", err);
    });
});
/* End accept friend request */

/* decline friend request */
router.post("/declineFriendRequest", function (req, res) {
  knex("friend_request")
    .where("id", req.body.reqid)
    .update({
      req_status: 3
    })
    .then(result => {
      knex
        .select("*")
        .from("friend_request")
        .where({
          req_status: 1
        })
        .then(row => {
          res.status(200).send(row);
        });
    })
    .catch(err => {
      console.log("err ", err);
    });
});
/* End decline friend request */

/* get other user details */
router.post("/get_other_user_details", function (req, res) {
  let query = knex
    .select("users.*", "favourite.fav_user_id")
    .from("users")
    .leftJoin("favourite", "favourite.fav_user_id", "users.id")
    .where("users.id", req.body.id)
  query.then(row => {
    // console.log("favourite ", row);
    // console.log(knex.select("*")
    // .from('user_interest')
    // .leftJoin('interest_sub_categories', 'interest_sub_categories.id', 'user_interest.interest')
    // .where('user_interest.user_id', req.body.id).toString());
    res.status(200).send(row[0]);
  })
    .catch(err => {
      res.status(400).send(err);
    });
});
/* End get other user details */

/* get other user photos */
router.post("/get_other_user_photos", function (req, res) {
  knex
    .select("*")
    .from("user_photos")
    .where("user_photos.userid", req.body.id)
    .then(row => {
      res.status(200).send(row);
    })
    .catch(err => {
      res.status(400).send(err);
    });
});
/* End get other user photos */

/* get all friends of user */
router.post("/get_all_friends_of_user", function (req, res) {
  knex
    .select("friends.friend_user_id", "friends.user_id")
    .from("friends")
    .where("friends.user_id", req.body.id)
    .orWhere("friends.friend_user_id", req.body.id)
    .then(row => {
      res.status(200).send(row);
    })
    .catch(err => {
      res.status(400).send(err);
    });
});
/* End get all friends of user */

router.post("/getAllsendFriendRequest", function (req, res) {
  knex
    .select("*")
    .from("friend_request")
    .where({
      req_status: 1
    })
    .then(row => {
      res.status(200).send(row);
    });
});

router.post("/getAllNotification", function (req, res) {
  knex
    .select(
      "notification.*",
      "fromusertable.firstname as fromuser",
      "tousertable.firstname as touser",
      "user_photos.image_name"
    )
    .from("notification")
    .leftJoin(
      "users as fromusertable",
      "fromusertable.id",
      "notification.from_id"
    )
    .leftJoin("users as tousertable", "tousertable.id", "notification.to_id")
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "notification.from_id").andOn(
        "user_photos.profile_picture",
        1
      );
    })
    .where({
      to_id: req.body.userid
    })
    .andWhere("tousertable.activeStatus",1)
    .orderBy("time", "DESC")
    .then(row => {
      res.status(200).send(row);
    });
});

router.post("/get_all_fcm_token", function (req, res) {
  knex
    .select("*")
    .from("user_fcm_token")
    .where("userid", req.body.userid)
    .then(row => {
      res.status(200).send(row);
    })
    .catch(err => {
      res.status(400).send(err);
    });
});

router.post("/userUpdateNotificationStatus", function (req, res) {
  knex("notification")
    .update({
      read_status: 0
    })
    .where("id", req.body.not_id)
    .then(() => {
      knex
        .select(
          "notification.*",
          "fromusertable.firstname as fromuser",
          "tousertable.firstname as touser"
        )
        .from("notification")
        .leftJoin(
          "users as fromusertable",
          "fromusertable.id",
          "notification.from_id"
        )
        .leftJoin(
          "users  as tousertable",
          "tousertable.id",
          "notification.to_id"
        )
        .where({
          to_id: req.body.to_id
        })
        .then(row => {
          res.status(200).send(row);
        });
    });
});

router.post("/getFriends", function (req, res) {
  // console.log("req.body ", req.body);
  var query = knex
    .select("ulist.*", "favourite.fav_user_id")
    .from(function () {
      this.select("users.*", "user_photos.image_name")
        .from("friends")
        .leftJoin("user_photos", function () {
          this.on("user_photos.userid", "friends.friend_user_id").andOn(
            "user_photos.profile_picture",
            1
          );
        })
        .leftJoin("users", "users.id", "friends.friend_user_id")
        .where("friends.user_id", req.body.userid)
        .unionAll(function () {
          this.select("users.*", "user_photos.image_name")
            .from("friends")
            .leftJoin("user_photos", function () {
              this.on("user_photos.userid", "friends.user_id").andOn(
                "user_photos.profile_picture",
                1
              );
            })
            .leftJoin("users", "users.id", "friends.user_id")
            .where("friends.friend_user_id", req.body.userid);
        })
        .as("ulist");
    })
    .leftJoin("favourite", function () {
      this.on("favourite.fav_user_id", "ulist.id").andOn(
        "favourite.user_id",
        req.body.userid
      );
    })
    .orderBy("ulist.firstname", "ASC")

  query.then(result => {
    res.status(200).send(result);
  });
});

/**
 * get all groups of current user
 */
router.post("/getGroups", function (req, res) {
  knex
    .select("*")
    .from("group_details")
    .where("userfirebaseid", req.body.fireid)
    .leftJoin(
      "master_groups",
      "master_groups.group_id",
      "group_details.groupid"
    )
    .then(rows => {
      console.log("rows ", rows);
      res.status(200).send(rows);
    })
    .catch(err => {
      res.status(400).send(err);
    });
});

router.post("/addFavourite", function (req, res) {
  knex("favourite")
    .count("*")
    .where({
      user_id: req.body.userid,
      fav_user_id: req.body.favuserid
    })
    .then(rowCount => {
      // console.log("rowCount", rowCount[0].count)
      if (rowCount[0].count == 0) {
        knex("favourite")
          .insert({
            user_id: req.body.userid,
            fav_user_id: req.body.favuserid
          })
          .then(rows => {
            // console.log("rows ", rows);
            res.status(200).send(rows);
          });
      } else {
        knex("favourite")
          .where({
            user_id: req.body.userid,
            fav_user_id: req.body.favuserid
          })
          .del()
          .then(rows => {
            res.sendStatus(200);
          });
      }
    });
});

router.post("/getFavourite", function (req, res) {
  knex("favourite")
    .where({
      user_id: req.body.userid
    })
    .then(rows => {
      res.status(200).send(rows);
    });
});

router.post("/getFcmTokens", function (req, res) {
  console.log("req.body ", req.body);
  var subquery = knex
    .select("id")
    .from("users")
    .where("firebaseId", req.body.fuid);

  knex
    .select(
      "user_fcm_token.fcm_token",
      "user_fcm_token.platform",
      "user_fcm_token.userid"
    )
    .from("user_fcm_token")
    .where("userid", subquery)
    .then(rows => {
      res.status(200).send(rows);
    })
    .catch(err => {
      console.log("err ", err);
      res.status(400).send(err);
    });
});

router.post("/getFcmTokensforevent", function (req, res) {
  knex
    .select(
      "user_fcm_token.fcm_token",
      "user_fcm_token.platform",
      "user_fcm_token.userid"
    )
    .from("user_fcm_token")
    .where("userid", req.body.uid)
    .then(rows => {
      res.status(200).send(rows);
    })
    .catch(err => {
      res.status(400).send(err);
    });
});

router.post("/update_mystory", function (req, res) {
  knex("users")
    .where("id", req.body.id)
    .update("mystory", req.body.mystory)
    .returning("*")
    .then(rows => {
      res.status(200).send({
        rows
      });
    })
    .catch(error => {
      res.status(404).send(error);
    });
});

router.post("/get_user_child", function (req, res) {
  knex
    .select("child_name as name", "child_gender as gender", "child_age as age")
    .from("user_child")
    .where("user_id", req.body.id)
    .then(rows => {
      res.status(200).send(rows);
    })
    .catch(error => {
      res.status(404).send(error);
    });
});

const groupimage = upload.single('groupPhoto')
router.post("/createGroup", groupimage, function (req, res) {
  knex("master_groups")
    .insert({
      group_firebase_id: req.body.groupfirebaseid,
      display_name: req.body.displayname,
      timestamp: Math.floor(new Date().getTime() / 1000)
    })
    .returning("*")
    .then(rows => {
      knex("group_details")
        .insert({
          userfirebaseid: req.body.currentuser_fuid,
          groupid: rows[0].group_id,
          is_admin: 1
        })
        .then(result => {
          let members = [];
          JSON.parse(req.body.groupmembers).forEach(function (element) {
            members.push({
              userfirebaseid: element,
              groupid: rows[0].group_id
            });
          });
          knex("group_details")
            .insert(members)
            .then(response => {
              knex
                .select("*")
                .from("group_details")
                .where({
                  groupid: rows[0].group_id
                })
                .then(row => {
                  if (req.file != undefined) {
                    var text = "";
                    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

                    for (var i = 0; i < 15; i++) {
                      text += possible.charAt(Math.floor(Math.random() * possible.length));
                    }
                    // var filename = req.file.originalname + '.jpg';
                    // var filename = req.file.filename + '.jpg';
                    var filename = text + '.jpg';
                    var target_path = 'public/uploads/' + filename;

                    var src = fs.createReadStream(req.file.path);
                    var dest = fs.createWriteStream(target_path);
                    src.pipe(dest);
                    let updateImageQuery = knex("master_groups")
                      .update({
                        group_image: filename
                      })
                      .returning('*')
                      .where("group_id", rows[0].group_id);
                    updateImageQuery.then((imageResult) => {
                      res.status(200).send({ row, image: imageResult });
                    })
                      .catch((error) => {
                        console.log("error ", error);
                        res.status(400).send(error);
                      });
                  } else {
                    res.status(200).send({ row, image: [{ group_image: "" }] });
                  }
                });
            });
        }).catch((error) => {
          console.log("error", error);
        });
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

router.post("/getallmembers", function (req, res) {
  let query = knex
    .select("users.username","users.gender", "user_photos.image_name", "group_details.*")
    .from("users")
    .leftJoin(
      "group_details",
      "users.firebaseId",
      "group_details.userfirebaseid"
    )
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "users.id").andOn(
        "user_photos.profile_picture",
        1
      );
    })
    .where("groupid", req.body.groupid)
    .andWhere("users.activeStatus", 1);
  // console.log(query.toString())
  query
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

const editgroupimage = upload.single('editGroupPhoto')
router.post("/editgroup", editgroupimage, function (req, res) {
  console.log("req.body ", req.body);
  console.log("req.file ", req.file);
  let query = knex("master_groups")
    .update({
      display_name: req.body.groupname
    })
    .returning("*")
    .where("group_id", req.body.groupid);
  query
    .then(rows => {
      knex("group_details")
        .where("groupid", rows[0].group_id)
        .del()
        .then(result => {
          let data = [];
          JSON.parse(req.body.members).forEach(function (val) {
            data.push({
              userfirebaseid: val.value,
              groupid: rows[0].group_id,
              is_admin: val.is_admin
            });
          });
          knex("group_details")
            .insert(data)
            .then(response => {
              knex
                .select("*")
                .from("group_details")
                .where({
                  groupid: rows[0].group_id
                })
                .then(row => {
                  if (req.file != undefined) {
                    var text = "";
                    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

                    for (var i = 0; i < 15; i++) {
                      text += possible.charAt(Math.floor(Math.random() * possible.length));
                    }
                    // var filename = req.file.originalname + '.jpg';
                    // var filename = req.file.filename + '.jpg';
                    var filename = text + '.jpg';
                    var target_path = 'public/uploads/' + filename;

                    var src = fs.createReadStream(req.file.path);
                    var dest = fs.createWriteStream(target_path);
                    src.pipe(dest);
                    let updateImageQuery = knex("master_groups")
                      .update({
                        group_image: filename
                      })
                      .returning('*')
                      .where("group_id", req.body.groupid);
                    updateImageQuery.then((imageResult) => {
                      fs.unlink('public/uploads/' + trim(req.body.oldImage), (err) => {
                        if (err) {
                          console.log("err ", err);
                        }
                        console.log(trim(req.body.oldImage) + ' was deleted');
                      });
                      res.status(200).send({ row, image: imageResult });
                    })
                      .catch((error) => {
                        console.log("error ", error);
                        res.status(400).send(error);
                      });
                  } else if (req.body.oldImage == "") {
                    let updateImageQuery = knex("master_groups")
                      .update({
                        group_image: null
                      })
                      .returning('*')
                      .where("group_id", req.body.groupid);
                    updateImageQuery.then((imageResult) => {
                      fs.unlink('public/uploads/' + trim(req.body.oldImage), (err) => {
                        if (err) {
                          console.log("err ", err);
                        }
                        console.log(trim(req.body.oldImage) + ' was deleted');
                      });
                      res.status(200).send({ row, image: imageResult });
                    })
                  } else {
                    res.status(200).send({ row, image: [{ group_image: "" }] });
                  }
                  // res.status(200).send(row);
                });
            });
        });
    })
    .catch(error => {
      console.log("error ", error);
      res.status(400).send(error);
    });
});

/**
 * delete group by admin
 */
router.post("/delategroup", function (req, res) {
  let query = knex("master_groups")
    .where("group_id", req.body.group_id)
    .del();
  query
    .then(rows => {
      res.sendStatus(200);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

/**
 * delete group by user
 */
router.post("/delategroupbyuser", function (req, res) {
  let query = knex("group_details")
    .where({
      groupid: req.body.group_id,
      userfirebaseid: req.body.userid
    })
    .del();
  query
    .then(rows => {
      res.sendStatus(200);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

/**
 * get all master event category
 */
router.post("/mastercategory", function (req, res) {
  let query = knex
    .select(
      "master_event_category.id",
      "master_event_category.category_name as name",
      "master_event_category.nr_value as norway_value"
    )
    .from("master_event_category");
  query
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

/**
 * create event
 */
/* router.post("/createevent", function (req, res) {
  let data = {
    event_name: trim(req.body.event_title),
    event_description: trim(req.body.event_description),
    // event_type: req.body[0].eventtype == "Private" ? 1 : 0, // 1=private, 0=public
    // event_type: 0, // 1=private, 0=public
    event_start_date: trim(req.body.start_date) + ' ' + trim(req.body.start_time),
    event_type: req.body.selectedItem == "Private" ? 1 : 0, // 1=private, 0=public
    event_end_date: trim(req.body.end_date) + ' ' + trim(req.body.end_time),
    // approval: req.body[0].eventtype == "Private" ? 1 : req.body[0].eventapproval ? 1 : 0,
    approval: req.body.selectedItem == "Private" ? 1 : req.body.checked ? 1 : 0,
    // approval: 0,
    event_location: trim(req.body.event_address),
    event_lat: req.body.lat,
    event_lng: req.body.lng,
    created_by: req.body.userid,
    created_at: moment().unix()
  };
  data.timestamp = moment(data.event_end_date, "DD-MM-YYYY HH:mm a").valueOf() / 1000

  let query = knex("events")
    .returning("*")
    .insert(data);
  query
    .then(rows => {
      //console.log("rows ********", rows);
      if (req.body.eventCategoryObject.length > 0) {
        req.body.eventCategoryObject.map((val, index) => {
          knex("event_category")
            .insert({
              event_id: rows[0].event_id,
              cat_id: val.id
            })
            .then(result => {
              console.log("result ", result.rowCount);
            });
        });
      }
      if (req.body.SelectedUserList.length > 0) {
        req.body.SelectedUserList.map((val, index) => {
          knex("event_invited_users")
            .insert({
              event_id: rows[0].event_id,
              invited_user_id: val,
              created_at: moment().unix()
            })
            .then(result => {
              if (result.rowCount == 1) {
                insertNotification(req.body.userid, val, 2, "fromuser invite to join event.", rows[0].event_id)
              }
            });
        });
      }
      res.status(200).send({ eventdata: rows[0] });
    })
    .catch(error => {
      console.log("error ", error);
      res.status(400).send(error);
    });
}); */

router.post("/createevent", function (req, res) {
  console.log("req.body.SelectedUserList ", req.body);
  let data = {
    event_name: trim(req.body.event_title),
    event_description: trim(req.body.event_description),
    // event_type: req.body[0].eventtype == "Private" ? 1 : 0, // 1=private, 0=public
    // event_type: 0, // 1=private, 0=public
    event_start_date: trim(req.body.start_date) + ' ' + trim(req.body.start_time),
    event_type: req.body.selectedItem == "Private" ? 1 : 0, // 1=private, 0=public
    event_end_date: trim(req.body.end_date) + ' ' + trim(req.body.end_time),
    // approval: req.body[0].eventtype == "Private" ? 1 : req.body[0].eventapproval ? 1 : 0,
    approval: req.body.selectedItem == "Private" ? 1 : req.body.checked ? 1 : 0,
    // approval: 0,
    event_location: trim(req.body.event_address),
    event_lat: req.body.lat,
    event_lng: req.body.lng,
    created_by: req.body.userid,
    created_at: moment().unix()
  };
  data.timestamp = moment(data.event_end_date, "DD-MM-YYYY HH:mm a").valueOf() / 1000

  let query = knex("events")
    .returning("*")
    .insert(data);
  query
    .then(rows => {
      //console.log("rows ********", rows);
      if (req.body.eventCategoryObject.length > 0) {
        req.body.eventCategoryObject.map((val, index) => {
          knex("event_category")
            .insert({
              event_id: rows[0].event_id,
              cat_id: val.id
            })
            .then(result => {
              console.log("result ", result.rowCount);
            });
        });
      }
      if (req.body.SelectedUserList.length > 0) {
        req.body.SelectedUserList.map((val, index) => {
          knex("event_invited_users")
            .insert({
              event_id: rows[0].event_id,
              invited_user_id: val,
              created_at: moment().unix()
            })
            .then(result => {
              if (result.rowCount == 1) {
                insertNotification(req.body.userid, val, 2, "fromuser inviter til å bli med på arrangementet.", rows[0].event_id)
              }
            });
        });
      }
      res.status(200).send({ eventdata: rows[0] });
    })
    .catch(error => {
      console.log("error ", error);
      res.status(400).send(error);
    });
});

insertNotification = (from, to, type, msg, event = 0) => {
  knex("notification")
    .insert({
      from_id: from,
      to_id: to,
      notification_type: type,
      notification_text: msg,
      time: Math.floor(new Date().getTime() / 1000),
      read_status: 1,
      event_id: event
    })
    .then(row => {
      if (row.rowCount == 1) {
        return true;
      } else {
        return false;
      }
    });
};

/* edit event details*/
/* router.post("/editEventDetail", function (req, res) {
  if (req.body.oldimgs.length > 0) {
    let delete_images = knex("event_images")
      .whereIn("image_name", req.body.oldimgs)
      .where("event_id", req.body.data.event_id)
      .del()
    delete_images.then(rows => {
      console.log("rows", rows)
    }).catch(error => {
      console.log("error", error)
    })
  }
  let edit_data = {
    event_name: trim(req.body.data.event_title),
    event_description: trim(req.body.data.event_description),
    // event_type: req.body[0].eventtype == "Private" ? 1 : 0, // 1=private, 0=public
    // event_type: 0, // 1=private, 0=public
    event_start_date: trim(req.body.data.start_date) + ' ' + trim(req.body.data.start_time),
    event_type: req.body.data.selectedItem == "Private" ? 1 : 0, // 1=private, 0=public
    event_end_date: trim(req.body.data.end_date) + ' ' + trim(req.body.data.end_time),
    // approval: req.body[0].eventtype == "Private" ? 1 : req.body[0].eventapproval ? 1 : 0,
    approval: req.body.data.selectedItem == "Private" ? 1 : req.body.data.checked ? 1 : 0,
    // approval: 0,
    event_location: trim(req.body.data.event_address),
    event_lat: req.body.data.lat,
    event_lng: req.body.data.lng,
    created_by: req.body.data.userid,
    timestamp: moment(req.body.data.end_date + req.body.data.end_time.data, "DD-MM-YYYY HH:mm a").valueOf() / 1000,
    created_at: moment().unix()
  }

  let del_query = knex("event_category")
    .where("event_id", req.body.data.event_id)
    .del();
  del_query.then(rows => {
    //res.sendStatus(200);
  })
    .catch(error => {
      //res.status(400).send(error);
    });

  let query = knex("events")
    .where("event_id", req.body.data.event_id)
    .update(edit_data)
    .returning('*')

  query.then(response => {
    if (req.body.data.eventCategoryObject.length > 0) {
      req.body.data.eventCategoryObject.map((val, index) => {
        knex("event_category")
          .insert({
            event_id: req.body.data.event_id,
            cat_id: val.id == undefined ? val : val.id
          })
          .then(result => {
          });
      });
    }

    if (req.body.data.SelectedUserList.length > 0) {
      req.body.data.SelectedUserList.map((val, index) => {
        knex("event_invited_users")
          //.count("*")
          .where("event_id", req.body.data.event_id)
          .andWhere("invited_user_id", val)
          .then(rows => {
            if (rows.length > 0) {
              console.log("if")
            } else {
              console.log("else")
              knex("event_invited_users")
                .insert({
                  event_id: req.body.data.event_id,
                  invited_user_id: val,
                  requested: req.body.data.checked == 1 ? 1 : 0,
                  created_at: moment().unix()
                })
                .then(result => {
                  if (result.rowCount == 1) {
                    insertNotification(req.body.data.userid, val, 2, "fromuser invite to join event.", req.body.data.event_id)
                  }
                });
            }
          })
      });
    }

    res.status(200).send(response[0])
  })
    .catch(err => {
      res.status(400).send(err)
    });
}) */

router.post("/editEventDetail", function (req, res) {
  //console.log("req ", req.body.array_member);
  console.log("req.body.data.selectedItem ", req.body.data.selectedItem);
  if (req.body.oldimgs.length > 0) {
    let delete_images = knex("event_images")
      .whereIn("image_name", req.body.oldimgs)
      .where("event_id", req.body.data.event_id)
      .del()
    delete_images.then(rows => {
      console.log("rows", rows)
    }).catch(error => {
      console.log("error", error)
    })
  }




  let edit_data = {
    event_name: trim(req.body.data.event_title),
    event_description: trim(req.body.data.event_description),
    // event_type: req.body[0].eventtype == "Private" ? 1 : 0, // 1=private, 0=public
    // event_type: 0, // 1=private, 0=public
    event_start_date: trim(req.body.data.start_date) + ' ' + trim(req.body.data.start_time),
    event_type: req.body.data.selectedItem == "Private" ? 1 : 0, // 1=private, 0=public
    event_end_date: trim(req.body.data.end_date) + ' ' + trim(req.body.data.end_time),
    // approval: req.body[0].eventtype == "Private" ? 1 : req.body[0].eventapproval ? 1 : 0,
    approval: req.body.data.selectedItem == "Private" ? 1 : req.body.data.checked ? 1 : 0,
    // approval: 0,
    event_location: trim(req.body.data.event_address),
    event_lat: req.body.data.lat,
    event_lng: req.body.data.lng,
    created_by: req.body.data.userid,
    timestamp: moment(req.body.data.end_date + req.body.data.end_time.data, "DD-MM-YYYY HH:mm a").valueOf() / 1000,
    created_at: moment().unix()
  }

  let del_query = knex("event_category")
    .where("event_id", req.body.data.event_id)
    .del();
  del_query.then(rows => {
    //res.sendStatus(200);
  })
    .catch(error => {
      //res.status(400).send(error);
    });

  let query = knex("events")
    .where("event_id", req.body.data.event_id)
    .update(edit_data)
    .returning('*')

  query.then(response => {
    if (req.body.data.eventCategoryObject.length > 0) {
      req.body.data.eventCategoryObject.map((val, index) => {
        knex("event_category")
          .insert({
            event_id: req.body.data.event_id,
            cat_id: val.id == undefined ? val : val.id
          })
          .then(result => {
          });
      });
    }

    if (req.body.array_member.length > 0) {
      req.body.array_member.map((val, index) => {
        knex("event_invited_users")
          //.count("*")
          .where("event_id", req.body.data.event_id)
          .andWhere("invited_user_id", val)
          .then(rows => {
            if (rows.length > 0) {
              console.log("if")
            } else {
              console.log("else")
              knex("event_invited_users")
                .insert({
                  event_id: req.body.data.event_id,
                  invited_user_id: val,
                  //requested: req.body.data.checked == 1 ? 1 : 0,
                  created_at: moment().unix()
                })
                .then(result => {
                  if (result.rowCount == 1) {
                    insertNotification(req.body.data.userid, val, 2, "fromuser inviter til å bli med på arrangementet.", req.body.data.event_id)
                  }
                });
            }
          })
      });
    }

    res.status(200).send(response[0])
  })
    .catch(err => {
      res.status(400).send(err)
    });
})
/* end */

router.post("/getEventDetails", function (req, res) {
  let query = knex.select(
    function () {
      // subquery
      this.count({
        interestedusers: "interested"
      })
        .from("event_invited_users")
        .where({
          event_id: knex.column("events.event_id"),
          interested: 1
        })
    },
    function () {
      this.select([
        knex.raw('array_agg(event_images.image_name) AS event_image')])
        .from('event_images')
        .where('event_images.event_id', knex.column("events.event_id"))
    },
    "events.*", "event_images.image_name as event_images", "users.*"
  ).from("events").where({
    "events.event_id": req.body.event_id
  })
    .leftJoin("event_images", "event_images.event_id", "events.event_id")
    .leftJoin("users", "users.id", "events.created_by")

  query.then((rows) => {
    res.status(200).send(rows);
  })
    .catch((err) => {
      console.log("err ", err);
      res.status(400).send(err);
    })
})

router.post("/getUserEvents", function (req, res) {
  console.log("req.body", req.body)
  let query = knex.select("*")
    .from("event_invited_users")
    .where("invited_user_id", req.body.id)
  query.then((rows) => {
    console.log("rows ", rows);
    res.status(200).send(rows);
  })
    .catch((err) => {
      res.status(400).send(err);
    })
})

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
          .andWhere('event_invited_users.interested', 1)
      },
      function () {
        this.select([
          knex.raw('array_agg(event_invited_users.invited_user_id) as event_invited_user_list')
        ])
          .from("event_invited_users")
          .where("event_invited_users.event_id", knex.column("allevents.event_id"))
      },
      function () {
        this.select([
          knex.raw('array_agg(event_invited_users.invited_user_id) as event_joined_user_list')
        ])
          .from("event_invited_users")
          .where("event_invited_users.event_id", knex.column("allevents.event_id"))
          .andWhere('event_invited_users.requested', 3)
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
  query
    .then(rows => {
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

router.post("/getgoingevent", function (req, res) {
  let query = knex.select("event_invited_users.*", "users.*", "events.*", "event_images.*", "event_invited_users.event_id as e_id",
    function () {
      // subquery
      this.count({
        interestedusers: "interested"
      })
        .from("event_invited_users")
        .where({
          event_id: knex.column("events.event_id"),
          interested: 1
        });
    },
    function () {
      this.count({ goingusers: "going" })
        .from("event_invited_users")
        .where({ event_id: knex.column("events.event_id"), going: 1 });
    }
  )
    //.select("*")
    .from("event_invited_users")
    .leftJoin("event_images", "event_images.event_id", "event_invited_users.event_id")
    .leftJoin("events", "events.event_id", "event_invited_users.event_id")
    .leftJoin("users", "users.id", "events.created_by")
    .where({
      "event_invited_users.invited_user_id": req.body.id,
      "event_invited_users.going": 1
    });
  query
    .then(rows => {
      let result = [];
      rows.map((val, index) => {
        if (moment().unix() < moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000) {
          result.push(val);
        }
      });
      res.status(200).send(result);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

/* router.post("/getIntrestedevent", function (req, res) {
  let query = knex.select("event_invited_users.*", "users.*", "events.*", "event_images.image_name as event_images","event_images.event_id", "event_invited_users.event_id as e_id",
    function () {
      // subquery
      this.count({
        interestedusers: "interested"
      })
        .from("event_invited_users")
        .where({
          event_id: knex.column("events.event_id"),
          interested: 1
        });
    },
    function () {
      this.count({ goingusers: "going" })
        .from("event_invited_users")
        .where({ event_id: knex.column("events.event_id"), going: 1 });
    },
    function () {
      this.select([
        knex.raw('array_agg(event_images.image_name) AS event_image')])
        .from('event_images')
        .where('event_images.event_id', knex.column("events.event_id"))
    }
  )
    //.select("*")
    .from("event_invited_users")
    .leftJoin("event_images", "event_images.event_id", "event_invited_users.event_id")
    .leftJoin("events", "events.event_id", "event_invited_users.event_id")
    .leftJoin("users", "users.id", "events.created_by")
    .where({
      "event_invited_users.invited_user_id": req.body.id,
      "event_invited_users.interested": 1
    });
  query
    .then(rows => {
      let result = [];
      rows.map((val, index) => {
        if (moment().unix() < moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000) {
          result.push(val);
        }
      });
      res.status(200).send(result);
    })
    .catch(error => {
      res.status(400).send(error);
    });
}); */

router.post("/getIntrestedevent", function (req, res) {
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
          //.leftJoin('events','event_invited_users.event_id','events.event_id')
          .where('user_photos.position', 1)
          .andWhere('event_invited_users.interested', 1)
          //.orderBy('event_invited_users.created_at','ASC')
          .andWhere('event_invited_users.event_id', knex.column("allevents.event_id"))
          .limit(4)
      }
    )
    .from(function () {
      this.select("events.*", "event_images.image_name as event_images", "users.id", "users.email", "users.firstname", "users.firebaseId", "users.username", "event_invited_users.id as event_invited_users_id", "event_invited_users.event_id as event_invited_users_event_id", "event_invited_users.interested as event_invited_users_intrested")
        //.distinct('event_images.event_id')
        .from("events")
        .leftJoin("event_images", "event_images.event_id", "events.event_id")
        .leftJoin("event_invited_users", "events.event_id", "event_invited_users.event_id")
        .leftJoin("users", "users.id", "events.created_by")
        .orderBy("events.event_start_date", "ASC")
        .where({
          "event_invited_users.invited_user_id": req.body.id,
          "event_invited_users.interested": 1
        })
        .as("allevents");
    });
  query
    .then(rows => {
      let result = [];
      rows.map((val, index) => {
        if (moment().unix() < moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000) {
          result.push(val);
        }
      });
      res.status(200).send(result);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});


router.post("/get_going_event_count", function (req, res) {
  let query = knex.select("event_invited_users.*", "users.*", "events.*", "event_images.*", "event_invited_users.event_id as e_id", "event_invited_users.invited_user_id",
    function () {
      // subquery
      this.count({
        interestedusers: "interested"
      })
        .from("event_invited_users")
        .where({
          event_id: knex.column("events.event_id"),
          interested: 1
        });
    },
    function () {
      this.count({ goingusers: "going" })
        .from("event_invited_users")
        .where({ event_id: knex.column("events.event_id"), going: 1 });
    }
  )
    //.select("*")
    .from("event_invited_users")
    .leftJoin("event_images", "event_images.event_id", "event_invited_users.event_id")
    .leftJoin("events", "events.event_id", "event_invited_users.event_id")
    .leftJoin("users", "users.id", "events.created_by")
    .where({
      "event_invited_users.event_id": req.body.event_id,
      "event_invited_users.going": 1
    });
  query
    .then(rows => {
      let result = [];
      rows.map((val, index) => {
        if (moment().unix() < moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000) {
          result.push(val);
        }
      });
      res.status(200).send(result);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

// router.post("/getgoingevent", function (req, res) {
//   let query = knex
//     .select("*")
//     .from("event_invited_users")
//     .leftJoin("events", "events.event_id", "event_invited_users.event_id")
//     .where({
//       "event_invited_users.invited_user_id": req.body.id,
//       "event_invited_users.going": 1
//     });
//   query
//     .then(rows => {
//       let result = [];
//       rows.map((val, index) => {
//         if (
//           moment().unix() <
//           moment(val.event_end_date, "DD-MM-YYYY hh:mm a").valueOf() / 1000
//         ) {
//           result.push(val);
//         }
//       });
//       res.status(200).send(result);
//     })
//     .catch(error => {
//       res.status(400).send(error);
//     });
// });

router.post("/getAllInvitedUser", function (req, res) {
  let query = knex
    .select("*")
    .from("event_invited_users")
    .where({
      event_id: req.body.event_id,
      invited_user_id: req.body.user_id
    });
  query
    .then(response => {
      res.status(200).send(response);
    })
    .catch(error => {
      res.status(500).send(error);
    });
});

/* add intrested users data */
router.post("/addIntrestedUser", function (req, res) {
  var data = {
    invited_user_id: req.body.user_id,
    event_id: req.body.event_id,
    interested: req.body.interested,
    created_at: moment().unix()
  };
  let query_check = knex
    .count("*")
    .from("event_invited_users")
    .where({
      event_id: req.body.event_id,
      invited_user_id: req.body.user_id
    });
  query_check.then(rowCount => {
    if (rowCount[0].count == 1) {
      knex("event_invited_users")
        .where({
          event_id: req.body.event_id,
          invited_user_id: req.body.user_id
        })
        .update({
          interested: req.body.interested
        })
        .returning("*")
        .then(rows => {
          res.status(200).send(rows);
        })
        .catch(error => {
          res.send(404).send(error);
        });
    } else {
      let query = knex("event_invited_users").insert(data);
      query
        .then(response => {
          res.status(200).send(response);
        })
        .catch(error => {
          res.send(404).send(error);
        });
    }
  });
});

/* add going users data */
router.post("/addGoingUser", function (req, res) {
  var data = {
    invited_user_id: req.body.user_id,
    event_id: req.body.event_id,
    going: req.body.going,
    approval: req.body.approval,
    requested: req.body.requested,
    created_at: moment().unix(),
    current_user: req.body.current_user
  };
  let query_check = knex
    .select("*")
    .from("event_invited_users")
    .where({
      event_id: req.body.event_id,
      invited_user_id: req.body.user_id
    })
  query_check.then(row => {
    if (data.approval == 1) {
      if (row.length > 0) {
        if (data.current_user == 'true') {
          // current user 
          let update_data = {};
          if (row[0].going == 0 && row[0].requested == 0) {
            update_data.going = 1
            update_data.requested = 3
          } else if (row[0].going == 1 && row[0].requested == 3) {
            update_data.going = 0
            update_data.requested = 0
          }
          /* update query */
          knex("event_invited_users")
            .where({
              event_id: req.body.event_id,
              invited_user_id: req.body.user_id
            })
            .update(update_data)
            .returning('*')
            .then(rows => {
              res.status(200).send(rows)
            }).catch((error) => {
              res.status(400).send(error)
            })
          /* end */
        } else {
          // current user nath
          console.log("roe_data", row[0])
          let update_data = {};
          if (row[0].going == 0 && row[0].requested == 0) {
            update_data.going = 0
            update_data.requested = 1
          } else if (row[0].going == 0 && row[0].requested == 2) {
            update_data.going = 0
            update_data.requested = 1
          } else if (row[0].going == 1 && row[0].requested == 3) {
            update_data.going = 0
            update_data.requested = 0
          } else if (row[0].going == 0 && row[0].requested == 1) {
            update_data.going = 0
            update_data.requested = 1
          }
          /* update query */
          knex("event_invited_users")
            .where({
              event_id: req.body.event_id,
              invited_user_id: req.body.user_id
            })
            .update(update_data)
            .returning('*')
            .then(rows => {
              res.status(200).send(rows)
            }).catch((error) => {
              res.status(400).send(error)
            })
          /* end*/
        }
      } else {
        // lenth 0 6e
        let insert_data = {}
        if (data.current_user == 'true') {
          insert_data.going = 1
          insert_data.requested = 3
          insert_data.event_id = data.event_id
          insert_data.invited_user_id = data.invited_user_id
          insert_data.created_at = data.created_at
        } else {
          insert_data.going = 0
          insert_data.requested = 1
          insert_data.event_id = data.event_id
          insert_data.invited_user_id = data.invited_user_id
          insert_data.created_at = data.created_at
        }
        /* insert query */
        let query = knex("event_invited_users").insert(insert_data);
        query
          .then(response => {
            res.status(200).send(response);
          })
          .catch(error => {
            res.status(404).send(error);
          });
        /*end */
      }

    } else {
      // approval na hoy tyre 
      let update_data = {}
      if (row.length > 0) {
        // 0 krta vadhare 6e
        if (row[0].going == 1 && row[0].requested == 3) {
          update_data.going = 0
          update_data.requested = 0
        }
        else if (row[0].going == 0 && row[0].requested == 0) {
          update_data.going = 1
          update_data.requested = 3
        }
        /* update query */
        knex("event_invited_users")
          .where({
            event_id: req.body.event_id,
            invited_user_id: req.body.user_id
          })
          .update(update_data)
          .returning('*')
          .then(rows => {
            res.status(200).send(rows)
          }).catch((error) => {
            res.status(400).send(error)
          })
        /* end */
      } else {
        // 0 hoy to
        let insert_data = {}
        insert_data.going = 1
        insert_data.requested = 3
        insert_data.event_id = data.event_id
        insert_data.invited_user_id = data.invited_user_id
        insert_data.created_at = data.created_at
        /* insert query  */
        let query = knex("event_invited_users").insert(insert_data);
        query
          .then(response => {
            res.status(200).send(response);
          })
          .catch(error => {
            res.status(404).send(error);
          });
        /* end */
      }
    }
  })
})

router.post("/eventInviteFriendsdatasave", function (req, res) {
  var data = {
    from_id: req.body.from_id,
    to_id: req.body.to_id,
    event_id: req.body.event_id,
    notification_text: req.body.message
  };
  let tmp = [];
  asyncLoop(
    data.to_id,
    function (item, next) {
      //console.log("items",item)
      knex("event_invited_users")
        .count("*")
        .where({
          invited_user_id: item,
          event_id: req.body.event_id
        })
        .then(row => {
          if (row[0].count == 0) {
            knex("event_invited_users")
              .insert({
                event_id: data.event_id,
                invited_user_id: item,
                interested: 0,
                going: 0,
                created_at: moment().unix()
              })
              .returning("*")
              .then(row1 => {
                knex("notification")
                  .insert({
                    from_id: data.from_id,
                    to_id: item,
                    notification_type: 2,
                    notification_text: data.notification_text,
                    time: Math.floor(new Date().getTime() / 1000),
                    read_status: 1,
                    event_id: data.event_id
                  })
                  .then(row2 => {
                    knex
                      .select("*")
                      .from("users")
                      .where("id", item)
                      .then(row3 => {
                        tmp.push(row3[0].firebaseId);
                        next();
                      });
                  });
              });
          } else {
            next();
          }
        });
    },
    function () {
      res.status(200).send(tmp);
    }
  );
});

/* category wise and location wise filter data */
router.get("/filterEventData", function (req, res) {
  let current_timestamp = moment().unix()
  let query = knex.select("master_event_category.id as cat_id", "master_event_category.category_name","master_event_category.nr_value as norway_value","master_event_category.image_name",
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

  query.then(rows => {
  console.log("rows ", rows);
    res.status(200).send(rows)
  }).catch((error) => {
    console.log("error ", error);
    res.status(400).send(error)
  })
});

/*get all intrested user & going users */
router.post("/getAllgoingandIntrestedUser", function (req, res) {
  knex
    .select("event_invited_users.*","events.event_name","events.event_description","events.event_type","events.event_start_date","events.event_end_date","events.approval","events.event_location","events.event_lat","events.event_lng","events.created_by","events.timestamp","favourite.fav_user_id")
    //.select("*")
    .from("event_invited_users")
    .leftJoin("events", "event_invited_users.event_id", "events.event_id")
    .leftJoin("favourite","favourite.fav_user_id", "event_invited_users.invited_user_id")
    .where("event_invited_users.invited_user_id", req.body.user_id)
    .then(row => {
    console.log("row ", row);
      res.status(200).send(row);
    })
    .catch(error => {
      res.status(400).send(error);
    });
});

/* event request users */
router.post("/event_request_user", function (req, res) {
  let req_status = 1
  let query = knex("*")
    .from("event_invited_users")
    .leftJoin("users", "event_invited_users.invited_user_id", "users.id")
    .where("event_invited_users.event_id", req.body.event_id)
    .where("event_invited_users.requested", req_status)
    .andWhere("users.activeStatus", 1);
  query.then(row => {
    res.status(200).send(row)
  })
    .catch(error => {
      res.status(400).send(error)
    })

})
/*end*/


/* accept event invitation*/
router.post("/acceptEventInvite", function (req, res) {
  let query = knex("event_invited_users")
    .where('event_invited_users.event_id', req.body.event_id)
    .where('event_invited_users.invited_user_id', req.body.user_id)
    .update({
      going: '1',
      requested: '3'
    })
    .returning("*")
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})
/*end */



/* reject event  invitation*/
router.post("/rejectEventInvite", function (req, res) {
  let query = knex("event_invited_users")
    .where('event_invited_users.event_id', req.body.event_id)
    .where('event_invited_users.invited_user_id', req.body.user_id)
    .update({
      requested: '2'
    })
    .returning("*")
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})
/*end */

/**
 * get all users
 */
router.post("/getall", function (req, res) {
  let query = knex.select("users.*", "user_photos.image_name", "favourite.fav_user_id")
    .from("users")
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "users.id")
        .andOn("user_photos.profile_picture", 1)
    })
    .leftJoin("favourite", "favourite.fav_user_id", "users.id")
    .where("users.activeStatus", 1)
    .orderBy("users.firstname", "ASC")

  query.then((result) => {
    asyncLoop(
      result,
      function (item, next) {
        return new Promise((resolve, reject) => {
          resolve(
            knex.select("master_iam.value","master_iam.nr_value as norway_value")
              .from("user_iam")
              .leftJoin("master_iam", "master_iam.id", "user_iam.iam_status")
              .where("user_iam.user_id", item.id)
              .then((responseiam) => {
                item.userIam = responseiam;
                knex.select("master_myself.value","master_myself.nr_value as norway_value")
                  .from("user_consider_myself")
                  .leftJoin("master_myself", "master_myself.id", "user_consider_myself.myself_status")
                  .where("user_consider_myself.user_id", item.id)
                  .then((responseMyself) => {
                    item.userConsiderMyself = responseMyself;
                    knex.select("master_looking_for_friends.value","master_looking_for_friends.nr_value as norway_value")
                      .from("user_looking_friends")
                      .leftJoin("master_looking_for_friends", "master_looking_for_friends.id", "user_looking_friends.looking_friends")
                      .where("user_looking_friends.user_id", item.id)
                      .then((responseLooking) => {
                        item.userLookingForFriends = responseLooking;
                        next();
                      })
                      .catch((error) => {
                        console.log("error ", error);
                      })
                  })
                  .catch((error) => {
                    console.log("error ", error);
                  })
              })
              .catch((error) => {
                console.log("error ", error);
              })
          )
        })
      },
      function () {
        res.status(200).send(result)
      });
  }).catch(error => {
    res.status(400).send(error)
  })
})

/* cate category from event category wise */
router.post("/getEventCategory", function (req, res) {
  let query = knex.select('*','master_event_category.nr_value as norway_value')
    .from('master_event_category')
    .leftJoin('event_category', 'event_category.cat_id', 'master_event_category.id')
    .where('event_category.event_id', req.body.event_id)
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})
/* end */

/* get master event category id wise  */
router.post("/get_MasterCategory_IdWise", function (req, res) {
  let query = knex.select('master_event_category.id', "master_event_category.category_name as name","master_event_category.nr_value as norway_value")
    .from('master_event_category')
    .whereIn('master_event_category.id', req.body.id)
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})

/* last fout intested use get */
router.get("/intrestedUserGet", function (req, res) {
  let rowdata = []
  // let query = knex.select('event_invited_users.*', 'user_photos.*')
  //   .from('event_invited_users')
  //   .leftJoin('user_photos', 'event_invited_users.invited_user_id', 'user_photos.userid')
  //   .orderBy('event_invited_users.created_at', 'desc')
  //   .limit(4)
  //   .where('user_photos.position', '1')

  let query = knex.select(['event_id',
    knex.raw('array_agg(image_name ORDER BY created_at DESC) AS user_image'),
    knex.raw('array_agg(created_at ORDER BY created_at DESC) AS date_time'),
    knex.raw('array_agg(DISTINCT invited_user_id) AS users_ids')])
    .from('event_invited_users')
    .leftJoin('user_photos', function () {
      this.on('event_invited_users.invited_user_id', 'user_photos.userid')
        .andOn('user_photos.profile_picture', 1)
    })
    .where('event_invited_users.interested', 1)
    .groupBy('event_invited_users.event_id')
  //console.log("query ", query.toString());
  query.then(row => {
    row.map((value, index) => {
      var image_array = []
      value.user_image.map((v, i) => {
        if (v !== null) {
          image_array.push(v)
        } else {
          image_array.push('null')
        }
      })
      value.user_image = image_array
    })
    res.status(200).send(row)
  }).catch(error => {
    console.log("error ", error);
    res.status(400).send(error)
  })
})


router.post("/getIntrestedEventUserCount", function (req, res) {
  let count_query = knex('event_invited_users').count().where('event_invited_users.event_id', req.body.eventid).where('event_invited_users.interested', 1)
  count_query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})



router.post("/eventImages", function (req, res) {
  let count_query = knex('event_images').where('event_images.event_id', req.body.event_id)
  count_query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})

/* all intrestetd user list */
router.post("/getallIntrestedUser", function (req, res) {
  let query = knex
    .select(
      "event_invited_users.id",
      "users.firstname as name",
      "user_photos.image_name"
    )
    .from("event_invited_users")
    .leftJoin("users", "event_invited_users.invited_user_id", "users.id")
    .leftJoin("user_photos", "users.id", "user_photos.userid")
    .where("event_invited_users.event_id", req.body.event_id)
    .andWhere("user_photos.position", 1)
    .andWhere("event_invited_users.interested", 1)
  query.then(rows => {
    res.status(200).send(rows);
  }).catch(error => {
    res.status(400).send(error);
  })
})
/* end */

/* get events list by category id */
/* router.post("/eventCateListingBycateId", function (req, res) {
  let current_date = moment().unix()
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
    )
    .from(function () {
      this.select("events.*", "event_images.image_name as event_images", "users.id", "users.email", "users.firstname", "users.firebaseId", "users.username","event_category.id as event_category_id","event_category.event_id as event_category_event_id","event_category.cat_id as event_category_cat_id")
        //.distinct('event_images.event_id')
        .from("events")
        .leftJoin("event_images", "event_images.event_id", "events.event_id")
        .leftJoin("event_category", "event_category.event_id", "events.event_id")
        .leftJoin("users", "users.id", "events.created_by")
        .where("event_category.cat_id",req.body.cat_id)
        .andWhere("events.timestamp",">",current_date)
        .orderBy("events.event_start_date", "ASC")
        .as("allevents");
    });
  //console.log("query", query.toString())
  query
    .then(rows => {
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
}); */

router.post("/eventCateListingBycateId", function (req, res) {
  let current_date = moment().unix()
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
          //.leftJoin('events','event_invited_users.event_id','events.event_id')
          .where('user_photos.position', 1)
          .andWhere('event_invited_users.interested', 1)
          //.orderBy('event_invited_users.created_at','ASC')
          .andWhere('event_invited_users.event_id', knex.column("allevents.event_id"))
          .limit(4)
      },
    )
    .from(function () {
      this.select("events.*", "event_images.image_name as event_images", "users.id", "users.email", "users.firstname", "users.firebaseId", "users.username", "event_category.id as event_category_id", "event_category.event_id as event_category_event_id", "event_category.cat_id as event_category_cat_id")
        //.distinct('event_images.event_id')
        .from("events")
        .leftJoin("event_images", "event_images.event_id", "events.event_id")
        .leftJoin("event_category", "event_category.event_id", "events.event_id")
        .leftJoin("users", "users.id", "events.created_by")
        .where("event_category.cat_id", req.body.cat_id)
        .andWhere("events.timestamp", ">", current_date)
        .orderBy("events.event_start_date", "ASC")
        .as("allevents");
    });
  //console.log("query", query.toString())
  query
    .then(rows => {
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

router.post("/getGroupMemberImges", function (req, res) {
  let query = knex.select('group_details.groupid', 'group_details.userfirebaseid', 'users.firstname', 'user_photos.image_name')
    .from("group_details")
    .leftJoin("users", "group_details.userfirebaseid", "users.firebaseId")
    .leftJoin("user_photos", "users.id", "user_photos.userid")
    .where('group_details.groupid', req.body.groupid)
    .andWhere('user_photos.position', 1)
  query.then(row => {
    var final_array = {}
    row.map((val, index) => {
      final_array[val.userfirebaseid] = val.image_name
    })
    res.status(200).send(final_array)
  }).catch(error => {
    res.status(400).send(error)
  })
})

/* ======================================================================================== 02-05-2019 */

router.post("/getGroupMemberImges", function (req, res) {
  let query = knex.select('group_details.groupid', 'group_details.userfirebaseid', 'users.firstname', 'user_photos.image_name')
    .from("group_details")
    .leftJoin("users", "group_details.userfirebaseid", "users.firebaseId")
    .leftJoin("user_photos", "users.id", "user_photos.userid")
    .where('group_details.groupid', req.body.groupid)
    .andWhere('user_photos.position', 1)
  query.then(row => {
    var final_array = {}
    row.map((val, index) => {
      final_array[val.userfirebaseid] = val.image_name
    })
    res.status(200).send(final_array)
  }).catch(error => {
    res.status(400).send(error)
  })
})


/* create a new group data  */
router.post("/createNewGroup", function (req, res) {
  knex("groups")
    .insert({
      group_name: req.body.group_name,
      user_id: req.body.user_id,
      group_subject: req.body.group_subject,
      group_desc: req.body.group_desc,
      group_status: req.body.selectedItem == "Public" ? 0 : 1,
      approval: req.body.selectedItem == "Public" ? 0 : req.body.checked ? 1 : 0,
      created_date: Math.floor(new Date().getTime() / 1000),
      modified_date: Math.floor(new Date().getTime() / 1000),
    })
    .returning("*")
    .then(result => {
      knex("group_invitation_to_users")
        .insert({
          userfirebaseid: req.body.login_user_firebaseid,
          groupid: result[0].id,
          is_admin: 1,
          user_id: req.body.user_id,
          created_date: Math.floor(new Date().getTime() / 1000),
          modified_date: Math.floor(new Date().getTime() / 1000),
          requested: 3
        })
        .then(response => {
          knex("users").select("id", "firebaseId").whereIn("id", req.body.SelectedUserList)
            .then(user_response => {
              //console.log("user_response ", user_response);

              if (req.body.SelectedUserList.length > 0) {
                req.body.SelectedUserList.map((val, index) => {
                  console.log("val ", val);
                  let q = knex("notification")
                    .insert({
                      from_id: req.body.user_id,
                      to_id: val,
                      notification_type: 4,
                      notification_text: "fromusers invite to join group",
                      time: Math.floor(new Date().getTime() / 1000),
                      read_status: 1,
                      group_id: result[0].id
                    }).then(save_group_response => {
                    })
                })
              }

              user_response.map((val, index) => {
                knex("group_invitation_to_users")
                  .insert({
                    userfirebaseid: val.firebaseId,
                    groupid: result[0].id,
                    is_admin: 0,
                    user_id: val.id,
                    created_date: Math.floor(new Date().getTime() / 1000),
                    modified_date: Math.floor(new Date().getTime() / 1000),
                    requested: 3
                  })
                  .then(save_response => {
                  })
              })
            })
        })
      res.status(200).send(result)
    }).catch(error => {
      res.status(400).send(error)
    })
})
/* end */

// router.post("/group_listing_data", function (req, res) {
//   var query = knex
//     .select(
//       "*",
//       function () {
//         this.select([
//           knex.raw('array_agg(user_photos.image_name) AS user_images')])
//           .from('user_photos')
//           .where('user_photos.position', 1)
//           .andWhere('user_photos.userid', knex.column("allgroups.user_id"))
//       },
//       function () {
//         this.count({
//           group_member_count: "user_id"
//         })
//           .from("group_invitation_to_users")
//           .where({
//             groupid: knex.column("allgroups.id")
//           });
//       },
//       function () {
//         this.select([
//           knex.raw('array_agg(group_invitation_to_users.user_id) AS group_invited_user_id')])
//           .from('group_invitation_to_users')
//           .where({
//             groupid: knex.column("allgroups.id")
//           });
//       },
//     ).from(function () {
//       this.select("groups.modified_date", "groups.user_id", "groups.created_date", "groups.group_desc", "groups.group_subject", "groups.group_name", "groups.group_profile", "groups.id", "group_invitation_to_users.userfirebaseid", "group_invitation_to_users.is_admin", "groups.group_status")
//         .from("groups")
//         .leftJoin("group_invitation_to_users", "groups.id", "group_invitation_to_users.groupid")
//         .leftJoin("users", "groups.user_id", "users.id")
//         .where("group_invitation_to_users.user_id", req.body.user_id)
//         .orderBy('groups.modified_date', 'desc')
//         .as("allgroups");
//     });
//   query.then(rows => {
//     res.status(200).send(rows)
//   }).catch(error => {
//   console.log("error ", error);
//     res.status(400).send(error)
//   })
// })

router.post("/group_listing_data", function (req, res) {
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
          .leftJoin("users","group_invitation_to_users.user_id","users.id")
          .where({
            groupid: knex.column("allgroups.id")
          })
          .andWhere("users.activeStatus", 1)
      },
      function () {
        this.select([
          knex.raw('array_agg(group_invitation_to_users.user_id) AS group_invited_user_id')])
          .from('group_invitation_to_users')
          .where({
            groupid: knex.column("allgroups.id")
          });
      },
    ).from(function () {
      this.select("groups.modified_date", "groups.user_id", "groups.created_date", "groups.group_desc", "groups.group_subject", "groups.group_name", "groups.group_profile", "groups.id", "group_invitation_to_users.userfirebaseid", "group_invitation_to_users.is_admin", "groups.group_status", "groups.approval")
        .from("groups")
        .leftJoin("group_invitation_to_users", "groups.id", "group_invitation_to_users.groupid")
        .leftJoin("users", "groups.user_id", "users.id")
        .where("group_invitation_to_users.user_id", req.body.user_id)
        .andWhere("group_invitation_to_users.requested", 3)
        .orderBy('groups.modified_date', 'desc')
        .as("allgroups");
    });
    console.log("query", query.toString())
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    console.log("error ", error.message);
    res.status(400).send(error)
  })
})


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
          .leftJoin("users","group_invitation_to_users.user_id", "users.id")
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
      this.select("groups.modified_date", "groups.user_id", "groups.created_date", "groups.group_desc", "groups.group_subject", "groups.group_name", "groups.group_profile", "groups.id", "group_invitation_to_users.userfirebaseid", "group_invitation_to_users.is_admin", "groups.group_status", "groups.approval")
        .from("groups")
        .leftJoin("group_invitation_to_users", "groups.id", "group_invitation_to_users.groupid")
        .leftJoin("users", "groups.user_id", "users.id")
        .where("users.activeStatus",1)
        .orderBy('groups.modified_date', 'desc')
        .as("allgroups");
    });
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(400).send(error)
  })
})


router.post("/group_member_listing", function (req, res) {
  let query = knex.select('users.firstname', 'user_photos.image_name', 'users.country', 'users.dob', 'users.id as user_id', 'group_invitation_to_users.is_admin', 'group_invitation_to_users.modified_date', 'user_photos.position')
    .from("users")
    // .leftJoin("users", "user_photos.userid", "users.id")
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "users.id")
        .andOn(
          "user_photos.profile_picture", 1
        );
    })
    .leftJoin("group_invitation_to_users", "group_invitation_to_users.user_id", "user_photos.userid")
    .where('group_invitation_to_users.groupid', req.body.groupid)
    .andWhere('group_invitation_to_users.requested', 3)
    .andWhere('users.activeStatus', 1)
  // .andWhere('user_photos.position', 1)
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})

router.post("/updateNewGroup", function (req, res) {
  let group_update_data = {
    group_name: req.body.post_data.group_name,
    user_id: req.body.post_data.user_id,
    group_status: req.body.post_data.selectedItem == "Public" ? 0 : 1,
    approval: req.body.post_data.selectedItem == "Public" ? 0 : req.body.post_data.checked ? 0 : 1,
    group_subject: req.body.post_data.group_subject,
    group_desc: req.body.post_data.group_desc,
    modified_date: Math.floor(new Date().getTime() / 1000),
  }

  let query = knex("groups")
    .where("id", req.body.post_data.group_id)
    .update(group_update_data)
    .returning("*")

  query.then(response => {
    let delete_users = knex("group_invitation_to_users")
      .where("groupid", req.body.post_data.group_id)
      .andWhere("is_admin", 0)
      .del()
    delete_users.then(rows => {

      if (req.body.array_member.length > 0) {

        let delete_notification = knex("notification")
          .where("group_id", req.body.post_data.group_id)
          .del()
        delete_notification.then(rows => { })
        req.body.array_member.map((val, index) => {
          let insert = knex("notification")
            .insert({
              from_id: req.body.post_data.user_id,
              to_id: val,
              notification_type: 4,
              notification_text: "fromuser inviter til å delta i gruppe.",
              time: Math.floor(new Date().getTime() / 1000),
              read_status: 1,
              group_id: req.body.post_data.group_id
            })
          insert.then(rows_data => { })
        })
      }

      if (req.body.array_member.length > 0) {
        req.body.array_member.map((val, index) => {
          let update_data = knex("group_invitation_to_users")
            .insert({
              userfirebaseid: req.body.post_data.login_user_firebaseid,
              groupid: req.body.post_data.group_id,
              is_admin: 0,
              requested: 3,
              user_id: val,
              created_date: Math.floor(new Date().getTime() / 1000),
              modified_date: Math.floor(new Date().getTime() / 1000)
            })
          update_data.then(rows_data => {
          })
        })
      }
    })

    res.status(200).send(response)
  }).catch(error => {
    console.log("error", error)
  })
})

router.post("/saveGroupPostData", function (req, res) {
  knex("groups_post")
    .insert({
      user_id: req.body.user_id,
      groups_id: req.body.group_id,
      group_post_text: req.body.post_text,
      group_post_location: req.body.post_address,
      created_date: Math.floor(new Date().getTime() / 1000),
      modified_date: Math.floor(new Date().getTime() / 1000),
    })
    .returning("*")
    .then(result => {
      res.status(200).send(result)
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
      function () {
        this.count({
          comment_count: "groups_post_id"
        })
          .from("groups_post_comments")
          .where({
            groups_post_id: knex.column("groupspost.id")
          })
          .andWhere({
            groups_id: knex.column("groupspost.groups_id")
          })
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
        .andWhere("users.activeStatus",1)
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


router.post("/reportAbuseByUserId", function (req, res) {
  let query = knex.select('report_abuse.*')
    .from("report_abuse")
    .where('report_abuse.reported_by', req.body.user_id)
    .andWhere('report_abuse.group_id', req.body.group_id)
  query.then(row => {
    res.status(200).send(row)
  }).catch(error => {
    res.status(400).send(error)
  })
})


router.post("/addComment", function (req, res) {
  let query = knex("groups_post_comments")
    .insert({
      groups_post_id: req.body.post_data.group_post_id,
      comment_text: req.body.post_data.comment,
      user_id: req.body.post_data.user_id,
      groups_id: req.body.data,
      created_date: Math.floor(new Date().getTime() / 1000),
      modified_date: Math.floor(new Date().getTime() / 1000),
    })
    .returning("*")
  query.then(result => {
    res.status(200).send(result)
  }).catch(error => {
    res.status(400).send(error)
  })
})

router.post("/getCommentList", function (req, res) {
  var query = knex
    .select(
      "*",
      function () {
        this.select('user_photos.image_name AS user_images')
          .from('user_photos')
          .where('user_photos.position', 1)
          .andWhere('user_photos.userid', knex.column("groups_post.user_id"))
      },
    ).from(function () {
      this.select("groups_post_comments.comment_text", "groups_post_comments.groups_post_id", "groups_post_comments.id", "groups_post_comments.created_date", "groups_post_comments.modified_date", "users.username", "groups_post_comments.user_id", "groups_post_comments.created_date")
        .from("groups_post")
        .leftJoin("groups_post_comments", "groups_post.id", "groups_post_comments.groups_post_id")
        .leftJoin("users", "groups_post_comments.user_id", "users.id")
        //.orderBy("groups_post_comments.created_date", 'desc')
        .where("groups_post_comments.groups_post_id", req.body.group_post_id)
        .as("groups_post");
    });
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(400).send(error)
  })
})

router.post("/postlikeSaveData", function (req, res) {
  console.log("req.body ", req.body);
  let query = knex("groups_post_like")
    .insert({
      groups_post_id: req.body.group_post_id,
      user_id: req.body.post_data,
      groups_id: req.body.group_id,
      created_date: Math.floor(new Date().getTime() / 1000),
      modified_date: Math.floor(new Date().getTime() / 1000),
    })
  //.returning("*")
  query.then(result => {
    res.status(200).send(result)
  }).catch(error => {
    res.status(400).send(error)
  })
})

router.post("/postDislikeSaveData", function (req, res) {
  let query = knex("groups_post_like")
    .where("groups_post_id", req.body.group_post_id.id)
    .andWhere("user_id", req.body.post_data)
    .del()
  query.then(rows => {
    res.sendStatus(200);
  })
    .catch(error => {
      res.status(400).send(error);
    });
})

router.post("/getPostLikeList", function (req, res) {
  var query = knex
    .select(
      "*",
      function () {
        this.count({
          group_like_count: "groups_post_id"
        })
          .from("groups_post_like")
          .where({
            groups_post_id: knex.column("allgroups.groups_post_id")
          })
          .andWhere({
            groups_id: knex.column("allgroups.groups_id")
          })
      },
    ).from(function () {
      this.select('groups_post_like.id', 'groups_post_like.groups_post_id', 'groups_post_like.user_id', 'groups_post_like.groups_id')
        .from("groups_post_like")
        .where('groups_post_like.groups_id', req.body.groups_id)
        .returning("*")
        .as("allgroups");
    });
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(404).send(error)
  })
})

router.post("/leave_group", function (req, res) {
  let query = knex("group_invitation_to_users")
    .where("groupid", req.body.group_id)
    .andWhere("user_id", req.body.user_id)
    .del();
  query.then(() => {
    let query = knex("groups_post")
      .where("groups_id", req.body.group_id)
      .andWhere("user_id", req.body.user_id)
    query.then(post_data => {
      post_data.map((val, index) => {
        let delete_post = knex("groups_post")
          .where("groups_id", val.groups_id)
          .andWhere("user_id", val.user_id)
          .del()
        delete_post.then(() => {
          let delete_comment = knex("groups_post_comments")
            .where("groups_post_id", val.id)
            .andWhere("user_id", val.user_id)
            .del()
          delete_comment.then(() => {
            let delete_like = knex("groups_post_like")
              .where("groups_post_id", val.id)
              .andWhere("user_id", val.user_id)
              .del()
            delete_like.then(() => {
            })
          })
        })
      })
    })
    res.sendStatus(200);
  })
    .catch(error => {
      res.status(400).send(error);
    });
})

router.post("/leave_group_admin", function (req, res) {
  let query = knex("group_invitation_to_users")
    .where("groupid", req.body.group_id)
    .andWhere("user_id", req.body.user_id)
    .del();
  query.then(() => {
    let sel_query = knex("group_invitation_to_users")
      .where("groupid", req.body.group_id)
      .orderBy("id", "desc")
      .limit(1)
    sel_query.then(select_data => {
      let update = knex("group_invitation_to_users")
        .where("id", select_data[0].id)
        .update("is_admin", 1)
        .returning("*")
      update.then(() => {
        let query = knex("groups_post")
          .where("groups_id", req.body.group_id)
          .andWhere("user_id", req.body.user_id)
        query.then(post_data => {
          post_data.map((val, index) => {
            let delete_post = knex("groups_post")
              .where("groups_id", val.groups_id)
              .andWhere("user_id", val.user_id)
              .del()
            delete_post.then(() => {
              let delete_comment = knex("groups_post_comments")
                .where("groups_post_id", val.id)
                .andWhere("user_id", val.user_id)
                .del()
              delete_comment.then(() => {
                let delete_like = knex("groups_post_like")
                  .where("groups_post_id", val.id)
                  .andWhere("user_id", val.user_id)
                  .del()
                delete_like.then(() => {
                })
              })
            })
          })
        })
      })
    })
    res.sendStatus(200);
  })
    .catch(error => {
      res.status(400).send(error);
    });
})

router.post("/getallUserList", function (req, res) {
  let query = knex.select("users.*", "user_photos.image_name","favourite.fav_user_id")
    .from("users")
    .leftJoin("user_photos", function () {
      this.on("user_photos.userid", "users.id")
        .andOn("user_photos.profile_picture", 1)
    })
    .leftJoin("favourite", "favourite.fav_user_id", "users.id")
    .where("users.id", "!=", req.body.id)
    .andWhere("users.activeStatus", 1)
    .orderBy("users.firstname", "ASC")
  query.then((result) => {
    res.status(200).send(result)
  }).catch(error => {
    res.status(400).send(error)
  })
})

/* ============================= 08-05-2019 ============================= */
router.post("/delete_comment_by_uers", function (req, res) {
  let query = knex("groups_post_comments")
    .where("id", req.body.id)
    .del()
  query.then(rows => {
    res.sendStatus(200);
  })
    .catch(error => {
      res.status(400).send(error);
    });
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

router.post("/updateGroupPostData", function (req, res) {
  console.log("req ", req.body.post_data);
  if (req.body.post_data.edit_post_data.groups_images != "" && req.body.post_data.edit_post_data.groups_images != null) {
    console.log("if")
    if (req.body.post_data.edit_post_data.groups_images.path) {
      console.log("if1")
      let insert = knex("groups_post_image")
    } else {
      if (req.body.post_data.edit_post_data.groups_images != "" && req.body.post_data.edit_post_data.groups_images != null) {

      } else {
        console.log("else1")
        let imageEmpty = knex("groups_post_image")
          .where("groups_post_id", req.body.post_data.edit_post_data.id)
          .update("groups_images", "")
        imageEmpty.then(result => {
        })
      }
    }
  } else {
    let imageEmpty = knex("groups_post_image")
      .where("groups_post_id", req.body.post_data.edit_post_data.id)
      .update("groups_images", "")
    imageEmpty.then(result => {
    })
  }

  let get_data = {
    group_post_text: req.body.post_data.post_text,
    group_post_location: req.body.post_data.post_address,
    modified_date: Math.floor(new Date().getTime() / 1000),
  }
  let q = knex("groups_post")
    .where("id", req.body.post_data.edit_post_data.id)
    .update(get_data)
    .returning("*")
  console.log("Q", q.toString())
  q.then(result => {
    res.status(200).send(result)
  }).catch(error => {
    res.status(400).send(error)
  })
})
/* ============================= end 08-05-2019 ============================= */

router.post("/create_group_details", function (req, res) {
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
          .where({
            groupid: knex.column("allgroups.id")
          })
      },
      function () {
        this.select([
          knex.raw('array_agg(group_invitation_to_users.user_id) AS group_invited_user_id')])
          .from('group_invitation_to_users')
          .where({
            groupid: knex.column("allgroups.id")
          });
      },
    ).from(function () {
      this.select("groups.modified_date", "groups.user_id", "groups.created_date", "groups.group_desc", "groups.group_subject", "groups.group_name", "groups.group_profile", "groups.id", "group_invitation_to_users.userfirebaseid", "group_invitation_to_users.is_admin", "groups.group_status")
        .from("groups")
        .leftJoin("group_invitation_to_users", "groups.id", "group_invitation_to_users.groupid")
        // .leftJoin("users", "groups.user_id", "users.id")
        .where("groups.id", req.body.group_id)
        // .andWhere("group_invitation_to_users.requested", 3)
        .orderBy('groups.modified_date', 'desc')
        .limit(1)
        .as("allgroups");
    });
  console.log("query_akshay", query.toString())
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(400).send(error)
  })
})

router.post("/forgor_password_send_otp", function (req, res) {
  //const message = {code,error,msg,data}
  let query = knex('users')
    .where('users.email', req.body.email)
  query.then(rows => {
    if (rows.length > 0) {
      let check_mail = knex("users")
        .where("email", rows[0].email)
      check_mail.then(response => {
        //console.log("res",response)
        if (response[0].fb_id == null) {
          // console.log("null")
          //console.log("otp",Math.floor(100000 + Math.random() * 900000));
          var otp = Math.floor(1000 + Math.random() * 9000)
          let update_otp = knex("users")
            .where("users.email", req.body.email)
            .update({ forgot_password_otp: otp })
          //.returning("*")
          //console.log("query", update_otp.toString())
          update_otp.then(update_date => {
            let sel_query = knex("users")
              .where("users.email", req.body.email)
            sel_query.then(resp => {
              res.status(200).send({ code: 200, error: true, message: "success", response: resp[0], fb_id: "" })
            })
          })
        } else {
          //res.status(200).send(rows[0].fb_id = "")    
          res.status(200).send({ code: 200, error: true, message: "Sorry,your account is FB account,so please chnage FB account password", response: rows, fb_id: response[0].fb_id })
        }
      })
      //res.status(200).send(rows[0])
      //res.status(200).send({ code:200, error: true, message: "success", response: rows[0], fb_id: "" })
    } else {
      res.status(200).send({ code: 200, error: true, message: "email is not register", response: rows, fb_id: "" })
    }
  }).catch(error => {
    console.log("error", error)
  })
})


router.post("/reset_password", function (req, res) {
  // console.log("req ", req.body);
  // console.log("password", md5(req.body.new_password))
  let query = knex("users")
    .where("email", req.body.email)
  query.then(rows => {
    // update new password
    let update_password = knex("users")
      .where("email", req.body.email)
      .update({ password: md5(req.body.new_password) })
      .returning("*")
    //console.log("query", update_password.toString())
    update_password.then(rows_update => {
      let update_otp = knex("users")
        .where("email", req.body.email)
        .update({ forgot_password_otp: null })
      update_otp.then(update_data => {

      })
    })
    res.status(200).send(rows)
  }).catch(error => {
    console.log("error", error)
  })
})


router.post("/verify_otp", function (req, res) {
  //console.log("log", req.body)
  let query = knex("users")
    .where("forgot_password_otp", req.body.otp)
    .andWhere("email", req.body.email)
  query.then(rows => {
    //console.log("rows ", rows);
    if (rows.length > 0) {
      res.status(200).send(rows)
    } else {
      res.status(200).send(rows)
    }
  }).catch(error => {
    console.log("error", error)
  })
})

router.post("/GroupJoinRequested", function (req, res) {
  let requested = ""
  if (req.body.approval == 0 && req.body.group_status == 0) {
    requested = 3
  } else {
    requested = 1
  }
  let query = knex("group_invitation_to_users")
    .where("group_invitation_to_users.groupid", req.body.group_id)
    .andWhere("group_invitation_to_users.user_id", req.body.user_id)
  query.then(result => {
    console.log("row ", result);
    if (result.length > 0) {
      let query = knex("group_invitation_to_users")
        .where("group_invitation_to_users.groupid", req.body.group_id)
        .andWhere("group_invitation_to_users.user_id", req.body.user_id)
        .update("requested", requested)
        .returning("*")
      query.then(update => {
      })
    } else {
      knex("group_invitation_to_users")
        .insert({
          userfirebaseid: req.body.firebaseid,
          groupid: req.body.group_id,
          is_admin: 0,
          user_id: req.body.user_id,
          created_date: Math.floor(new Date().getTime() / 1000),
          modified_date: Math.floor(new Date().getTime() / 1000),
          requested: requested
        })
        .then(save_res => {

        })
    }
  })
    .then(save_response => {
      res.status(200).send(save_response)
    }).catch(error => {
      res.status(404).send(error)
    })
})

router.post("/acceptGroupInvitation", function (req, res) {
  let query = knex("group_invitation_to_users")
    .where("group_invitation_to_users.id", req.body.id)
    .update("requested", 3)
    .returning("*")
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(404).send(error)
  })
})

router.post("/getGroupRequestedUserList", function (req, res) {
  let query = knex.select("group_invitation_to_users.id", "group_invitation_to_users.groupid", "group_invitation_to_users.is_admin", "group_invitation_to_users.user_id", "group_invitation_to_users.requested", "users.username")
    .from("group_invitation_to_users")
    .leftJoin("users", "group_invitation_to_users.user_id", "users.id")
    .where("group_invitation_to_users.groupid", req.body.id)
    .andWhere("group_invitation_to_users.requested", 1)
  //.andWhere("group_invitation_to_users.requested", 3)
  //console.log("query",query.toString())
  query.then(rows => {
    res.status(200).send(rows)
  }).catch(error => {
    res.status(404).send(error)
  })
})

router.post("/rejectGroupInvitation", function (req, res) {
  console.log("req ", req.body);
  let query = knex("group_invitation_to_users")
    .where("group_invitation_to_users.id", req.body.id)
    .del()
  console.log("query", query.toString())
  query.then(rows => {
    res.sendStatus(200)
  }).catch(error => {
    res.status(404).send(error)
  })
})

router.post("/publicGroupJoinByUser", function (req, res) {
  let query = knex.select("group_invitation_to_users.id", "group_invitation_to_users.groupid", "group_invitation_to_users.is_admin", "group_invitation_to_users.user_id", "group_invitation_to_users.requested")
    .from("group_invitation_to_users")
    .where("group_invitation_to_users.groupid", req.body.group_id)
    .andWhere("group_invitation_to_users.user_id", req.body.user_id)
    .andWhere("group_invitation_to_users.requested", 3)
    .andWhere("group_invitation_to_users.is_admin", 0)
  query.then(rows => {
    console.log("rows***", rows)
    res.status(200).send(rows)
  }).catch(error => {
    res.status(404).send(error)
  })
})

// report abuse api
router.post("/saveReportAbuse", function (req, res) {
  console.log("req.body ", req.body);
  knex("report_abuse")
    .insert({
      group_id: req.body.group_id,
      reported_by: req.body.reported_by,
      reported_to: req.body.reported_to,
      post_id: req.body.post_id,
      reason: req.body.reason,
      created_date: Math.floor(new Date().getTime() / 1000)
    })
    .returning("*")
    .then(result => {
      res.status(200).send(result)
    }).catch(error => {
      res.status(400).send(error)
    })
})
// end

module.exports = router;
