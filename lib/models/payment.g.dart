// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num).toInt(),
  amount: (json['amount'] as num).toInt(),
  paymentDate: json['payment_date'] as String,
  isCompleted: json['is_completed'] as bool,
  receipt: json['receipt'],
  adminNotes: json['admin_notes'] as String?,
  approvedAt: json['approved_at'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  package: json['package'] == null
      ? null
      : Package.fromJson(json['package'] as Map<String, dynamic>),
  paymentMethod: json['payment_method'] == null
      ? null
      : PaymentMethod.fromJson(json['payment_method'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'payment_date': instance.paymentDate,
  'is_completed': instance.isCompleted,
  'receipt': instance.receipt,
  'admin_notes': instance.adminNotes,
  'approved_at': instance.approvedAt,
  'user': instance.user,
  'package': instance.package,
  'payment_method': instance.paymentMethod,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

PaymentCreateRequest _$PaymentCreateRequestFromJson(
  Map<String, dynamic> json,
) => PaymentCreateRequest(
  package: (json['package'] as num).toInt(),
  paymentMethod: (json['payment_method'] as num).toInt(),
  amount: (json['amount'] as num).toInt(),
  receipt: (json['receipt'] as num).toInt(),
);

Map<String, dynamic> _$PaymentCreateRequestToJson(
  PaymentCreateRequest instance,
) => <String, dynamic>{
  'package': instance.package,
  'payment_method': instance.paymentMethod,
  'amount': instance.amount,
  'receipt': instance.receipt,
};
