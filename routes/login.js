var express = require('express');
const knex = require('../knex/knex');
var router = express.Router();
const md5 = require('md5');
var uniqid = require('uniqid');
var trim = require('trim');
var moment = require('moment')

/* GET users listing. */
router.post('/', function (req, res, next) {
    //console.log("user_login ", req.body.email);
    knex('users').where({
        email: req.body.email,
        password: md5(req.body.password)
    }).then((rows) => {
        //console.log("rows ", rows);
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

            knex('user_access_token').returning('*').insert(access_data).then((result) => {
                knex.select('*').from('users').leftJoin('user_access_token', 'users.id', 'user_access_token.user_id').where({
                    token: trim(result[0].token)
                }).then((response) => {
                console.log("response ********", response);
                    res.status(200).send(response);
                })
            });

        })
    }).catch((error) => {
        console.log("error ", error);
        res.status(404).send(error);
    });
});

router.post('/getuserdata', function (req, res) {
 console.log("getuserdata", req.body);
    let query = knex.select(
            'users.id as userid',
            'users.email',
            'users.firstname',
            'users.lastname',
            'users.dob',
            'users.gender',
            'users.fb_id',
            'users.gmail_id',
            'users.firebaseId',
            'users.username',
            'users.mobileNumber',
            'users.location',
            'users.work_place',
            'users.work_position',
            'users.iam',
            'users.consider',
            'users.lookingForFriends',
            'users.inerest',
            'users.is_modified',
            'users.state',
            'users.country',
            'users.latitude',
            'users.longitude',
            'users.city',
            'users.mystory',
            'users.ageFrom',
            'users.ageTo',
            'users.distance',
            'users.county',
            'users.profile_completed',
            'users.postcode',
            'user_photos.image_name'
            // 'user_access_token.token'
        ).from('users')
        // .leftJoin(
        //     'user_access_token',
        //     'users.id', 'user_access_token.user_id'
        // )
        .leftJoin("user_photos", function () {
            this.on("user_photos.userid", "users.id")
            .andOn(
              "user_photos.profile_picture", 1
            );
          })
        .where({
            'users.email': trim(req.body.email)
            // 'user_access_token.status': '0'
        })

//  console.log("query ", query.toString());
        query.then((rows) => {
            if(rows.length > 0){
                res.status(200).send(rows[0]);
            } else {
                res.status(200).send(rows);
            }
        }).catch((err) => {
            res.status(404).send(err);
        });
});

router.post('/getNotification', function (req, res, next) {
    knex('notification').count('*').where({
            to_id: req.body.userid,
            read_status: '1'
        }).as('notiCount')
        .then((rows) => {
            res.status(200).send(rows[0]);
        }).catch((err) => {
            res.status(404).send(err);
        });
})

router.post('/checkEmail', function (req, res, next) {
    console.log("req.body.email ", req.body.email);
    knex('users').returning('*').where({
        email: req.body.email
    }).then((rows) => {
        if (rows.length == 0) {
            res.status(200).send({
                len: rows.length
            });
        } else {
            res.status(200).send({
                signup_from: rows[0].signup_from,
                already: 'already register',
                activeStatus: rows[0].activeStatus
            });
        }
    }).catch((error) => {
        res.status(404).send(error);
    });
});

router.post("/updatefcmtoken", function(req, res) {
    console.log("req.body ", req.body);
    knex('user_fcm_token').count('*').where({
        userid: req.body.id,
        fcm_token: req.body.fcmToken
    }).then((response) => {
        var access_data = {
            user_id: req.body.id,
            token: trim(uniqid()),
            time: Math.floor(new Date().getTime() / 1000),
            status: 0
        }
        if (response[0].count == 0) {
            knex('user_fcm_token').insert({
                userid: req.body.id,
                fcm_token: req.body.fcmToken,
                platform: req.body.userplatform
            }).then(() => {
                knex('user_access_token').insert(access_data).then((result) => {
                    res.status(200).send(result);
                });
            })
        } else {
            knex('user_fcm_token').update({
                fcm_token: req.body.fcmToken,
                platform: req.body.userplatform
            }).where({userid: req.body.id, fcm_token: req.body.fcmToken}).then(() => {
                knex('user_access_token').insert(access_data).then((result) => {
                    res.status(200).send(result);
                });
            })
        }
    }).catch((error) => {
        console.log("error ", error);
        res.status(404).send(error);
    });;
})

