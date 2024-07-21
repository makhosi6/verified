// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

void main() async {
  try {
    var headers = {
      'x-nonce': 'MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer TOKEN'
    };
    var data = json.encode({
      'id': '5f6ab732-cfcf-417b-b345-9404037312eb_test',
      'profileId': 'awkDp8nu9kQ8yWBdanbYVYTnFKk6',
      'balance': 45000,
      'createdAt': 1721508604,
      'updatedAt': 1721511003,
      'deletedAt': null,
      'isoCurrencyCode': 'ZAR',
      'promotions': [],
      'accountHolderName': 'Algae Olive',
      'accountName': '************4578',
      'expDate': '09/28',
      'cardProvider': 'mastercard'
    });
    var dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient dioClient) => dioClient
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) {
      
        return true;
      });
    var response = await dio.request(
      'https://verified.byteestudio.com/store/api/v1/wallet/resource/5f6ab732-cfcf-417b-b345-9404037312eb_test',
      options: Options(
        method: 'PUT',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 404) {
      print('${response.statusCode} = response.statusCode \n\n\n');
    }
  } catch (e) {
    print('Did throw and error');
    print(e);
  }
}
