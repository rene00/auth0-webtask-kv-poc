'use strict';

var wt = require('webtask-tools');
var express = require('express');
var app = express();
var bodyParser = require('body-parser');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

app.get('/', (req, res) => {
    req.webtaskContext.storage.get(function(err, data) {
        data = data || {};
        res.send(data);
    });
});

app.get('/:k', (req, res) => {
    var k = req.params.k;
    req.webtaskContext.storage.get(function(err, data) {
        data = data || {};
        if (data[k]) {
            console.log("found", data[k]);
            res.send(data[k]);
        } else {
            res.sendStatus(404);
        }
    });
});

app.post('/', (req, res) => {
    var k = req.body.key;
    var v = req.body.value;
    if (k && v) {
        req.webtaskContext.storage.get(function(error, data) {
            if (data == undefined) {
                data = {};
            }
            var k = req.body.key;
            var v = req.body.value;
            data[k] = v;
            req.webtaskContext.storage.set(
                data, {force: 1}, function() {
                    console.log("saved ", k, ":", v);
                    res.sendStatus(201);
                }
            );
        });
    } else {
        res.sendStatus(400);
    }
});

app.delete('/:k', (req, res) => {
    var k = req.params.k;
    req.webtaskContext.storage.get(function(err, data) {
        if (data == undefined || data[k] == undefined) {
            console.log(k, "not found");
            res.sendStatus(404);
        } else {
            delete data[k];
            req.webtaskContext.storage.set(
                data, {force: 1}, function() {
                    console.log("deleted ", k);
                    res.sendStatus(200);
                }
            );
        }
    });
});

module.exports = wt.fromExpress(app);
