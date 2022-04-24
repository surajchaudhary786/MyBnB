const express = require('express');
var mysql = require('mysql');
const app = express();
const bcrypt = require('bcrypt');
const randomstring = require('randomstring');

app.use(express.static('public'))
app.use(express.urlencoded({extended: false}));

app.listen(3300,()=>{
  console.log('Server is running');
});

app.get('/',function(req,res) {
    res.sendFile(path.join(__dirname, 'index.html'));
});
app.get('/submitLogin.html',function(req,res) {
  res.sendFile(path.join(__dirname, './submitLogin.html'));
});

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "mybnb" 
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});

app.post("/submitHost",express.urlencoded({extended:false}),(req,res)=>{
  console.log(req.body);
  const saltRounds = 10;
  const pwd = req.body.password;
  bcrypt.genSalt(saltRounds, function(err, salt) {
    bcrypt.hash(pwd, salt, function(err, hash) {  
      var sql = `INSERT INTO hosts VALUES ("${req.body.hostId}","${req.body.name}","${hash}","${req.body.panNo}",${req.body.phone})`;
      con.query(sql, function (err, result) {
        if (err) throw err;
        console.log("1 record inserted in hosts");
      });
    });
  });
  res.redirect('/register.html');
});
var curUser;
app.post("/submitLogin",express.urlencoded({extended:false}),(req,res)=>{
  curUser = req.body.accId;
  console.log(req.body);
  var sql = `SELECT password FROM User_View WHERE user_id="${req.body.accId}"`;
  con.query(sql, function (err, result,fields) {
    if (err) throw err;
    //console.log(result);
    hash=result[0].password;
    console.log(hash);
    bcrypt.compare(req.body.pwd, hash, function(err, result) {
      console.log(result);
    });
   });
   res.redirect("/submitLogin.html");
});

app.post("/submitSignUp",express.urlencoded({extended:false}),(req,res)=>{
  console.log(req.body);
  const saltRounds = 10;
  const pwd = req.body.password;
  bcrypt.genSalt(saltRounds, function(err, salt) {
    bcrypt.hash(pwd, salt, function(err, hash) {  
      var sql = `INSERT INTO users VALUES ("${req.body.userId}","${req.body.name}","${hash}",${req.body.age},"${req.body.gender}",${req.body.phone})`;
      con.query(sql, function (err, result) {
        if (err) throw err;
        console.log("1 record inserted in users");
        console.log(`${hash}`);
      });
    });
  });
  res.redirect('/register.html');
});

app.post("/submitBill",express.urlencoded({extended:false}),(req,res)=>{
  var avail = `SELECT availability from properties where property_id = "${req.body.propId}" `;
  con.query(avail, function (err, result) {
      if (err) throw err;
      var avil = Object.keys(result[0]).map((key) => [key, result[0][key]]);
      if(avil[0][1]=="No"){
        res.redirect('/unavailable.html');
      }
      else{
          var bookingId;
          bookingId = randomstring.generate(8);
          var sql = `SELECT Exists(select booking_id from bookings where booking_id = "${bookingId}") `;
          con.query(sql, function (err, result) {
            if (err) throw err;
            var res = Object.keys(result[0]).map((key) => [key, result[0][key]]);
            console.log(res[0][1]);
            if(res[0][1]==0);
            else
                bookingId = randomstring.generate(8);
          });
          let sqlProc = `CALL billAmt(?,?,?,?);`;
          var sql = `INSERT INTO bookings(booking_id,property_id,user_id,from_date,to_date) VALUES ("${bookingId}","${req.body.propId}","${curUser}","${req.body.fromDate}","${req.body.toDate}")`;
          con.query(sql, function (err, result) {
            if (err) throw err;
            console.log("1 record inserted in bookings");
          });
          con.query(sqlProc,[bookingId,req.body.propId,req.body.fromDate,req.body.toDate], function (err, result) {
            if (err) throw err;
            console.log("Amount updated in bookings");
          });
          res.redirect('/');
      }
    });
});