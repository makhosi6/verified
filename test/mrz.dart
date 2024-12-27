// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mrz_parser/mrz_parser.dart';

void main() {
  var data =
      MRZParser.parse(['PAETHGELETAW<<GENET<MOGES<<<<<<<<<<<<<<<<<<<', "AP00047617ETH6001010F0908025<<<<<<<<<<<<<<06"]);
  var _data =
      MRZParser.parse(['OAETHGELETAU<<GENET<MOGES<<S<<<<<<<<<SSSSER', 'AP00047617ETH6001010F0908025<<<<<<<<<<<<<<06']);

  print(_data);
  print(_data.birthDate);
}

mixin Number {
  var operators = ['+', '-', '*', '%'];
}

class One with Number {
  var names = ['um', 'one', '1'];

}
