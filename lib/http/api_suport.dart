import 'dart:io';
import 'package:http/http.dart' as http;

uploadFile() async {
  var postUri = Uri.parse("<APIUrl>");
  var request = new http.MultipartRequest("POST", postUri);
  request.fields['idCliente'] = 'blah';

  ///request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("file").readAsBytes(), contentType: new MediaType('image', 'jpeg')))

  request.send().then((response) {
    if (response.statusCode == 200) print("Uploaded!");
  });
}

upload() async {
  final postUri = Uri.parse('http://192.168.0.22:8181/api/save');
  http.MultipartRequest request = http.MultipartRequest('POST', postUri);

  http.MultipartFile multipartFile = 
    await http.MultipartFile.fromPath(
      'e1cbcb58-1e4f-4d82-9972-9b60fc9a09334807502451510949629.jpg', 
      '/storage/emulated/0/Android/data/com.example.stylelab/files/Pictures/'
  ); //returns a Future<MultipartFile>

  request.fields['idCliente'] = '33';
  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) print("Uploaded!");
}
