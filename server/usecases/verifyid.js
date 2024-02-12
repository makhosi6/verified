


function handleContactEnquiry(req, res) {
    const { contact_number, reason } = req?.body;

    console.table(req?.body)
    res.status(200).send({
        "status": "Success",
        "contactEnquiry": {
            "results": [
                {
                    "idnumber": "09877087090987",
                    "forename1": "JUST",
                    "forename2": contact_number,
                    "surname": "GOOFY"
                },
                {
                    "idnumber": "7865765786576",
                    "forename1": "SAKIO",
                    "forename2": "NIXON",
                    "surname": "MALATJI"
                },
                {
                    "idnumber": "74567456745645",
                    "forename1": "JUST",
                    "forename2": "FRED",
                    "surname": "LONGONE"
                },
                {
                    "idnumber": "345234523452345",
                    "forename1": "GUMMY",
                    "forename2": "",
                    "surname": "BEAR"
                }
            ]
        }
    });
}


function handleSaidVerification(req, res) {
    const { idnumber, reason } = req?.body;
    console.table(req?.body)
    res.status(200).send({

        "status": "ID Number Valid",
        "verification": {
            "firstnames": "JUST",
            "lastname": "GOOFY",
            "dob": "1979-05-01",
            "age": 39,
            "idNumber": idnumber,
            "gender": "Male",
            "citizenship": "South African",
            "dateIssued": "1997-07-25T00:00:00+02:00"
        }

    });
}

function getCreditsReq(req, res) {
    res.send({"Status":"Success","Result":{"sadl_credits":0}})
}

module.exports = {
    handleContactEnquiry,
    handleSaidVerification,
    getCreditsReq
}