var express = require('express');
const knex = require('../knex/knex');
const md5 = require('md5');
var router = express.Router();
var uniqid = require('uniqid');
var trim = require('trim');
var fs = require('fs');
var multer = require('multer');
var upload = multer({
    dest: 'public/uploads/'
});
var moment = require('moment')

const type = upload.single('userPhoto');

router.post('/', type, (req, res, next) => {
    console.log("req ", req.file);
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 15; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }

    var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");

    // var filename = req.file.filename + '.jpg';
    var filename = text+time + '.jpg';
    var target_path = 'public/uploads/' + filename;

    console.log("req.file.path ", req.file.path);
    var src = fs.createReadStream(req.file.path);
    var dest = fs.createWriteStream(target_path);
    src.pipe(dest);
    if (req.body.position == 1) {
        var access_data = {
            userid: req.body.userid,
            image_name: filename,
            profile_picture: 1,
            position: req.body.position
        }
    } else {
        var access_data = {
            userid: req.body.userid,
            image_name: filename,
            position: req.body.position
        }
    }
    knex('user_photos').count('*').where({
        userid: req.body.userid,
        position: req.body.position
    }).then((result) => {
        if (result[0].count > 0) {
            knex('user_photos')
                .where({
                    userid: req.body.userid,
                    position: req.body.position
                })
                .update(access_data)
                .returning('*')
                .then((rows) => {
                    res.status(200).send({
                        rows
                    });
                }).catch((error) => {
                    res.status(404).send(error);
                })
        } else {
            knex('user_photos').returning('*').insert(access_data).then((rows) => {
                res.status(200).send({
                    rows
                });
            });
        }
    });
});

/**
 * upload event image
 */
const tmp = upload.single('eventPhoto')
router.post('/eventimage', tmp, (req, res, next) => {
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
    console.log("req.file.filename ", req.file);
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
    var access_data = {
        event_id: req.body.eventid,
        image_name: filename,
        created_at: moment().unix()
    }
    // console.log("access_data ", access_data);
    knex('event_images').returning('*').insert(access_data).then((rows) => {
            res.status(200).send(rows);
        })
        .catch((error) => {
            res.status(400).send(error);
        });
});

/**
 * upload group image
 */
const groupimage = upload.single('groupPhoto')
router.post('/groupimage', groupimage, (req, res, next) => {
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
    console.log("req.file.filename ", req.file);
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

    let query = knex("master_groups")
    .update({
      group_image: filename
    })
    .returning("*")
    .where("group_id", req.body.groupid);
    query.then((rows) => {
            res.status(200).send(rows);
        })
        .catch((error) => {
            res.status(400).send(error);
        });
});

const tmp_update = upload.single('eventUpdatePhoto')
router.post('/updatEventImages', tmp_update, (req, res, next) => {
    var image_data = JSON.parse(req.body.remove_images);
    if (image_data != "" && image_data != null && image_data != undefined) {
        if (image_data.length > 0) {
            let delete_images = knex("event_images")
                .whereIn("image_name", image_data)
                .where("event_id", req.body.eventid)
                .del()
            console.log("del", delete_images.toString())
            delete_images.then(rows => {
                console.log("rows", rows)
            }).catch(error => {
                console.log("error", error)
            })
        }
    }
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
    //console.log("req.file.filename ", req.file);
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
    var access_data = {
        event_id: req.body.eventid,
        image_name: filename,
        created_at: moment().unix()
    }
    knex('event_images').returning('*').insert(access_data).then((rows) => {
        res.status(200).send(rows);
    })
        .catch((error) => {
            res.status(400).send(error);
        });
});

/* Delete image from database */
router.post('/deleteimage', (req, res, next) => {
    console.log("req.bodyxxxxxxx ", req.body);
    switch (req.body.image) {
        case "profile":
            {
                var image = 1;
                break;
            }
        case "1":
            {
                var image = 1;
                break;
            }
        case "2":
            {
                var image = 2;
                break;
            }
        case "3":
            {
                var image = 3;
                break;
            }
        case "4":
            {
                var image = 4;
                break;
            }
        case "5":
            {
                var image = 5;
                break;
            }
    }
    let query = knex('user_photos')
    .returning('image_name')
    .where({
        userid: req.body.id,
        position: image
    })
    .del()
    console.log("query ", query.toString());

    knex('user_photos')
        .returning('image_name')
        .where({
            userid: req.body.id,
            position: image
        })
        .del()
        .then((rows) => {
            fs.unlink('public/uploads/' + trim(rows[0]), (err) => {
            if (err){

            }

                console.log(trim(rows[0]) + ' was deleted');
            });
            res.status(200).send("success");
        })
        .catch((error) => {
            console.log("error ", error);
            res.status(500).send(error);
        })

});

/**
 * upload chat image
 */
