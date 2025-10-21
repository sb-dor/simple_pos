class CategoryCreationWidgetData {}

class CategoryCreationWidgetController {
  CategoryCreationWidgetController({CategoryCreationWidgetData? categoryCreationWidgetData})
    : categoryCreationWidgetData = categoryCreationWidgetData ?? CategoryCreationWidgetData();

  final CategoryCreationWidgetData categoryCreationWidgetData;
}
