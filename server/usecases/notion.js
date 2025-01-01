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
        title: {
          title: [
            {
              type: 'text',
              text: {
                content: title || "Title Placeholder",
              },
            },
          ],
        },
        "Status": {
          "type": "select",
          "select": {
            "id": "1",
            "name": "To Do",
          }
        },
      },
      "children": [
        {
          "object": "block",
          "type": "paragraph",
          "paragraph": {
            "rich_text": [{ "type": "text", "text": { "content": description || "Desc Placeholder" } }]
          }
        }

      ],
    });
    console.log("Task created:", response.url);
    return response;
  } catch (error) {
    console.error("Error creating Notion task:", error);
    return {
      error: 'Error creating Notion task', details: error.toString()
    };
  }
}

module.exports = {
  createNotionTask
}

