


import 'package:mrz_parser/mrz_parser.dart';

void main() {
var data =  MRZParser.parse([
        'PAETHGELETAW<<GENET<MOGES<<<<<<<<<<<<<<<<<<<',
        "AP00047617ETH6001010F0908025<<<<<<<<<<<<<<06"
    ]);

    print(data);
    print(data.birthDate);
}