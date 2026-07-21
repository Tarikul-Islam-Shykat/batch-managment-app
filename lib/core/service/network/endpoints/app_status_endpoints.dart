class AppStatusUrls {
  static const String getAll =
      'https://erp-fastapi-batch.vercel.app/api/v1/app-status';

  static String getOne(String id) =>
      'https://erp-fastapi-batch.vercel.app/api/v1/app-status/$id';

  static const String create =
      'https://erp-fastapi-batch.vercel.app/api/v1/web/admin/app-status';

  static String update(String id) =>
      'https://erp-fastapi-batch.vercel.app/api/v1/web/admin/app-status/$id';
}
