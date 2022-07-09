import 'package:http/http.dart' as http;
import 'package:nicov1/configs/connection_api.dart';

class HttpPost {
  static post(body, headers) async {
    final url = Uri.parse(ConnectionApi.baseUrl('/user/login'));
    final connection = await http.post(
      url,
      body: body,
      headers: headers,
    );
    return connection;
  }
}
