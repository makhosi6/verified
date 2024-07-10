import 'dart:convert';
import 'dart:io';

void main() {
var file = File('/Users/makhosi/Downloads/south_africa_preview_0.jpg');
print("IMAGE: \n" + base64Encode(file.readAsBytesSync().toList()));
  
}
