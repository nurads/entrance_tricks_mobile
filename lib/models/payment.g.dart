// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toInt(),
  isActive: json['is_active'] as bool,
  subjects: (json['subjects'] as List<dynamic>?)
      ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'is_active': instance.isActive,
  'subjects': instance.subjects,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      accountName: json['account_name'] as String,
      accountNumber: json['account_number'] as String,
      isActive: json['is_active'] as bool,
      image: json['image'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account_name': instance.accountName,
      'account_number': instance.accountNumber,
      'is_active': instance.isActive,
      'image': instance.image,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

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
