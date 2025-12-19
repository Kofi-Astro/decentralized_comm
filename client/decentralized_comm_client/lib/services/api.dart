import 'package:http/http.dart' as http;

Future GetData({required Uri url}) async {
  http.Response response = await http.get(url);
  return response;
}
