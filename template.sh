#!/usr/bin/env bash
# Feature Boilerplate Generator using fpdart, Data Models & Active Repository Templates
# Usage: ./template.sh change_password

set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
    read -p "Enter feature name (e.g. change_password): " FEATURE_NAME
fi

snake_name=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

# Convert snake_case to PascalCase (e.g. change_password -> ChangePassword)
pascal_name=""
IFS='_' read -ra PARTS <<< "$snake_name"
for part in "${PARTS[@]}"; do
    if [ -n "$part" ]; then
        first_char=$(echo "${part:0:1}" | tr '[:lower:]' '[:upper:]')
        rest_chars="${part:1}"
        pascal_name="${pascal_name}${first_char}${rest_chars}"
    fi
done

# Convert snake_case to camelCase (e.g. change_password -> changePassword)
first_part="${PARTS[0]}"
camel_name="$first_part"
for ((i=1; i<${#PARTS[@]}; i++)); do
    part="${PARTS[i]}"
    if [ -n "$part" ]; then
        first_char=$(echo "${part:0:1}" | tr '[:lower:]' '[:upper:]')
        rest_chars="${part:1}"
        camel_name="${camel_name}${first_char}${rest_chars}"
    fi
done

ROOT_DIR="$(pwd)"
while [ ! -f "$ROOT_DIR/pubspec.yaml" ] && [ "$ROOT_DIR" != "/" ]; do
    ROOT_DIR="$(dirname "$ROOT_DIR")"
done

if [ ! -f "$ROOT_DIR/pubspec.yaml" ]; then
    echo -e "\033[31mError: Could not locate pubspec.yaml project root!\033[0m"
    exit 1
fi

BASE_DIR="$ROOT_DIR/lib/bloc-version/features/$snake_name"

mkdir -p "$BASE_DIR/data/datasources"
mkdir -p "$BASE_DIR/data/models"
mkdir -p "$BASE_DIR/data/repositories"
mkdir -p "$BASE_DIR/presentation/bloc"

# 0. Data Model
cat <<EOF > "$BASE_DIR/data/models/${snake_name}_model.dart"
/// Data Model for ${pascal_name} Feature
class ${pascal_name}Model {
  final String? id;
  final String? title;

  ${pascal_name}Model({
    this.id,
    this.title,
  });

  factory ${pascal_name}Model.fromJson(Map<String, dynamic> json) {
    return ${pascal_name}Model(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? json['name'],
    );
  }

  /// Parse a whole JSON list into `List<${pascal_name}Model>` safely
  static List<${pascal_name}Model> fromJsonList(dynamic jsonList) {
    if (jsonList is! List) return [];
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map(${pascal_name}Model.fromJson)
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
EOF

# 1. Local Data Source
cat <<EOF > "$BASE_DIR/data/datasources/${snake_name}_local_data_source.dart"
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure-storage-interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class ${pascal_name}LocalDataSource {
  final ISecureStorageService _secureStorage;

  ${pascal_name}LocalDataSource(this._secureStorage);

  Future<void> saveToken(String token) async {
    await _secureStorage.write(SecureKey.token, token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(SecureKey.token);
  }

  Future<void> clearUserData() async {
    await _secureStorage.clearAll();
  }
}
EOF

# 2. Remote Data Source
cat <<EOF > "$BASE_DIR/data/datasources/${snake_name}_remote_data_source.dart"
import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class ${pascal_name}RemoteDataSource {
  final INetworkService _networkService;

  ${pascal_name}RemoteDataSource(this._networkService);

  /// Execute ${pascal_name} API POST Request
  Future<ApiResult<dynamic>> ${camel_name}({
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      ApiEndpoints.${camel_name},
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
EOF

# 3. Repository
cat <<EOF > "$BASE_DIR/data/repositories/${snake_name}_repository.dart"
import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/${snake_name}_local_data_source.dart';
import '../datasources/${snake_name}_remote_data_source.dart';

class ${pascal_name}Repository {
  final ${pascal_name}LocalDataSource _localDataSource;
  final ${pascal_name}RemoteDataSource _remoteDataSource;

  ${pascal_name}Repository({
    required ${pascal_name}LocalDataSource localDataSource,
    required ${pascal_name}RemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Executes ${pascal_name} Action & returns Either
  Future<Either<Failure, void>> ${camel_name}({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.${camel_name}(
      email: email,
      password: password,
    );

    if (result.isSuccess && result.data != null) {
      final responseData = result.data;
      if (responseData is Map<String, dynamic> && responseData['success'] == true) {
        final token = responseData['data']?['token'];
        if (token != null && token.toString().isNotEmpty) {
          await _localDataSource.clearUserData();
          await _localDataSource.saveToken(token.toString());
        }
        return const Right(null);
      }
      return Left(ServerFailure(responseData['message'] ?? '${pascal_name} Action failed'));
    }

    return Left(ServerFailure(result.errorMessage ?? 'Network error occurred'));
  }
}
EOF

# 4. State Class
cat <<EOF > "$BASE_DIR/presentation/bloc/${snake_name}_state.dart"
import 'package:equatable/equatable.dart';

abstract class ${pascal_name}State extends Equatable {
  const ${pascal_name}State();

  @override
  List<Object?> get props => [];
}

class ${pascal_name}Initial extends ${pascal_name}State {}

class ${pascal_name}Loading extends ${pascal_name}State {}

class ${pascal_name}Success extends ${pascal_name}State {}

class ${pascal_name}Failure extends ${pascal_name}State {
  final String errorMessage;

  const ${pascal_name}Failure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
EOF

# 5. Cubit Class
cat <<EOF > "$BASE_DIR/presentation/bloc/${snake_name}_cubit.dart"
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/${snake_name}_repository.dart';
import '${snake_name}_state.dart';

class ${pascal_name}Cubit extends Cubit<${pascal_name}State> {
  final ${pascal_name}Repository _${camel_name}Repository;

  ${pascal_name}Cubit(this._${camel_name}Repository) : super(${pascal_name}Initial());
}
EOF

# 6. View Widget
cat <<EOF > "$BASE_DIR/presentation/${snake_name}_view.dart"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';

import 'bloc/${snake_name}_cubit.dart';
import 'bloc/${snake_name}_state.dart';

class ${pascal_name}View extends StatefulWidget {
  const ${pascal_name}View({super.key});

  @override
  State<${pascal_name}View> createState() => _${pascal_name}ViewState();
}

class _${pascal_name}ViewState extends State<${pascal_name}View> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${pascal_name}Cubit>(
      create: (context) => sl<${pascal_name}Cubit>(),
      child: BlocConsumer<${pascal_name}Cubit, ${pascal_name}State>(
        listener: (context, state) {
          if (state is ${pascal_name}Failure) {
            AppSnackbar.show(
              context: context,
              message: state.errorMessage,
              isSuccess: false,
            );
          } else if (state is ${pascal_name}Success) {
            AppSnackbar.show(
              context: context,
              message: '${pascal_name} Success!',
              isSuccess: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ${pascal_name}Loading;

          return Scaffold(
            appBar: AppBar(title: const Text('${pascal_name}')),
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Input Field',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: const Text('Submit'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
EOF

# 7. DI Module File
cat <<EOF > "$BASE_DIR/${snake_name}_di.dart"
import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure-storage-interface.dart';

import 'data/datasources/${snake_name}_local_data_source.dart';
import 'data/datasources/${snake_name}_remote_data_source.dart';
import 'data/repositories/${snake_name}_repository.dart';
import 'presentation/bloc/${snake_name}_cubit.dart';

/// Dependency Injection module for ${pascal_name} feature
void init${pascal_name}Dependencies() {
  sl.registerLazySingleton<${pascal_name}LocalDataSource>(
    () => ${pascal_name}LocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<${pascal_name}RemoteDataSource>(
    () => ${pascal_name}RemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<${pascal_name}Repository>(
    () => ${pascal_name}Repository(
      localDataSource: sl<${pascal_name}LocalDataSource>(),
      remoteDataSource: sl<${pascal_name}RemoteDataSource>(),
    ),
  );

  sl.registerFactory<${pascal_name}Cubit>(
    () => ${pascal_name}Cubit(sl<${pascal_name}Repository>()),
  );
}
EOF

echo -e "\033[32mSuccess: Generated feature code inside $BASE_DIR\033[0m"
