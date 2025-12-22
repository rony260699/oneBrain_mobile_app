import 'dart:convert';

import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/common_widgets/hexcolor.dart';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/resources/image.dart';
import 'package:OneBrain/models/plan_user_model.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

bool isBypassPayment = false;

class AIModelService {
  static List<String> defaultProviders = [
    'chatgpt',
    'claude',
    'deepseek',
    'gemini',
    'grok',
  ];

  static List<AIModel>? allAIModels;

  static void initDefaultModel() {
    AIModel? localDefaultModel = getDefaultModel();

    if (localDefaultModel == null) {
      setDefaultModelByPrice();
    }
  }

  static Future<void> init() async {
    final String jsonString = await rootBundle.loadString(
      LocalFiles.aiModelsJsonFile,
    );
    final List<dynamic> data = json.decode(jsonString);
    final models = data.map((json) => AIModel.fromJson(json)).toList();
    allAIModels = models;

    allConversationsProviders = initAllConversationsProviders();

    if (prefs?.getStringList(_activeProvidersKey) == null) {
      prefs?.setStringList(_activeProvidersKey, defaultProviders);
    }
    // <<<<<<< HEAD
    // =======

    //     setDefaultModelByPrice();

    //     // Load the last selected model if available
    //     await loadLastSelectedModel();

    //     isInitialized = true;
    // >>>>>>> 9292e41a (Improved scrolling behavioral on chat screen and add conditional logic for payment flow)
  }

  static setDefaultModelByPrice() {
    int activePlanPrice = ProfileService.user?.package?.currentPlan?.price ?? 0;

    if (activePlanPrice == 0 || activePlanPrice == 299) {
      AIModel? model;
      if (prefs?.getBool("isLockedPremiumModel") ?? false) {
        model = allAIModels?.firstWhereOrNull(
          (model) => model.name?.contains("Unlimited") ?? false,
        );
      } else {
        model = allAIModels?.firstWhereOrNull(
          (model) => model.model == 'gpt-4.1-nano',
        );
      }
      model ??= allAIModels?.firstWhereOrNull(
        (model) => model.model == 'gpt-4.1-nano',
      );

      setDefaultModel(model);
    }
    if (activePlanPrice >= 699) {
      AIModel? model = allAIModels?.firstWhere((model) => model.model == 'max');
      setDefaultModel(model);
    }
  }

  static getDefaultModelsAfterTokenComplete() {
    int activePlanPrice = ProfileService.user?.package?.currentPlan?.price ?? 0;

    int availableTokens =
        ProfileService.user?.tokenCounter?.availableTokens ?? 0;

    if (activePlanPrice >= 299 &&
        !(defaultModel?.model?.contains('Unlimited') ?? false)) {
      if (availableTokens <= 0) {
        AIModel? model = allAIModels?.firstWhere(
          (model) => model.model == 'chatgpt-unlimited',
        );
        setDefaultModel(model);
      }
    }
  }

  static List<Map<String, dynamic>> allConversationsProviders = [];

  static AIModel? _defaultModel;

  static String? get defaultModelName => _defaultModel?.model;

  static AIModel? get defaultModel {
    if (ProfileService.canUseNeoModel) {
      return AIModel(name: "Neo", model: "neo", provider: "Neo");
    } else {
      return _defaultModel;
    }
  }

  static void setDefaultModel(AIModel? model) {
    _defaultModel = model;
    if (model == null) return;
    prefs?.setString(_defaultModelKey, jsonEncode(model.toJson()));
  }

  static final String _defaultModelKey = 'defaultModel';

  static AIModel? getDefaultModel() {
    String? model = prefs?.getString(_defaultModelKey);
    if (model == null) return null;
    AIModel? defaultModelValue = AIModel.fromJson(json.decode(model));
    _defaultModel = defaultModelValue;
    return defaultModelValue;
  }

  static List<Map<String, dynamic>> initAllConversationsProviders() {
    List<String?> providers =
        (allAIModels?.map((model) => model.provider).toSet().toList() ?? []);
    providers.removeWhere(
      (provider) => provider == 'auto' || provider == null || provider == 'max',
    );

    return providers
        .whereType<String>()
        .map(
          (provider) => {
            'provider': provider,
            'icon': getIcon(provider, false),
            'description': getDescription(provider),
          },
        )
        .toList();
  }

