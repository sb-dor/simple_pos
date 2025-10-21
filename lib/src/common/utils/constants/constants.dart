import 'package:flutter/material.dart';

abstract class Constants {
  static final mainAppColor = Colors.amberAccent.shade100;
  static const chooseTextAppBar = "Выбор";
  static const mainHall = "Основной зал";
  static const letka = "Летка";
  static const vip1 = "VIP 1";
  static const vip2 = "VIP 2";
  static const products = "Товары";
  static const settings = "Параметры";
  static const salesMode = "Режим продаж";
  static const tables = "Столы";
  static const firstFoods = "1 блюда";
  static const secondFoods = "2 блюда";
  static const pay = "Оплатить";
  static const cashier = "Кассир";
  static const reloadLabel = "Повторить";
  static const logout = "Выйти";
  static const tableCreation = "Создание столиков";

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
