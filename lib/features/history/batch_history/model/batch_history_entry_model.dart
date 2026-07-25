class BatchHistoryEntryModel {
  final String id;
  final String action;
  final String entityType;
  final String title;
  final String description;
  final String actorName;
  final String actorRole;
  final String createdAt;
  final Map<String, dynamic> raw;

  const BatchHistoryEntryModel({
    required this.id,
    required this.action,
    required this.entityType,
    required this.title,
    required this.description,
    required this.actorName,
    required this.actorRole,
    required this.createdAt,
    required this.raw,
  });

  factory BatchHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    final title = _firstNonEmpty([
      json['title'],
      json['entity_name'],
      json['student_name'],
      json['batch_name'],
      json['fee_month'],
      json['message'],
      json['detail'],
      json['description'],
    ]);

    final description = _firstNonEmpty([
      json['description'],
      json['message'],
      json['detail'],
      json['notes'],
      json['change_summary'],
    ]);

    return BatchHistoryEntryModel(
      id: json['id']?.toString() ?? '',
      action: _firstNonEmpty([json['action'], json['event'], json['type']]),
      entityType: _firstNonEmpty([
        json['entity_type'],
        json['resource_type'],
        json['target_type'],
        json['model'],
      ]),
      title: title.isNotEmpty ? title : 'Audit Event',
      description: description,
      actorName: _firstNonEmpty([
        json['user_name'],
        json['performed_by'],
        json['actor_name'],
        json['created_by'],
        json['username'],
      ]),
      actorRole: _firstNonEmpty([
        json['user_role'],
        json['actor_role'],
        json['role'],
      ]),
      createdAt: _firstNonEmpty([
        json['created_at'],
        json['timestamp'],
        json['date'],
        json['createdAt'],
      ]),
      raw: json,
    );
  }

  Map<String, dynamic> get details {
    final details = <String, dynamic>{};

    void merge(dynamic value) {
      if (value is Map) {
        details.addAll(
          value.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    }

    merge(raw['changes']);
    merge(raw['metadata']);
    merge(raw['before']);
    merge(raw['after']);
    merge(raw['data']);
    merge(raw['payload']);

    const ignoredKeys = {
      'id',
      'action',
      'event',
      'type',
      'entity_type',
      'resource_type',
      'target_type',
      'model',
      'title',
      'entity_name',
      'student_name',
      'batch_name',
      'fee_month',
      'message',
      'detail',
      'description',
      'notes',
      'change_summary',
      'user_name',
      'performed_by',
      'actor_name',
      'created_by',
      'username',
      'user_role',
      'actor_role',
      'role',
      'created_at',
      'timestamp',
      'date',
      'createdAt',
      'changes',
      'metadata',
      'before',
      'after',
      'data',
      'payload',
    };

    raw.forEach((key, value) {
      if (!ignoredKeys.contains(key) && value is! Map && value is! List) {
        details.putIfAbsent(key.toString(), () => value);
      }
    });

    return details;
  }

  static String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }
    return '';
  }
}
