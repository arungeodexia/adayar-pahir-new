import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
// Create storage
  final storage = new FlutterSecureStorage();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers["appcode"] = "100000";
    data.headers["licensekey"] = "90839e11-bdce-4bc1-90af-464986217b9a";
    try {
      var at = await storage.read(key: "accessToken");
      var uph = await storage.read(key: "userFingerprintHash");
      if (at != null) {
        data.headers["Authorization"] = "Bearer " + at;
        data.headers["userFingerprintHash"] = uph!;
        data.headers["Content-Type"] = "application/json";
      }
    } on Exception catch (e) {
      // TODO
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
