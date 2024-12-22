String get gptServerUrl {
  const String defaultUrl = 'http://thewell-gpt-lb-101888234.ap-northeast-2.elb.amazonaws.com';

  const String envUrl = 'http://172.30.1.35:8000';

  if (envUrl.isEmpty) {
    return defaultUrl;
  } else {
    return envUrl;
  }
}
