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


part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial());
  var dio = Dio();

  Future<Response> fetchAlbum() {
    return dio.post('${AppStrings.BASE_URL}api/v1/user/+91/8667236028/otp/958106');
  }
  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is WeatherRequested) {
      yield WeatherLoadInProgress();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accesstoken=await prefs.getString("accessToken");
        String? userFingerprintHash=await prefs.getString("userFingerprintHash");
        if (prefs.getBool(IS_LOGGED_IN) ?? false) {
          requestHeaders = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'appcode': '100000',
            'licensekey': '90839e11-bdce-4bc1-90af-464986217b9a',
            'Authorization': "Bearer " +accesstoken!,
            'userFingerprintHash': userFingerprintHash!

          };
          print(requestHeaders);
          globalCountryCode=await prefs.getString(USER_COUNTRY_CODE)??"";
          globalPhoneNo=await prefs.getString(USER_MOBILE_NUMBER)??"";
          yield WeatherLoadSuccess(weather: true);
        } else {
          yield WeatherLoadSuccess(weather: false);

        }



      } catch (_) {
        yield WeatherLoadFailure();
      }
    }
  }
}
