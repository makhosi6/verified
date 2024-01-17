import 'package:rsa_id_number/rsa_id_number.dart';

void main() {
  var ids = [
    '4805232722080',
    '5912245978086',
    '0206022675089',
    '4612163955089',
    '0311282830083',
    '7110148290083',
    '5101019193086',
    '9209297533083',
    '0001247132085',
  ];

  for (var i = 0; i < ids.length; i++) {
    var id = ids[i];
    var id0 = id.substring(0, id.length - 1);
    print('$id || $id0 || ${RsaIdUtils.luhnAppend(id0) == id} , ${RsaIdValidator.isValid(id)}');
  }
}
