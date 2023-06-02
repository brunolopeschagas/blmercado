import 'package:blmercado/common/formatter/bl_formatter.dart';

class CurrencyBRReal implements BLFormatter {
  @override
  String format(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }
}
