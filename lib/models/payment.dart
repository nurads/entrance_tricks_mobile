import 'package:json_annotation/json_annotation.dart';
import 'package:entrance_tricks/models/models.dart';

part 'payment.g.dart';

@JsonSerializable()
class Package {
  final int id;
  final String name;
  final String? description;
  final int price;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<Subject>? subjects;
  final String createdAt;
  final String updatedAt;

  Package({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.isActive,
    this.subjects,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
  Map<String, dynamic> toJson() => _$PackageToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final int id;
  final String name;
  @JsonKey(name: 'account_name')
  final String accountName;
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final String? image;
  final String createdAt;
  final String updatedAt;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.accountName,
    required this.accountNumber,
    required this.isActive,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
class Payment {
  final int id;
  final int amount;
  @JsonKey(name: 'payment_date')
  final String paymentDate;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  final dynamic
  receipt; // Changed to dynamic to handle both string URL and media object
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  final User? user;
  final Package? package;
  @JsonKey(name: 'payment_method')
  final PaymentMethod? paymentMethod;
  final String createdAt;
  final String updatedAt;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.isCompleted,
    this.receipt,
    this.adminNotes,
    this.approvedAt,
    this.user,
    this.package,
    this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class PaymentCreateRequest {
  final int package;
  @JsonKey(name: 'payment_method')
  final int paymentMethod;
  final int amount;
  final int receipt; // Changed from String to int (file ID)

  PaymentCreateRequest({
    required this.package,
    required this.paymentMethod,
    required this.amount,
    required this.receipt,
  });

  factory PaymentCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentCreateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentCreateRequestToJson(this);
}
