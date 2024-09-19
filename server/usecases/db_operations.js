const express = require('express');
const jsonServer = require("json-server");
const path = require("node:path");
/**
 * Get all items collection.
 * 
 * @param {express.Router | string} router 
 * @returns {Array}
 */
function getAll(router) {
    if (typeof router === 'string')
        router = jsonServer.router(path.resolve(`../../server/apps/store/db/${router}.json`))
    return router.db.get('resource').value();
}

/**
 * 
 * @param {express.Router | string} router 
 * @param {string|number} id
 * @returns {Object|null} - The item if found, or null if not found.
 */
function getOne(router, id) {
    if (typeof router === 'string')
        router = jsonServer.router(path.resolve(`../../server/apps/store/db/${router}.json`))
    return router.db.get('resource').find({ id }).value() || null; // Find the item by ID
}

/**
 * Create a new item collection.
 * 
 * @param {express.Router | string} router 
 * @param {Object} newItem
 * @returns {Object} - The newly created item, including id
 */
function createItem(router, newItem) {
    if (typeof router === 'string')
        router = jsonServer.router(path.resolve(`../../server/apps/store/db/${router}.json`))
    router.db.get('resource').push(newItem).write();
    return newItem;
}

/**
 * Update item
 * 
 * @param {express.Router | string} router 
 * @param {string|number} id 
 * @param {Object} updatedItem 
 * @returns {Object|null} 
 */
function updateItem(router, id, updatedItem) {
    if (typeof router === 'string')
        router = jsonServer.router(path.resolve(`../../server/apps/store/db/${router}.json`))
    const item = router.db.get('resource').find({ id });
    if (item.value()) {
        item.assign(updatedItem).write();
        return item.value();
    }
    return null;
}

/**
 * Delete from collection 
 * 
 * @param {express.Router | string} router 
 * @param {string|number} id 
 * @returns {boolean} - Returns true if the item was deleted, false if not found.
 */
function deleteItem(router, id) {
    if (typeof router === 'string')
        router = jsonServer.router(path.resolve(`../../server/apps/store/db/${router}.json`))
    const deleted = router.db.get('resource').remove({ id }).write();
    return deleted.length > 0;
}

module.exports = {
    getAll, getOne, updateItem, createItem, deleteItem
}