router.post('/saveAccessData', function (req, res, next) {
    console.log("save.email ", req.body.email);
    knex('users').returning('id').where('email', req.body.email).then((rows) => {
        var data = rows[0]
        var access_data = {
            user_id: data.id,
            token: trim(uniqid()),
            time: Math.floor(new Date().getTime() / 1000),
            status: 0
        }
        knex('user_access_token').insert(access_data).then((result) => {
            res.status(200).send(result);
        });
        
    }).catch((error) => {
        console.log("error ", error);
        res.status(404).send(error);
    });
});

/* add user into databse when user login with Facebook */
router.post('/addFbUser', function (req, res, next) {
    console.log("addfirstname ", req.body.firstname);
    console.log("addemail ", req.body.email);
    var fbUserData = {
        email: req.body.email,
        firstname: req.body.firstname,
        lastname: req.body.lastname,
        fb_id: req.body.facebook_id,
        signup_from: req.body.signup_from,
        created_time: req.body.created_time,
        firebaseId: req.body.firebaseId
    };

    knex('users').count('*').where({
        email: req.body.email
    }).then((row) => {
        if (row[0].count == 0) {
            knex('users').returning('*').insert(fbUserData).then((rows) => {
                var data = rows[0]
                var access_data = {
                    user_id: data.id,
                    token: trim(uniqid()),
                    time: Math.floor(new Date().getTime() / 1000),
                    status: 0
                }
                knex('user_fcm_token').insert({
                    userid: data.id,
                    fcm_token: req.body.fcmToken,
                    platform: req.body.userplatform
                }).then(() => {
                    knex('user_access_token').returning('*').insert(access_data).then((result) => {
                        knex.select('*').from('users').leftJoin('user_access_token', 'users.id', 'user_access_token.user_id').where({
                            token: trim(result[0].token)
                        }).then((response) => {
                            res.status(200).send(response);
                        })
                    });
                });
            });
            // res.status(200).send(rows[0].count);
        } else {
            res.status(200).send('already register');
        }
    });
});

// router.post('/addGmailUser', function(req, res, next) {
//     var gmailUserData = {email: req.body.email, firstname: req.body.givenName, lastname: req.body.familyName
//         , gmail_id: req.body.id, signup_from: 2, created_time: req.body.created_time};

//     knex('users').count('*').where({email: req.body.email}).then((rows) => {
//         if(rows[0].count == 0){
//             knex('users').returning('*').insert(gmailUserData).then((rows) => {
//                 res.status(200).send(rows);
//             });
//         } else {
//             res.status(200).send('already register');
//         }
//     });
// });

router.post('/userLogout', function (req, res, next) {
    knex('user_access_token').where('user_id', req.body.userid).update('status', 1).then((rows) => {
            if (rows > 0) {
                if (req.body.fcmtoken != undefined || req.body.fcmtoken != "") {
                    knex('user_fcm_token').where({
                        userid: req.body.userid,
                        fcm_token: req.body.fcmtoken
                    }).del().then(() => {
                        res.status(200).send({
                            rows
                        });
                    })
                } else {
                    knex('user_fcm_token').where({
                        userid: req.body.userid,
                        fcm_token: null
                    }).del().then(() => {
                        res.status(200).send({
                            rows
                        });
                    })
                }
            }
        })
        .catch((err) => {
            res.status(404).send(err);
        });
});

module.exports = router;