var request = require('request');


const notifyAdmin = async (req, res) => {
    const send = _logTicket(req.body)
    // call whatsapp bot
    res.sendStatus(200);
}

function _logTicket(body){
    var options = {
      'method': 'POST',
      'url': 'http://localhost:4343/api/v1/tickets/resource/',
      'headers': {
        'x-nonce': 'MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer TOKEN'
      },
      body: JSON.stringify(body)
    
    };
    request(options, function (error, response) {
      if (error) throw new Error(error);
    });
}



module.exports = {
    notifyAdmin,
}