class VerifiedDocumentType {
    static id_card = 'id_card'; static id_book = 'id_book'; static passport = 'passport';
}
class ResponseCode {
    static success = 'success'; static failed = 'failed'; static bad_request = 'bad_request';
}

module.exports = {
    VerifiedDocumentType, ResponseCode
}