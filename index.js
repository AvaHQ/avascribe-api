#!/usr/bin/env node

const dtsGenerator = require('dtsgenerator').default;
const fs = require('fs');
const _ = require('lodash');
const yargs = require('yargs');

const types = {};

function pascalCase(s) {
    s = _.camelCase(s);
    return `${s[0].toUpperCase()}${s.substring(1)}`;
}

function addType(t, n) {
    types[t] = types[t] ? types[t] : [];
    if (!types[t].includes(n)) {
        types[t].push(n);
    }
}

function typeNameConvertor(id) {
    let name = id.inputId;
    let array = name.split(':');
    name = pascalCase(name);
    if (array.length === 2) {
        let tn = pascalCase(array[0]);
        addType(tn, name);
    }
    return [name];
}

const getAlias = (jsonschema) => {
    let ids = [jsonschema.$id].concat(jsonschema.$$alias || []);
    return ids.map((id) => {
        const newSchema = JSON.parse(JSON.stringify(jsonschema));
        newSchema.$id = id;
        return newSchema;
    });
};

async function main(files) {
    let contents = files.map((filename) => JSON.parse(fs.readFileSync(filename, 'utf-8')));
    contents = contents.map((j) => getAlias(j));
    let flat = [];
    for (let c of contents) {
        flat.push(...c);
    }
    let result = await dtsGenerator({ contents: flat, typeNameConvertor });
    Object.keys(types).forEach((t) => {
        result += `\nexport type ${t} = ${types[t].join(' | ')};\n`;
    });
    console.log(result);
}

main(yargs.argv._);
