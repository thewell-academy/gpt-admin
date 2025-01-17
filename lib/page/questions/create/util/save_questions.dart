import 'dart:convert';
import 'dart:io' as io;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../../util/server_config.dart';
import '../question_model/question_router_state.dart';

String serverUrl = gptServerUrl;

Map<String, dynamic> parsedResponse(String responseBody) {
  // Parse the JSON string into a Map<String, dynamic>
  final Map<String, dynamic> parsedJson = json.decode(responseBody);

  // Convert Map<String, dynamic> into Map<String, String>
  final Map<String, dynamic> stringMap = parsedJson.map((key, value) {
    return MapEntry(key, value);
  });

  return stringMap;// Print the map
}


Future<int?> getQuestionSaveResult(QuestionRouterState questionRouterState, bool replace) async {

  try {

    if (questionRouterState.questionModel.defaultQuestionInfo.selectedFileBytes != null) {
      return await sendQuestionWithFile(questionRouterState, replace);
    } else {
      return await sendQuestionWithoutFile(questionRouterState, replace);
    }

  } catch (e) {
    print("Router Exception for question ID: ${questionRouterState.questionId}");
    print("Error: $e");
  }
  return null;
}

Future<int?> sendQuestionWithFile(QuestionRouterState questionPageState, bool replace) async {
  final url = "$serverUrl/question-bank/add/file";
  final uri = Uri.parse(url).replace(queryParameters: {
    "replace": replace.toString(),
  });

  var request = http.MultipartRequest('POST', uri);

  try {
    request.files.add(
      http.MultipartFile.fromBytes(
        "file", // Ensure this matches the key on the backend
        questionPageState.questionModel.defaultQuestionInfo.selectedFileBytes!,
        filename: questionPageState.questionModel.defaultQuestionInfo.filePath
      ),
    );

    request.fields['body'] = jsonEncode(questionPageState.toJson());

    var response = await request.send();
    return response.statusCode;

  } catch (e) {
    print("Exception for requesting with file question ID: ${questionPageState.questionId}");
    print("Error: $e");
  }

  return null;

}


Future<int?> sendQuestionWithoutFile(QuestionRouterState questionPageState, bool replace) async {
  final url = "$serverUrl/question-bank/add";
  final uri = Uri.parse(url).replace(queryParameters: {
    "replace": replace.toString(),
  });
  var request = http.Request('POST', uri);

  try {
    request.body = jsonEncode(questionPageState.toJson());
    var response =  await request.send();
    return response.statusCode;
  } catch (e) {
    print("Exception for requesting without file question ID: ${questionPageState.questionId}");
    print("Error: $e");
  }
  return null;

}

Future<io.File?> getExportedQuestionBankFile(
    String subject,
    String exam,
    List<String> selections,
    List<int> years,
    List<int> months,
    List<String> grades
    ) async {

  final url = "$serverUrl/question-bank/export";
  final uri = Uri.parse(url).replace(queryParameters: {
    "subject": subject,
    "exam": exam,
    "selections": selections.join(","),
    "years": years.map((e) => e.toString()).join(","),
    "months": months.map((e) => e.toString()).join(","),
    "grades": grades.join(",")
  });
  // var request = http.Request('GET', uri);

  try {
    final client = http.Client();
    final response = await client.get(uri);

    final fileName = "output.docx";
    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = fileName;
      anchor.click();
      html.Url.revokeObjectUrl(url);
      print("File downloaded successfully: $fileName");
    } else {
      print("Failed to download file. Status code: ${response.statusCode}");
    }

  } catch (e) {
    print("Error: $e");
  }
  return null;
}

