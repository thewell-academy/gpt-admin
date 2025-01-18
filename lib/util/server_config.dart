String get gptServerUrl {
  const String defaultUrl = 'https://www.thewell-academy.com';

  const String envUrl = 'http://172.30.1.65:8000';

  if (envUrl.isEmpty) {
    return defaultUrl;
  } else {
    return envUrl;
  }
}
