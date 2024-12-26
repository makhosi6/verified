const { Client } = require("@notionhq/client");

const NOTION_DATABASE_ID = process.env.NOTION_DATABASE_ID || 'database_id'
const NOTION_TOKEN = process.env.NOTION_TOKEN || 'notion_token'
const notion = new Client({ auth: NOTION_TOKEN });

/**
 * 
 * @param {string} title 
 * @param {string} description 
 * @returns {object}
 */
async function createNotionTask(title, description) {
  try {
    const response = await notion.pages.create({
      parent: { database_id: NOTION_DATABASE_ID },
      properties: {
        Name: { title: [{ text: { content: title } }] },
        Description: { rich_text: [{ text: { content: description } }] },
        Tags: {
          multi_select: process.env.NOTION_USERS.split(',').map(email => ({ name: email })),
        },
      },
    });

    console.log("Task created:", response.url);
    return response;
  } catch (error) {
    console.error("Error creating Notion task:", error);
    return {
        error: 'Error creating Notion task', response
    };
  }
}

module.exports = {
    createNotionTask
}

