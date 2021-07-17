import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pahir/data/api/api_intercepter.dart';
import 'package:pahir/weather_bloc.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'utils/values/app_strings.dart';

class NewWeather extends StatelessWidget {

  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WeatherBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Weather'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final response = await client.get(
                    Uri.parse('${AppStrings.BASE_URL}api/v1/message/91/8667236028'),
                    headers: {HttpHeaders.contentTypeHeader: 'application/json'});
                // print("GetReviewResponse request :==>"+response.request.url.toString());
                print(response.statusCode);
                print(response.body.toString());

                BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: "cityname"));
              },
            )
          ],
        ),
        body: Column(
          children: [
            Center(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                bloc: BlocProvider.of<WeatherBloc>(context),
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: "cityname"));
                    return Center(child: Text('Please Select a Location'));
                  }
                  if (state is WeatherLoadInProgress) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is WeatherLoadSuccess) {
                    final weather = state.weather;

                    return Text(
                      weather.toString(),
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  if (state is WeatherLoadFailure) {
                    return Text(
                      'Something went wrong!',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return Text(
                      'Something went wrong!',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
