import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_constant.dart';

// class represents only laravel-flutter 'string' encryption

// these two should be in laravel too
const String _secretKey = 'b7xkP2veN3wQ9tR6mZ5uYf8HjLd1XpQ1'; // 32 chars
const String _secretIv = 'mv41nZqL8rT6x9eF'; // 16 chars

const String _url = '/third-party-integrations/chats/telegram';
const String _telegramToken = '';

class EncryptionController {
  EncryptionController({required this.logger});

  final Logger logger;

  //
  Future<void> sendApi() async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ImageProductConstant.baseURL,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${ImageProductConstant.token}',
            // if needed
          },
        ),
      );
      logger.log(Level.debug, 'sending url: ${dio.options.baseUrl}$_url');

      const botName = 'TestAgainSbDor';

      final encryptedToken = _encryptString(_telegramToken);

      final response = await dio.post(_url, data: {'token': encryptedToken, 'bot_name': botName});

      logger.log(Level.debug, response.data);
    } on DioException catch (error, stackTrace) {
      logger.log(Level.error, 'error is: ${error.response}');
      Error.throwWithStackTrace(error, stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  String _encryptString(String data) {
    final key = encrypt.Key.fromUtf8(_secretKey);
    final iv = encrypt.IV.fromUtf8(_secretIv);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return encrypted.base64;
  }
}
