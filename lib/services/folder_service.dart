import 'dart:convert';
import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/folder_model.dart';
import '../repo_api/rest_constants.dart';

class FolderService {
  static List<FolderModel>? _allFolders;
  static bool _isInitialized = false;

  // Cache keys
  static const String _cacheKeyFolders = 'cached_folders';
  static const String _cacheTimestamp = 'folders_cache_timestamp';

  // Cache duration in minutes
  static const int _cacheDurationMinutes = 30;

  /// Initialize the folder service and load all folders
  static Future<void> init() async {
    // Try to load from cache first

    try {
      if (_isInitialized) {
        final cachedFolders = await _getCachedFolders();
        if (cachedFolders.isNotEmpty && await _isCacheValid()) {
          _allFolders = cachedFolders;
          _isInitialized = true;
          return;
        }
      }

      // Fetch from API if cache is invalid or empty
      await _fetchFoldersFromAPI();
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FolderService: $e');
      }
      _allFolders = [];
      _isInitialized = false;
    }
  }

  /// Get all folders (returns cached data if available)
  static List<FolderModel> get getAllFolders => _allFolders ?? [];

  /// Refresh folders from API
  static Future<List<FolderModel>> refreshFolders() async {
    try {
      await _fetchFoldersFromAPI();
      return _allFolders ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing folders: $e');
      }
      return _allFolders ?? [];
    }
  }

  /// Create a new folder
  static Future<FolderModel?> createFolder(String name, String color) async {
    try {
      Map<String, dynamic> data = {'name': name, 'color': color};

      final response = await DioHelper.postData(
        url: '${RestConstants.baseUrl}${RestConstants.createFolder}',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true && responseData['data'] != null) {
          final newFolder = FolderModel.fromJson(responseData['data']);

          // Add to local cache
          _allFolders ??= [];
          _allFolders!.add(newFolder);
          await _cacheFolders(_allFolders!);

          return newFolder;
        }
      }

      throw Exception('Failed to create folder: ${response.statusCode}');
    } catch (e) {
      if (kDebugMode) {
        print('Error creating folder: $e');
      }
      throw Exception('Failed to create folder: $e');
    }
  }

  /// Update an existing folder
  static Future<FolderModel?> updateFolder(
    String folderId, {
    String? name,
    String? color,
    bool? isCollapsed,
  }) async {
    // try {
    final Map<String, dynamic> updates = {
      if (name != null) "name": name,
      if (color != null) "color": color,
      if (isCollapsed != null) "isCollapsed": isCollapsed,
    };

    final response = await DioHelper.patchData(
      url: '${RestConstants.baseUrl}${RestConstants.updateFolder}$folderId',
      data: updates,
      lang: 'en',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['success'] == true && response.data['data'] != null) {
        final updatedFolder = FolderModel.fromJson(response.data['data']);

        // Update local cache
        if (_allFolders != null) {
          final index = _allFolders!.indexWhere(
            (folder) => folder.id == folderId,
          );
          if (index != -1) {
            _allFolders![index] = updatedFolder;
            await _cacheFolders(_allFolders!);
          }
        }

        return updatedFolder;
      }
    }

    throw Exception('Failed to update folder: ${response.statusCode}');
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error updating folder: $e');
    //   }
    //   throw Exception('Failed to update folder: $e');
    // }
  }

  /// Delete a folder
  static Future<bool> deleteFolder(String folderId) async {
    try {
      final response = await DioHelper.deleteData(
        url: '${RestConstants.baseUrl}${RestConstants.deleteFolder}$folderId',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          // Remove from local cache
          if (_allFolders != null) {
            _allFolders!.removeWhere((folder) => folder.id == folderId);
            await _cacheFolders(_allFolders!);
          }

          return true;
        }
      }

      throw Exception('Failed to delete folder: ${response.statusCode}');
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting folder: $e');
      }
      throw Exception('Failed to delete folder: $e');
    }
  }

  /// Move a chat to a specific folder
  static Future<bool> moveChatToFolder(String chatId, String folderId) async {
    // try {
    Map<String, dynamic> data = {'folderId': folderId};

    final response = await DioHelper.patchData(
      url:
          '${RestConstants.baseUrl}${RestConstants.moveChatToFolder}$chatId/folder',
      data: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;
      await refreshFolders();
      return responseData['success'] == true;
    }

    return false;
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error moving chat to folder: $e');
    //   }
    //   return false;
    // }
  }

  /// Remove a chat from its current folder (move to no folder)
  static Future<bool> removeChatFromFolder(String chatId) async {
    try {
      Map<String, dynamic> data = {'folderId': null};

      final response = await DioHelper.patchData(
        url:
            '${RestConstants.baseUrl}${RestConstants.moveChatToFolder}$chatId/folder',
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData['success'] == true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error removing chat from folder: $e');
      }
      return false;
    }
  }

  /// Get folder by ID
  static FolderModel? getFolderById(String folderId) {
    if (_allFolders == null) return null;

    try {
      return _allFolders!.firstWhere((folder) => folder.id == folderId);
    } catch (e) {
      return null;
    }
  }

  /// Get folders by color
  static List<FolderModel> getFoldersByColor(String color) {
    if (_allFolders == null) return [];

    return _allFolders!.where((folder) => folder.color == color).toList();
  }

  /// Check if folder name already exists
  static bool isFolderNameExists(String name, {String? excludeFolderId}) {
    if (_allFolders == null) return false;

    return _allFolders!.any(
      (folder) =>
          folder.name?.toLowerCase() == name.toLowerCase() &&
          folder.id != excludeFolderId,
    );
  }

  /// Clear all cached data
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKeyFolders);
      await prefs.remove(_cacheTimestamp);
      _allFolders = null;
      _isInitialized = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing folder cache: $e');
      }
    }
  }

  // Private methods

  /// Fetch folders from API
  static Future<void> _fetchFoldersFromAPI() async {
    final response = await DioHelper.getData(
      url: '${RestConstants.baseUrl}${RestConstants.getFolders}',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;
      final folderResponse = FolderResponse.fromJson(responseData);

      if (folderResponse.success == true && folderResponse.data != null) {
        _allFolders = folderResponse.data!;
        await _cacheFolders(_allFolders!);
      } else {
        throw Exception('API returned unsuccessful response');
      }
    } else {
      throw Exception('Failed to fetch folders: ${response.statusCode}');
    }
  }

  /// Get cached folders
  static Future<List<FolderModel>> _getCachedFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKeyFolders);
      if (cachedData != null) {
        final List<dynamic> data = jsonDecode(cachedData);
        return data.map((json) => FolderModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading cached folders: $e');
      }
    }
    return [];
  }

  /// Cache folders to local storage
  static Future<void> _cacheFolders(List<FolderModel> folders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = folders.map((folder) => folder.toJson()).toList();
      await prefs.setString(_cacheKeyFolders, jsonEncode(data));
      await prefs.setInt(
        _cacheTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error caching folders: $e');
      }
    }
  }

  /// Check if cache is still valid
  static Future<bool> _isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestamp) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - timestamp;
      return diff < (_cacheDurationMinutes * 60 * 1000);
    } catch (e) {
      return false;
    }
  }

  /// Get initialization status
  static bool get isInitialized => _isInitialized;

  /// Get folders count
  static int get foldersCount => _allFolders?.length ?? 0;

  // Folder state management - start with WORK expanded, others collapsed
}