  static List<AIModel> getProviderModels(String provider, UserModel user) {
    int activePlanPrice = user.package?.currentPlan?.price ?? 0;

    // bool canProvideUnlimitedModel = false;

    int availableTokens = user.tokenCounter?.availableTokens ?? 0;

    // if (availableTokens <= 0) {
    //   canProvideUnlimitedModel = true;
    // }

    final models =
        allAIModels?.where((model) {
          // model.isLocked =
          //     model.provider == provider &&
          //     (model.includedPackages?.contains(activePlanPrice.toString()) ??
          //         false);

          // if (activePlanPrice == 0) {
          //   return true;
          // }

          if (model.provider == provider) {
            model.isLocked =
                !(model.includedPackages?.contains(
                      activePlanPrice.toString(),
                    ) ??
                    true);

            if (model.provider?.contains("max") ?? false) {
              model.isLocked = !(activePlanPrice >= 699);
              return true;
            }

            if (availableTokens <= 0 &&
                !(model.name?.contains("Unlimited") ?? false)) {
              model.isLocked = true;
            }

            if (activePlanPrice == 0) {
              return true;
            }

            if ((model.includedPackages?.contains(activePlanPrice.toString()) ??
                false)) {
              print("includedPackages : ${model.name}");
              return true;
            } else {
              print("not includedPackages : ${model.name}");
              return false;
            }
          } else {
            return false;
          }
        }).toList() ??
        [];
    // return models;

    //   int availableTokens =
    //     ProfileService.user?.tokenCounter?.availableTokens ?? 0;
    // int activePlanPrice = ProfileService.user?.package?.currentPlan?.price ?? 0;

    // availableTokens = 0;

    if (!(prefs?.getBool("isLockedPremiumModel") ?? false)) {
      if (availableTokens > 0 || activePlanPrice == 0) {
        models.removeWhere(
          (model) => model.name?.contains("Unlimited") ?? false,
        );
      }
    }

    // return models;

    List<AIModel> filteredModels = [];

    if (isBypassPayment) {
      filteredModels.addAll(models.where((model) => model.isLocked == false));
    } else {
      filteredModels.addAll(models);
    }

    if (prefs?.getBool("isLockedPremiumModel") ?? false) {
      for (var element in models) {
        if (element.provider == "max" ||
            (element.name?.contains("Unlimited") ?? false)) {
          element.isLocked = false;
        } else {
          element.isLocked = true;
        }
      }
    }

    return filteredModels;
  }

  static List<Map<String, dynamic>> getProviderByPlan(UserModel user) {
    if (prefs?.getStringList(_activeProvidersKey) == null) {
      prefs?.setStringList(_activeProvidersKey, defaultProviders);
    }

    List<String> activeProviders =
        prefs?.getStringList(_activeProvidersKey) ?? defaultProviders;

    List<String> finalProviders = activeProviders;

    int activePlanPrice = ProfileService.user?.package?.currentPlan?.price ?? 0;

    // List<String> planAllProviders =
    //     allAIModels
    //         ?.where((element) {
    //           return element.includedPackages?.contains(
    //                 activePlanPrice.toString(),
    //               ) ??
    //               false;
    //         })
    //         .map((element) => element.provider)
    //         .whereType<String>()
    //         .toList() ??
    //     [];

    // List<String> finalProviders =
    //     activeProviders
    //         .where((provider) => planAllProviders.contains(provider))
    //         .toList();

    if (!isBypassPayment || (isBypassPayment && activePlanPrice >= 699)) {
      finalProviders.insert(0, 'max');
    }

    // finalProviders.insert(0, 'max');

    final List<Map<String, dynamic>> finalProvidersList =
        finalProviders
            .map(
              (provider) => {
                'provider': provider,
                'icon': getIcon(provider, true),
              },
            )
            .toList();

    return finalProvidersList;
  }

  // static List<Map<String, dynamic>> get getProviders => allProviders;
  static List<Map<String, dynamic>> get getConversationsProviders =>
      allConversationsProviders;

  static final String _activeProvidersKey = 'activeProviders';

  static int get getActiveProvidersCount =>
      prefs?.getStringList(_activeProvidersKey)?.length ?? 0;

