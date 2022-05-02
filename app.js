
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var logger = require('morgan');
var cors = require('cors')

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var signupRouter = require('./routes/signup');
var loginRouter = require('./routes/login');
var fileRouter = require('./routes/uploadFile');
var adminRouter = require('./routes/admin');
var jwt = require('jsonwebtoken');
var app = express();
var secretOrKey = 'c542e4078b0503ee7caa8a30b926997dedb1c200'
app.use(cors())
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(bodyParser.json({ limit: '200mb' }));
app.use(bodyParser.urlencoded({
  extended: false,
  limit: '200mb'
}));


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({
  extended: false
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/signup', signupRouter);
app.use('/login', loginRouter);
app.use('/uploadFile', fileRouter);
//app.use('/admin', adminRouter);
app.use('/admin', verifyToken, adminRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

//const PORT = 225;
const PORT = process.env.PORT || 225;

app.listen(PORT, function () {
  console.log("Server started on port " + PORT);
});

function verifyToken(req, res, next) {
 if (req.url == "/adminLogin") {
      next();
  } else if(req.url == "/ResetpasswordByAdmin"){
      next();
  }else if(req.url == "/checkResetPasswordUrl"){
    next();
  }else if(req.url == "/getAdminData"){
    next();
  }else if(req.url == "/resetPasswordCheckEmail"){
    next();  
  }else {
    //const bearerHeader = req.headers['Authorization']
    const bearerHeader = req.headers.authorization
   console.log("bearerHeader")
    if (typeof bearerHeader !== 'undefined') {
      //splie at the  space			
      const bearer = bearerHeader.split(' ');
      // get token from  array
      const bearerToken = bearer[1];
      //set the token
      req.token = bearerToken
      //next middleware
      jwt.verify(req.token, secretOrKey,(err) => {
        if (err) {
        console.log("err",err.message)
          // if(err.name == "TokenExpiredError"){
          //   var refreshedToken = jwt.sign({
          //     success: true,
          //     },secretOrKey, {
          //         expiresIn: '5m'
          //     });
          // request.apiToken = refreshedToken;
          // }
          // else if(err){
          //   res.status(401).send({ code: 401, error: true, message: "Token expired, please login again" })
          // }
          res.status(401).send({ code: 401, error: true, message: "Token expired, please login again" })
        } else {
                  console.log("call function")
          //request.apiToken = req.token;
          next();
        }
      })
    } else {
      //forbidden
console.log("else here")
      res.status(401).send({ code: 401, error: true, message: "Please pass token" })
    }
  }
}

module.exports = app;
