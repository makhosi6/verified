const { v4 } = require('uuid')
crypto = require('node:crypto');
const array = "declaration file for module 'uuid'. ".split('')
for (let index = 0; index < array.length; index++) {
    const randomUUID = typeof crypto !== 'undefined' && crypto.randomUUID && crypto.randomUUID.bind(crypto);
    console.log(index, v4(), '\n',randomUUID());
}
