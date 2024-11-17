import 'package:mrz_parser/mrz_parser.dart';

void main() {
  var data =
      MRZParser.parse(['PAETHGELETAW<<GENET<MOGES<<<<<<<<<<<<<<<<<<<', "AP00047617ETH6001010F0908025<<<<<<<<<<<<<<06"]);
  var _data = MRZParser.parse(
      ['OAETHGELETAU<<GENET<MOGES<<S<<<<<<<<<SSSSER', 'AP00047617ETH6001010F0908025<<<<<<<<<<<<<<06']);

  print(_data);
  print(_data.birthDate);
}