const chatImg = upload.single('chatPhoto')
router.post('/chatimage', chatImg, (req, res, next) => {
    var time = moment().unix();
    console.log("time ", time);

    var filename = time + '.jpg';
    var target_path = 'public/chats/' + filename;

    var src = fs.createReadStream(req.file.path);
    var dest = fs.createWriteStream(target_path);
    src.pipe(dest);
    
    res.status(200).send(filename);
    
});


/* ================== 03-05-2019 ==================== */
/**
 *  new group post images 
 */
const groups_photo = upload.single('groups_photo')
router.post('/groups_image', groups_photo, (req, res, next) => {
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
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
    let query = knex("groups")
        .update({
            group_profile: filename
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

/*
 group post upload images
 */
 
 const updateGroupsPhoto = upload.single('updateGroupsPhoto')
router.post('/update_groups_image', updateGroupsPhoto, (req, res, next) => {
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
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
    let query = knex("groups")
        .update({
            group_profile: filename
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




/*
 group post upload images
 */
const groups_post_images = upload.single('groups_post_images')
router.post('/save_group_post_image', groups_post_images, (req, res, next) => {
 console.log("req ", req.body.group_post_id);

    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
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
    let query = knex("groups_post_image")
        .insert({
            groups_post_id:req.body.group_post_id,
            groups_images: filename,
            created_date: Math.floor(new Date().getTime() / 1000),
            updated_date: Math.floor(new Date().getTime() / 1000)
        })
        .returning("*")
    query.then((rows) => {
        res.status(200).send(rows);
    })
        .catch((error) => {
            res.status(400).send(error);
        });
});
/* end */
/* =================== end 03-05-2019 ===================== */

// const upate__groups_post_images = upload.single('upate__groups_post_images')
// router.post('/update_group_post_image', upate__groups_post_images, (req, res, next) => {
//     // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
//     console.log("update",req.body)
//     var text = "";
//     var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

//     for (var i = 0; i < 15; i++) {
//         text += possible.charAt(Math.floor(Math.random() * possible.length));
//     }
//     var filename = text + '.jpg';
//     var target_path = 'public/uploads/' + filename;

//     var src = fs.createReadStream(req.file.path);
//     var dest = fs.createWriteStream(target_path);
//     src.pipe(dest);
//     let query = knex("groups_post_image")
//         .update({
//             groups_images: filename,
//             updated_date: Math.floor(new Date().getTime() / 1000)
//         })        
//         .returning("*")
//         .where("groups_post_id", req.body.group_post_id);
//         console.log("query",query.toString())
//     query.then((rows) => {
//         res.status(200).send(rows);
//     })
//         .catch((error) => {
//             res.status(400).send(error);
//         });
// });
/* end */


const upate__groups_post_images = upload.single('upate__groups_post_images')
router.post('/update_group_post_image', upate__groups_post_images, (req, res, next) => {
    // var time = Date.parse(new Date(), "UTC:yyyy/mm/dd h:MM:ss");
    var get_post_data = JSON.parse(req.body.post_data);
    console.log("get_post_data ", get_post_data);

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

    if (get_post_data.edit_post_data.groups_images != "") {
        console.log("if")
        if (get_post_data.edit_post_data.groups_images.path) {
            console.log("if1")
            let insert = knex("groups_post_image").where("groups_post_id", get_post_data.edit_post_data.id)
                .then(response => {
                    console.log("response ", response);
                    if (response.length == 0) {
                        console.log("res_is");
                        let save_image = knex("groups_post_image")
                            .insert({
                                groups_post_id: get_post_data.edit_post_data.id,
                                groups_images: filename,
                                created_date: Math.floor(new Date().getTime() / 1000),
                                updated_date: Math.floor(new Date().getTime() / 1000)
                            })
                            .returning("*")
                        save_image.then((rows) => {
                        })
                    }else{
                        console.log("res_else");
                    }
                })
        } else {
            if (get_post_data.edit_post_data.groups_images != "") {
                console.log("else if")
            } else {
                console.log("else1")
                let imageEmpty = knex("groups_post_image")
                    .where("groups_post_id", get_post_data.edit_post_data.id)
                    .update("groups_images", "")
                imageEmpty.then(result => {
                })
            }
        }
    } else {
        console.log("else")
        let imageEmpty = knex("groups_post_image")
            .where("groups_post_id", req.body.post_data.edit_post_data.id)
            .update("groups_images", "")
        imageEmpty.then(result => {
        })
    }

    let query = knex("groups_post_image")
        .update({
            groups_images: filename,
            updated_date: Math.floor(new Date().getTime() / 1000)
        })
        .returning("*")
        .where("groups_post_id", req.body.group_post_id);
    //console.log("query",query.toString())
    query.then((rows) => {
        res.status(200).send(rows);
    })
        .catch((error) => {
            res.status(400).send(error);
        });
});
/* end */

module.exports = router;
