# Feature Boilerplate Generator using fpdart, Data Models & Active Repository Templates
# Usage: .\template.ps1 sign_up

param (
    [string]$FeatureName
)

if (-not $FeatureName) {
    $FeatureName = Read-Host "Enter feature name (e.g. sign_up)"
}

$snakeName = $FeatureName.ToLower().Replace('-', '_')

# Convert snake_case to PascalCase (e.g. sign_up -> SignUp)
$pascalName = ($snakeName.Split('_') | ForEach-Object { 
    if ($_ -ne "") { $_.Substring(0,1).ToUpper() + $_.Substring(1) } 
}) -join ''

# Lower camelCase for field names (e.g. sign_up -> signUp)
$parts = $snakeName.Split('_')
$camelName = $parts[0] + (($parts[1..($parts.Length-1)] | ForEach-Object { 
    if ($_ -ne "") { $_.Substring(0,1).ToUpper() + $_.Substring(1) } 
}) -join '')

# Locate project root (where pubspec.yaml lives)
$currentDir = Get-Location
$rootDir = $currentDir

while ($rootDir -ne $null -and -not (Test-Path (Join-Path $rootDir.Path "pubspec.yaml"))) {
    $rootDir = Get-Item (Join-Path $rootDir.Path "..") -ErrorAction SilentlyContinue
}

if ($rootDir -eq $null) {
    Write-Host "Error: Could not locate pubspec.yaml project root!" -ForegroundColor Red
    exit 1
}

# Target directory is ALWAYS lib/bloc-version/features/$snakeName
$baseDir = Join-Path $rootDir.Path "lib/bloc-version/features/$snakeName"

# Create directories
New-Item -ItemType Directory -Force -Path "$baseDir/data/datasources" | Out-Null
New-Item -ItemType Directory -Force -Path "$baseDir/data/models" | Out-Null
New-Item -ItemType Directory -Force -Path "$baseDir/data/repositories" | Out-Null
New-Item -ItemType Directory -Force -Path "$baseDir/presentation/bloc" | Out-Null

# 0. Demo Data Model
$modelContent = @"
/// Data Model for ${pascalName} Feature
class ${pascalName}Model {
  final String? id;
  final String? title;

  ${pascalName}Model({
    this.id,
    this.title,
  });

