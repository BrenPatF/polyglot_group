"use strict";
/***************************************************************************************************
Name: TestColGroup.js                  Author: Brendan Furey                       Date: 30-Jul-2017

Javascript (Nodejs) component of polyglot project: a simple file-reading and group-counting module,
with mainprogram, unit testing program, code timing and general utility packages, implemented in 
multiple languages for learning purposes: https://github.com/BrenPatF/polyglot_group

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

========================================
|  Driver  |  Class/API  |  Utility    |
===========|=============|==============
|  Main    |  Col Group  |  Utils      |
| *Tester* |             |  Timer Set  |
========================================

Unit test program.

Notes:
- uses no framework, only assert
- ava briefly tried but rejected for issues with stdout
- exceptions caught so as to report on full set of tests

***************************************************************************************************/
const Utils = require ('../Lib/Utils.js');
const ColGroup = require ('../Lib/ColGroup.js');
const TimerSet = require ('../Lib/TimerSet.js');
const fs = require('fs');
const assert = require('assert');

const INPUT_FILE = '../../Input/ut_group.csv'

// setup data indexed by scenario
const DELIM = [',', ';;'];
const COL = [2, 0];
const LINES = ["0,1,Cc,3\n00,1,A,9\n000,1,B,27\n0000,1,A,81\n",
               "X;;1;;A\nX;;1;;A\n"];

// expected values for as is list just counts, with arrays of 2-tuples for sorted lists
const expAsis = [3, 2]; // 2 is deliberately wrong, 1 is the correct value
const expK = [[["A",2],["Bx",1],["Cc",1]], [["X",2]]]; // Bx is deliberately wrong, B is the correct value
const expV = [[["B",1],["Cc",1],["A",2]], [["X",2]]];

var     nTst = 0;
var     nErr = 0;

function setup (datasetNum) { // scenario index

    fs.writeFileSync (INPUT_FILE, LINES[datasetNum]);
    return new ColGroup (INPUT_FILE, DELIM[datasetNum], COL[datasetNum]);
};

function teardown() {
    fs.unlinkSync (INPUT_FILE);
};

function test (name, act, exp) {

    nTst++;
    try {
        assert.deepEqual (act, exp);
        Utils.write (Utils.lJust ('...' + name, 30) + 'OK');
    }
    catch (oException) {
        Utils.write ('*** ' + oException.message);
        Utils.write (Utils.lJust ('...' + name, 30) + 'NOT OK');
        nErr++;
    }
    teardown();

};

for (let i = 0; i < LINES.length; i++) {
    Utils.write ('Scenario ' + i + '...');
    test ('listAsIs',       setup(i).listAsIs().length, expAsis[i]);
    test ('sortByKey',      setup(i).sortByKey(),       expK[i]);
    test ('sortByValue',    setup(i).sortByValue(),     expV[i]);
};
Utils.heading ('Summary: ' + nTst + ' tests run, ' + nErr + ' failed.');
