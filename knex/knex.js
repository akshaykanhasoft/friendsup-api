const environment = process.env.ENVIRONMENT || 'development'
const config = require('../knexfile')[environment];
const database = require('knex')(config);
module.exports = database;