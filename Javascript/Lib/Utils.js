"use strict";
/***************************************************************************************************
Name: Utils.js                         Author: Brendan Furey                       Date: 30-Jul-2017

Javascript (Nodejs) component of polyglot project: a simple file-reading and group-counting module,
with mainprogram, unit testing program, code timing and general utility packages, implemented in 
multiple languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  *Utils*    |
|  Tester  |             |  Timer Set  |
========================================

Module for general utility methods.

***************************************************************************************************/
const fs = require('fs');
var outFile;
//exports.write = function (line) { outFile.write (line) };
exports.write = function (line) { console.log (line) };

/***************************************************************************************************

heading: Prints a title with "=" underlining to its length, preceded by a blank line

***************************************************************************************************/
exports.heading = function (title) {exports.write ('\n' + title + '\n' + '='.repeat(title.length) )}; // heading string

/***************************************************************************************************

prListAsLine: Prints an array of strings as one line, separating fields by a 2-space delimiter

***************************************************************************************************/
exports.prListAsLine = function (items) {exports.write (items.join ('  '))}; // array of strings to print as line

/***************************************************************************************************

rJust, lJust: Right/left-justify a string

***************************************************************************************************/
exports.rJust = function (name, len) {return ' '.repeat(len - name.length) + name}; // string to print, width
exports.lJust = function (name, len) {return name + ' '.repeat(len - name.length)}; // string to print, width

/***************************************************************************************************

colHeaders: Prints a set of column headers, input as arrays of values and length/justification's

***************************************************************************************************/
exports.colHeaders = function (items) { // array of {name, length} objects, length < 0 -> left-justify

    let strings = items.map(function(j) {return j.len < 0 ? exports.lJust(j.name, -j.len) : exports.rJust(j.name, j.len)});
    exports.write(strings.join ('  '));
    let unders = strings.map(function(j) {return '-'.repeat(j.length)})
    exports.write(unders.join ('  '));
    return unders.join ('  ');
};

/***************************************************************************************************

maxLen: Returns maximum length of string in a list of strings

***************************************************************************************************/
exports.maxLen = function (items) { // list of strings
    return Array.from(items.keys()).reduce(function (a, b) { return a.length > b.length ? a : b; }).length;
};

/***************************************************************************************************

Logger: File writing helper class - not used for now

***************************************************************************************************/
exports.Logger = class {
    constructor (filename) {
        this.file = fs.createWriteStream (filename);
    };
    write (line) { this.file.write (line + '\n'); };
    close () { this.file.end(); };
};

exports.init = function (filename) { outFile = new exports.Logger (filename); };
exports.exit = function () { outFile.close(); };
