// ignore: file_names
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> uploadImage(File imageFile) async {
    const String url = 'https://upload.imagekit.io/api/v1/files/upload';

  // Your private API key (do NOT expose this in frontend)
  String apiKey = "private_4GZCeQLgG6Jk03Oy+vt2JmcnkIc=:"; // Add ":" at the end
  String encodedKey = base64Encode(utf8.encode(apiKey));

  var request = http.MultipartRequest('POST', Uri.parse(url));

  // ✅ Fix: Proper Basic Authentication header
  request.headers['Authorization'] = 'Basic $encodedKey';

  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  request.fields['fileName'] = 'uploaded_image.jpg';
  request.fields['useUniqueFileName'] = 'true';

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

      var data = jsonDecode(responseBody);
      
      if (response.statusCode == 200) {
        print('Upload successful: ${data['url']}');
      } else {
        print('Upload failed: ${data['message']}');
      }
      return data["url"];
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }

  }