enum ImageSize {
  original._('original'),
  lg._('lg'),
  md._('md'),
  sm._('sm');

  const ImageSize._(this.value);

  final String value;
}
