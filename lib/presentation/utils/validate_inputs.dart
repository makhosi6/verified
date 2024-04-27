import 'package:rsa_id_number/rsa_id_number.dart';

String? validateIdNumber(String? idNumber) {
  //
  if (idNumber == null || idNumber.isEmpty) {
    return 'Please enter a SA Id Number';
  }

  //
  if (!RsaIdValidator.isValid(idNumber.replaceAll(' ', ''))) {
    return 'Please enter a valid SA Id Number';
  }

  return null;
}

String? validateMobile(String? value) {
  // Pattern for validating a phone number
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);

  // Check if the field is empty
  if (value == null || value.isEmpty) {
    return 'Please enter a mobile number';
  }

  // Allow SA codes only
  if (value.startsWith('+') && !value.startsWith('+27')) {
    return 'Invalid country code(+27) - South African Numbers only';
  }

  // Example of disallowing sequential/repeated numbers
  if (RegExp(r'(.)\1{3}').hasMatch(value)) {
    return 'Invalid mobile number (sequential/repeated digits detected)';
  }

  // Check if the phone number matches the regular expression
  if (!regExp.hasMatch(value.replaceAll(' ', ''))) {
    return 'Please enter a valid mobile number';
  }

  // //Validate length
  // if (value.replaceAll(' ', '').length <= 9) {
  //   return 'A valid phone number has 10 digits';
  // }

  return null;
}
