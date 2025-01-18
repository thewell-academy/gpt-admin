String get gptServerUrl {
  const String defaultUrl = 'https://www.thewell-academy.com';

  const String envUrl = 'https://www.thewell-academy.com';

  if (envUrl.isEmpty) {
    return defaultUrl;
  } else {
    return envUrl;
  }
}
