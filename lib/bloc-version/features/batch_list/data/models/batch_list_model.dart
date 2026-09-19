import 'package:batch_management_app_direct/bloc-version/features/create_batch/data/models/create_batch_model.dart';
import 'package:equatable/equatable.dart';

class BatchListResponseModel extends Equatable {
  final List<BatchListItemModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const BatchListResponseModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory BatchListResponseModel.fromJson(Map<String, dynamic> json) {
    return BatchListResponseModel(
      items: (json['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BatchListItemModel.fromJson)
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'limit': limit,
      'total': total,
      'total_pages': totalPages,
    };
  }

  @override
  List<Object?> get props => [items, page, limit, total, totalPages];
}
