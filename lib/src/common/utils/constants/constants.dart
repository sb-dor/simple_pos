import 'package:flutter/material.dart';

abstract class Constants {
  static final mainAppColor = Colors.amberAccent.shade100;
  static const String chooseTextAppBar = "Выбор";
  static const String mainHall = "Основной зал";
  static const String letka = "Летка";
  static const String vip1 = "VIP 1";
  static const String vip2 = "VIP 2";
  static const String products = "Товары";
  static const String categories = "Категории";
  static const String settings = "Параметры";
  static const String salesMode = "Режим продаж";
  static const String tables = "Столы";
  static const String firstFoods = "1 блюда";
  static const secondFoods = "2 блюда";
  static const String pay = "Оплатить";
  static const String cashier = "Кассир";
  static const String reloadLabel = "Повторить";
  static const String logout = "Выйти";
  static const String tableCreation = "Создание столиков";
  static const String categoryCreation = "Создание категоии";
  static const String productCreation = "Создание товара";
  static const String productsOfCategory = "Products of category";

  //
  static const String pending = "PENDING";
  static const String userUUIDKey = "user_uuid";

  //
  static const String messageUserDoesNotExist = "Пользователь не существует";
  static const String fieldCannotBeEmpty = "Поле не может быть пустым";

  static const Map<int, String> userRoles = {1: "owner", 2: "admin", 3: "manager", 4: "waiter"};

  static const List<Color> appGradientColor = [
    Color(0xFF6B6ED4),
    Color(0xFF6C6BCF),
    Color(0xFF7450A9),
  ];
}
