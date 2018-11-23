import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Network {
  final String _url = 'http://10.0.2.2:5000/post-image';  // EMULATOR
  // final String _url = 'http://craigs-mbp.home:5000/post-image';  // Physical. Change to actual IP. Not working yet

  static Network _instance = new Network.internal();

  Network.internal();

  factory Network() => _instance;

  Future<http.StreamedResponse> post(File file) async {
    http.ByteStream stream =
        http.ByteStream(DelegatingStream.typed(file.openRead()));
    int length = await file.length();

    Uri uri = Uri.parse('$_url');

    http.MultipartRequest request = new http.MultipartRequest('POST', uri);

    http.MultipartFile multipartFile = new http.MultipartFile(
        'file', stream, length,
        filename: basename(file.path));

    request.files.add(multipartFile);

    http.StreamedResponse response;

    try {
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      return response;
    } catch (e) {
      print(e);
    }
    return response;
  }
}
