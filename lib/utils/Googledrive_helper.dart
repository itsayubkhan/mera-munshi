import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['https://www.googleapis.com/auth/drive.file'],
);

Future<File> getDatabaseFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/Munshi.db';  // Replace with your database name
  return File(path);
}
Future<String?> authenticateUser() async {
  try {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) return null;

    GoogleSignInAuthentication auth = await account.authentication;
    return auth.accessToken;  // Return the access token
  } catch (e) {
    print("Error authenticating user: $e");
    return null;
  }
}

String generateUniqueFilename() {
  final rand = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'Munshi_${timestamp}_${rand.nextInt(10000)}.db';  // Unique filename with timestamp and random number
}

Future<void> uploadToGoogleDrive(String accessToken) async {
  try {
    final dbFile = await getDatabaseFile();

    // Ensure the file exists
    if (!dbFile.existsSync()) {
      print("File not found at: ${dbFile.path}");
      return;
    }

    var url = Uri.parse("https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart");
    var request = http.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer $accessToken";

    // Using application/octet-stream MIME type for general binary file upload
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      dbFile.path,
      contentType: MediaType('application', 'octet-stream'), // Using octet-stream MIME type
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print("File uploaded successfully!");
    } else {
      final responseString = await response.stream.bytesToString();
      print("Failed to upload file. Status: ${response.statusCode}. Response: $responseString");
    }
  } catch (e) {
    print("Error uploading to Google Drive: $e");
  }
}



void backupDatabase() async {
  String? accessToken = await authenticateUser();
  if (accessToken != null) {
    await uploadToGoogleDrive(accessToken);
  } else {
    print("User authentication failed.");
  }
}

