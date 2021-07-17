// @dart=2.9
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pahir/Bloc/Myhomepage/myhomepage_bloc.dart';
import 'package:pahir/Bloc/Myhomepage/myhomepage_bloc.dart';
import 'package:pahir/Bloc/Profilepage/profile_bloc.dart';
import 'package:pahir/Bloc/Profilepage/profile_bloc.dart';
import 'package:pahir/Bloc/Resorceview/resource_view_bloc.dart';
import 'package:pahir/Bloc/addresource/add_resouce_bloc.dart';
import 'package:pahir/Bloc/login/login_bloc.dart';
import 'package:pahir/Bloc/login/login_bloc.dart';
import 'package:pahir/Bloc/login/signin_mobile_view.dart';
import 'package:pahir/Bloc/user/auth.dart';
import 'package:pahir/Bloc/user/auth.dart';
import 'package:pahir/Bloc/user/user_repository.dart';
import 'package:pahir/Screen/edit_profile_view.dart';
import 'package:pahir/Screen/login_init_view.dart';
import 'package:pahir/Screen/mydashboard.dart';
import 'package:pahir/Screen/splash_view.dart';
import 'package:pahir/SimpleBlocObserver.dart';
import 'package:pahir/weather_bloc.dart';

import 'homenew_bloc.dart';
import 'new_weather.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer=SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'i18n', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MultiBlocProvider(
          providers: _multiBlocProviders(), child: MaterialApp(
        title: 'Pahir',
        home: Weather(),
      )),
    );
  }

  List<BlocProvider<Bloc>> _multiBlocProviders() {
    UserRepository userRepository=UserRepository();
    return [
      BlocProvider<WeatherBloc>(create: (context) => WeatherBloc()),
      BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      BlocProvider<AuthenticationBloc>(create: (context) => AuthenticationBloc(userRepository: userRepository)),
      BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      BlocProvider<MyhomepageBloc>(create: (context) => MyhomepageBloc()),
      BlocProvider<AddResouceBloc>(create: (context) => AddResouceBloc()),
      BlocProvider<ResourceViewBloc>(create: (context) => ResourceViewBloc()),
    ];
  }
}


class Weather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: "cityname"));
              return SplashView();
            }
            if (state is WeatherLoadInProgress) {
              return SplashView();
              return Center(child: CircularProgressIndicator());
            }
            if (state is WeatherLoadSuccess) {
              final weather = state.weather;
              if (weather) {
                return Mydashboard();
              }  else{
                return LoginInitView();
              }
            }
            if (state is WeatherLoadFailure) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }else{
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );

            }

          },
        ),
      ),
    );
  }
}


