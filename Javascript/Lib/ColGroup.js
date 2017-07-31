"use strict";
/***************************************************************************************************
Name: ColGroup.js                      Author: Brendan Furey                       Date: 30-Jul-2017

Javascript (Nodejs) component of polyglot project: a simple file-reading and group-counting module,
with mainprogram, unit testing program, code timing and general utility packages, implemented in 
multiple languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    | *Col Group* |  Utils      |
|  Tester  |             |  Timer Set  |
========================================

Object reads delimited lines from file, and counts values in a given column, with methods to return
or print the counts in various orderings.

***************************************************************************************************/
const Utils = require ('./Utils.js');
/***************************************************************************************************

_readList: Private function returns the key-value map of (string, count)

***************************************************************************************************/
function _readList (file, delim, col) { // input file, field delimiter, 0-based column index
    const fs = require('fs');
    const lines=fs.readFileSync(file).toString().trim().split("\n");
    var counter = new Map();
    let iter = 0;
    for (const line of lines) {
        let val = line.split(delim)[col];
        let newVal = counter.get(val) + 1 || 1;
        counter.set(val, newVal);
    }
    return counter;
}

class ColGroup{

    /***************************************************************************************************

    ColGroup: Constructor sets the key-value map of (string, count), and the maximum key length

    ***************************************************************************************************/
    constructor (file, delim, col) {
        this.counter = _readList(file, delim, col);
        this.maxLen = Utils.maxLen (this.counter);
    }
    /***************************************************************************************************

    prList: Prints the key-value list of (string, count) sorted as specified

    ***************************************************************************************************/
    prList (sortBy, keyValues) { // sort by label, key-value list of (string, count)
    
        Utils.heading ('Counts sorted by '+sortBy);
        Utils.colHeaders([{name: 'Team', len : -this.maxLen}, {name : '#apps', len : 5}]);
        for (const kv of keyValues) { Utils.write(Utils.lJust(kv[0], this.maxLen) + '  ' + Utils.rJust(kv[1], 5)); };
    };

    /***************************************************************************************************

    listAsIs: Returns the key-value list of (string, count) unsorted

    ***************************************************************************************************/
    listAsIs () {
        return [...this.counter];
    };

    /***************************************************************************************************

    sortByKey, sortByValue: Returns the key-value list of (string, count) sorted by key or value

    ***************************************************************************************************/
    sortByKey () {
        return Array.from(this.counter.entries()).sort(function(a, b) { return a[0] > b[0] ? 1 : -1; });
    };

    sortByValue () {
        return [...this.counter].sort(function(a, b) { return (a[1] - b[1]) || (a[0] > b[0] ? 1 : -1); });
    };
}
module.exports = ColGroup;