  factory ${pascalName}Model.fromJson(Map<String, dynamic> json) {
    return ${pascalName}Model(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
"@
Set-Content -Path "$baseDir/data/models/${snakeName}_model.dart" -Value $modelContent

# 1. Local Data Source
$localDsContent = @"
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure-storage-interface.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/keys.dart';

class ${pascalName}LocalDataSource {
  final ISecureStorageService _secureStorage;

  ${pascalName}LocalDataSource(this._secureStorage);

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
"@
Set-Content -Path "$baseDir/data/datasources/${snakeName}_local_data_source.dart" -Value $localDsContent

# 2. Remote Data Source
$remoteDsContent = @"
import 'package:batch_management_app_direct/bloc-version/services/network/endpoints/api_endpoints.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/models/api_result.dart';

class ${pascalName}RemoteDataSource {
  final INetworkService _networkService;

  ${pascalName}RemoteDataSource(this._networkService);

  /// Execute ${pascalName} API POST Request
  Future<ApiResult<dynamic>> ${camelName}({
    required String email,
    required String password,
  }) async {
    return await _networkService.post(
      ApiEndpoints.${camelName},
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
"@
Set-Content -Path "$baseDir/data/datasources/${snakeName}_remote_data_source.dart" -Value $remoteDsContent

# 3. Repository with Active fpdart Response Parsing Template
$repoContent = @"
import 'package:fpdart/fpdart.dart';
import 'package:batch_management_app_direct/bloc-version/core/errors/failure.dart';

import '../datasources/${snakeName}_local_data_source.dart';
import '../datasources/${snakeName}_remote_data_source.dart';

class ${pascalName}Repository {
  final ${pascalName}LocalDataSource _localDataSource;
  final ${pascalName}RemoteDataSource _remoteDataSource;

  ${pascalName}Repository({
    required ${pascalName}LocalDataSource localDataSource,
    required ${pascalName}RemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Executes ${pascalName} Action & returns Either
  Future<Either<Failure, void>> ${camelName}({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.${camelName}(
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
      return Left(ServerFailure(responseData['message'] ?? '${pascalName} Action failed'));
    }

    return Left(ServerFailure(result.errorMessage ?? 'Network error occurred'));
  }
}
"@
Set-Content -Path "$baseDir/data/repositories/${snakeName}_repository.dart" -Value $repoContent

# 4. State Class
$stateContent = @"
import 'package:equatable/equatable.dart';

abstract class ${pascalName}State extends Equatable {
  const ${pascalName}State();

  @override
  List<Object?> get props => [];
}

class ${pascalName}Initial extends ${pascalName}State {}

class ${pascalName}Loading extends ${pascalName}State {}

class ${pascalName}Success extends ${pascalName}State {}

class ${pascalName}Failure extends ${pascalName}State {
  final String errorMessage;

  const ${pascalName}Failure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
"@
Set-Content -Path "$baseDir/presentation/bloc/${snakeName}_state.dart" -Value $stateContent

# 5. Cubit Class
$cubitContent = @"
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/${snakeName}_repository.dart';
import '${snakeName}_state.dart';

class ${pascalName}Cubit extends Cubit<${pascalName}State> {
  final ${pascalName}Repository _${camelName}Repository;

  ${pascalName}Cubit(this._${camelName}Repository) : super(${pascalName}Initial());
}
"@
Set-Content -Path "$baseDir/presentation/bloc/${snakeName}_cubit.dart" -Value $cubitContent

# 6. View Widget
$viewContent = @"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';

import 'bloc/${snakeName}_cubit.dart';
import 'bloc/${snakeName}_state.dart';

class ${pascalName}View extends StatefulWidget {
  const ${pascalName}View({super.key});

  @override
  State<${pascalName}View> createState() => _${pascalName}ViewState();
}

class _${pascalName}ViewState extends State<${pascalName}View> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${pascalName}Cubit>(
      create: (context) => sl<${pascalName}Cubit>(),
      child: BlocConsumer<${pascalName}Cubit, ${pascalName}State>(
        listener: (context, state) {
          if (state is ${pascalName}Failure) {
            AppSnackbar.show(
              context: context,
              message: state.errorMessage,
              isSuccess: false,
            );
          } else if (state is ${pascalName}Success) {
            AppSnackbar.show(
              context: context,
              message: '${pascalName} Success!',
              isSuccess: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ${pascalName}Loading;

          return Scaffold(
            appBar: AppBar(title: const Text('${pascalName}')),
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
"@
Set-Content -Path "$baseDir/presentation/${snakeName}_view.dart" -Value $viewContent

# 7. DI Module File
$diContent = @"
import 'package:batch_management_app_direct/bloc-version/core/dependency/service_locator.dart';
import 'package:batch_management_app_direct/bloc-version/services/network/interfaces/i_network_service.dart';
import 'package:batch_management_app_direct/bloc-version/services/storage/secure/secure-storage-interface.dart';

import 'data/datasources/${snakeName}_local_data_source.dart';
import 'data/datasources/${snakeName}_remote_data_source.dart';
import 'data/repositories/${snakeName}_repository.dart';
import 'presentation/bloc/${snakeName}_cubit.dart';

/// Dependency Injection module for ${pascalName} feature
void init${pascalName}Dependencies() {
  sl.registerLazySingleton<${pascalName}LocalDataSource>(
    () => ${pascalName}LocalDataSource(sl<ISecureStorageService>()),
  );

  sl.registerLazySingleton<${pascalName}RemoteDataSource>(
    () => ${pascalName}RemoteDataSource(sl<INetworkService>()),
  );

  sl.registerLazySingleton<${pascalName}Repository>(
    () => ${pascalName}Repository(
      localDataSource: sl<${pascalName}LocalDataSource>(),
      remoteDataSource: sl<${pascalName}RemoteDataSource>(),
    ),
  );

  sl.registerFactory<${pascalName}Cubit>(
    () => ${pascalName}Cubit(sl<${pascalName}Repository>()),
  );
}
"@
Set-Content -Path "$baseDir/${snakeName}_di.dart" -Value $diContent

Write-Host "Success: Generated feature code inside $baseDir" -ForegroundColor Green
