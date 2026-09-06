// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// ignore_for_file: avoid_print
import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get(
      'https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1/translations/en_US',
    );
    print('RESPONSE DATA:');
    print(response.data);
  } catch (e) {
    if (e is DioException) {
      print('DIO ERROR: ${e.response?.statusCode}');
      print(e.response?.data);
    } else {
      print('ERROR: $e');
    }
  }
}