  static Future<void> toggleProviderStatus(
    String provider,
    BuildContext context,
  ) async {
    List<String> activeProviders =
        prefs?.getStringList(_activeProvidersKey) ?? [];
    if (activeProviders.length >= 5 && !activeProviders.contains(provider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              widthBox(8),
              Text("You can select only 5 providers"),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (activeProviders.length == 1 && activeProviders.contains(provider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              widthBox(8),
              Text("At least one model must remain active"),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    if (activeProviders.contains(provider)) {
      activeProviders.remove(provider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.remove_circle, color: Colors.white, size: 20),
              widthBox(8),
              Text("$provider deactivated"),
            ],
          ),
          backgroundColor: Colors.grey[700],
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      activeProviders.add(provider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              widthBox(8),
              Text("$provider activated"),
            ],
          ),
          backgroundColor: HexColor('#06B6D4'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    await prefs?.setStringList(_activeProvidersKey, activeProviders);
  }

  static bool isProviderActive(String provider) =>
      prefs?.getStringList(_activeProvidersKey)?.contains(provider) ?? false;

  static String getIcon(String provider, bool isWhite) {
    return switch (provider) {
      'chatgpt' =>
        isWhite
            ? 'assets/ai_icon/chatgpt-white.svg'
            : 'assets/ai_icon/chatgpt-black.svg',
      'claude' =>
        isWhite
            ? 'assets/ai_icon/cloude-white.svg'
            : 'assets/ai_icon/cloude-black.svg',
      'deepseek' => 'assets/ai_icon/deepseek.svg',
      'gemini' => 'assets/ai_icon/gemini.svg',
      'grok' =>
        isWhite
            ? 'assets/ai_icon/grok-white.svg'
            : 'assets/ai_icon/grok-black.svg',
      'llama' => 'assets/ai_icon/llama.svg',
      'mistral' => 'assets/ai_icon/mistral.svg',
      'perplexity' => 'assets/ai_icon/perplexity.svg',
      'qwen' =>
        isWhite
            ? 'assets/ai_icon/qwen-white.svg'
            : 'assets/ai_icon/qwen-black.svg',
      'max' => isWhite ? 'assets/ai_icon/max.svg' : 'assets/ai_icon/max.svg',
      'neo' => isWhite ? 'assets/ai_icon/max.svg' : 'assets/ai_icon/max.svg',

      _ => 'assets/ai_icon/chatgpt-black.svg',
    };
  }

  static String getDescription(String provider) {
    return switch (provider) {
      'chatgpt' =>
        'ChatGPT by OpenAI is a conversational AI model capable of generating human-like text, assisting with tasks such as writing, coding, and problem-solving.',
      'claude' =>
        'Claude, developed by Anthropic, is an AI assistant designed for safe, helpful, and context-aware interactions, excelling in complex reasoning and task execution.',
      'deepseek' =>
        'DeepSeek is an AI-powered language model designed for in-depth research, advanced information retrieval, and complex question-answering tasks.',
      'gemini' =>
        'Gemini is Google\'s advanced AI model designed for natural language understanding, reasoning, and content generation, optimized for diverse applications.',
      'grok' =>
        'Grok, developed by xAI, is an AI assistant focused on deep contextual understanding and reasoning, designed for insightful and informative responses.',
      'llama' =>
        'Llama (Large Language Model Meta AI) by Meta is a powerful open-weight AI model built for research and commercial applications in text generation and understanding.',
      'mistral' =>
        'Mistral AI offers high-performance open-weight language models optimized for efficiency, multilingual support, and enterprise-grade AI applications.',
      'perplexity' =>
        'Perplexity AI specializes in search-driven conversational AI, integrating deep reasoning and retrieval-based techniques for accurate and insightful responses.',
      'qwen' =>
        'Qwen, developed by Alibaba Cloud, is a versatile AI model optimized for natural language understanding, translation, and content creation.',
      _ => 'Unknown provider',
    };
  }
  // <<<<<<< HEAD
  // =======

  //   /// Save the selected model to SharedPreferences
  //   static Future<void> saveSelectedModel(AIModel model) async {
  //     try {
  //       final modelData = {
  //         'model': model.model,
  //         'provider': model.provider,
  //         'name': model.name,
  //         'company': model.company,
  //       };
  //       await prefs.setString(_lastSelectedModelKey, json.encode(modelData));
  //       defaultModel = model;
  //       print(
  //         '✅ Model saved: ${model.name} (${model.provider}) - Will be default for new chats',
  //       );
  //     } catch (e) {
  //       print('❌ Error saving selected model: $e');
  //     }
  //   }

  //   /// Load the last selected model from SharedPreferences
  //   static Future<void> loadLastSelectedModel() async {
  //     try {
  //       final savedModelString = prefs.getString(_lastSelectedModelKey);
  //       if (savedModelString != null && allAIModels != null) {
  //         // Parse the saved model JSON
  //         final Map<String, dynamic> savedModelData = json.decode(
  //           savedModelString,
  //         );

  //         final modelId = savedModelData['model'];
  //         final providerId = savedModelData['provider'];

  //         if (modelId != null && providerId != null) {
  //           // Find the model in allAIModels
  //           final savedModel = allAIModels?.firstWhere(
  //             (model) => model.model == modelId && model.provider == providerId,
  //             orElse: () => allAIModels!.first,
  //           );

  //           if (savedModel != null) {
  //             defaultModel = savedModel;
  //             print(
  //               '✅ Loaded saved model: ${savedModel.name} (${savedModel.provider}) - Restored as default',
  //             );
  //             return;
  //           }
  //         }
  //       }

  //       print('ℹ️ No saved model found, using default model');
  //     } catch (e) {
  //       print('❌ Error loading saved model: $e');
  //       print('ℹ️ Using default model instead');
  //     }
  //   }

  //   /// Get the currently selected model (for display purposes)
  //   static AIModel? get selectedModel => defaultModel;

  //   /// Set the selected model and save it
  //   static Future<void> setSelectedModel(AIModel model) async {
  //     await saveSelectedModel(model);
  //   }
  // >>>>>>> 9292e41a (Improved scrolling behavioral on chat screen and add conditional logic for payment flow)
}
