var express = require('express');
const knex = require('../knex/knex.js');
const md5 = require('md5');
var router = express.Router();
var uniqid = require('uniqid');
var trim = require('trim');

/* GET users listing. */
router.post('/addUser', function (req, res, next) {
  var dataToPass = {
    username: req.body.firstname,
    firstname: req.body.firstname,
    email: req.body.email,
    // mobileNumber: req.body.mobileNumber,
    password: md5(req.body.password),
    firebaseId: req.body.firebaseId,
    created_time: req.body.created_time
  };

  knex('users').returning('*').insert(dataToPass).then((rows) => {
    var access_data = {
      user_id: rows[0].id,
      token: trim(uniqid()),
      time: Math.floor(new Date().getTime() / 1000),
      status: 0
    }
    knex('user_fcm_token').insert({
      userid: rows[0].id,
      fcm_token: req.body.fcmtoken,
      platform: req.body.userplatform
    }).then(() => {
      knex('user_access_token').returning('*').insert(access_data).then((result) => {
        knex.select('*').from('users').leftJoin('user_access_token', 'users.id', 'user_access_token.user_id').where({
          'user_access_token.token': trim(result[0].token)
        }).then((response) => {
          res.status(200).send(response);
        })
      });
    });
  });
});

/* Get all life status */
router.post('/get_life_status', function (req, res, next) {
  knex.select("id", "value as name","nr_value as norway_value")
    .from("life_status")
    .orderBy('life_status.value', 'asc')
    .then((rows) => {
 //console.log("rows get_life_status", rows);
      res.status(200).send(rows);
    }).catch((err) => {
      res.status(404).send(err);
    });
})

/* get all master data of looking friends, myself and iam */
router.post('/get_master_data_step3', function (req, res, next) {
  knex.select("id", "value as name","nr_value as norway_value").from("master_looking_for_friends").then((rows) => {
    knex.select("id", "value as name","nr_value as norway_value").from("master_myself").then((row) => {
      knex.select("id", "value as name","nr_value as norway_value").from("master_iam").then((rows1) => {
        res.status(200).send({
          lookingFriends: rows,
          myself: row,
          iamdata: rows1
        });
      })
    })
  }).catch((err) => {
    res.status(404).send(err);
  });
})
/* end get all master data of looking friends, myself and iam */

module.exports = router;
