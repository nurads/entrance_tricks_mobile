import 'package:json_annotation/json_annotation.dart';
import 'package:entrance_tricks/models/models.dart';

part 'payment.g.dart';

enum PaymentStatus { pending, approved, rejected }

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.approved:
        return 'Approved';
      case PaymentStatus.rejected:
        return 'Rejected';
    }
  }
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

  // Get payment status based on isCompleted and adminNotes
  PaymentStatus get status {
    if (isCompleted && approvedAt != null) {
      return PaymentStatus.approved;
    } else if (adminNotes != null && adminNotes!.isNotEmpty) {
      return PaymentStatus.rejected;
    } else {
      return PaymentStatus.pending;
    }
  }

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
