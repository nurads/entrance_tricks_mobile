import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'payment_methods.g.dart';

@JsonSerializable()
class PaymentMethods {
  final int id;
  @JsonKey(name: 'bank_name')
  final String bankName;
  final String accountName;
  final String accountNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethods({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodsFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodsToJson(this);
}

class PaymentMethodsTypeAdapter implements TypeAdapter<PaymentMethods> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    final json_ = Map<String, dynamic>.from(json);
    return PaymentMethods.fromJson(json_);
  }

  @override
  int get typeId => 5;

  @override
  void write(BinaryWriter writer, PaymentMethods obj) {
    writer.write(obj.toJson());
  }
}
