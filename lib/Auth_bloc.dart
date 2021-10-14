import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pahir/data/globals.dart';
import 'package:pahir/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/repository/LoginRepo.dart';
import 'data/sp/shared_keys.dart';


part 'Auth_event.dart';

part 'Auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());
  var dio = Dio();

  Future<Response> fetchAlbum() {
    return dio.post('${AppStrings.BASE_URL}api/v1/user/+91/8667236028/otp/958106');
  }
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthRequested) {
      yield AuthLoadInProgress();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accesstoken=await prefs.getString("accessToken");
        String? userFingerprintHash=await prefs.getString("userFingerprintHash");
        if (prefs.getBool(IS_LOGGED_IN) ?? false) {
          requestHeaders = {
            'Content-type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'appcode': '100000',
            'licensekey': '90839e11-bdce-4bc1-90af-464986217b9a',
            'Authorization': "Bearer " +accesstoken!,
            'userFingerprintHash': userFingerprintHash!

          };
          print(requestHeaders);
          globalCountryCode=await prefs.getString(USER_COUNTRY_CODE)??"";
          globalPhoneNo=await prefs.getString(USER_MOBILE_NUMBER)??"";
          yield AuthLoadSuccess(AuthCheck: true);
        } else {
          yield AuthLoadSuccess(AuthCheck: false);

        }



      } catch (_) {
        yield AuthLoadFailure();
      }
    }
  }
}
