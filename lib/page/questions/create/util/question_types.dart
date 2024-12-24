import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 과목 유형 목록
final Map<String, List<String>> questionTypes = {
  "영어": [
    "글의 목적", "글의 분위기", "대의 파악", "함의 추론", "도표 이해", "내용 일치", "어법 판단", "단어 쓰임 판단", "빈칸 추론", "무관한 문장",
    "글의 순서",
    "주어진 문장 넣기",
    "요약문 완성",
    "장문 문제1 (41~42)",
    "장문 문제2 (43~45)",
  ],
};


// 시험 목록
Map<String, List<String>> get examList {
  final currentYear = DateTime.now().year;
  return {
    "수능": List<String>.generate(11, (index) => (currentYear+1 - index).toString()),
    "모의고사": List<String>.generate(10, (index) => (currentYear - index).toString())
  };
}


