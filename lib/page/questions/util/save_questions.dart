import 'dart:convert';

import 'package:thewell_gpt_admin/page/questions/question_router.dart';

import '../../../util/server_config.dart';
import 'package:http/http.dart' as http;

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


Future<List<int?>> getQuestionSaveResult(List<QuestionPageState> questionStateList, bool replace) async {

  final List<int?> resultList = [];

  for (var state in questionStateList) {
    try {

      if (state.questionModel.defaultQuestionInfo.selectedFileBytes != null) {
        resultList.add(await sendQuestionWithFile(state, replace));
      } else {
        resultList.add(await sendQuestionWithoutFile(state, replace));
      }

    } catch (e) {
      print("Router Exception for question ID: ${state.questionId}");
      print("Error: $e");
    }
  }

  return resultList;
}

Future<int?> sendQuestionWithFile(QuestionPageState questionPageState, bool replace) async {
  final url = "$serverUrl/question-bank/add-all/file";
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


Future<int?> sendQuestionWithoutFile(QuestionPageState questionPageState, bool replace) async {
  final url = "$serverUrl/question-bank/add-all";
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

