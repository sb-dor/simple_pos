enum ProductType {
  regular._(type: "regular", unit: "pcs"),
  milligram._(type: "weight", unit: "mg"),
  gram._(type: "weight", unit: "g"),
  kilogram._(type: "weight", unit: "kg"),
  centimeter._(type: "length", unit: "cm"),
  meter._(type: "length", unit: "m"),
  squareCentimeter._(type: "area", unit: "cm2"),
  squareMeter._(type: "area", unit: "m2"),
  milliliter._(type: "volume", unit: "ml"),
  liter._(type: "volume", unit: "l"),
  hour._(type: "time", unit: "hour"),
  minute._(type: "time", unit: "min");

  const ProductType._({required this.type, required this.unit});

  final String type;
  final String unit;

  static ProductType fromType(final String? type) {
    switch (type?.toLowerCase()) {
      case "regular":
        return ProductType.regular;

      case "weight":
        return ProductType.gram;

      case "length":
        return ProductType.meter;

      case "area":
        return ProductType.squareMeter;

      case "volume":
        return ProductType.liter;

      case "time":
        return ProductType.hour;

      default:
        return ProductType.regular;
    }
  }
}
