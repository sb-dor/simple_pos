enum Environment {
  prod._('PROD'),
  dev._('DEV');

  const Environment._(this.value);

  final String value;
}
