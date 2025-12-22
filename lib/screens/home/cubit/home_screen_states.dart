abstract class HomeScreenStates {}

class HomeScreenInitialState extends HomeScreenStates {}

class HomeScreenLoadingState extends HomeScreenStates {}

class HomeScreenNewConLoadingState extends HomeScreenStates {}

class HomeScreenConversationLoadingState extends HomeScreenStates {}

class HomeScreenConversationSuccessState extends HomeScreenStates {}

class HomeScreenSwitchLoadingState extends HomeScreenStates {}

class HomeScreenSuccessState extends HomeScreenStates {}

class HomeScreenChunkReceived extends HomeScreenStates {
  final String chunk;
  HomeScreenChunkReceived(this.chunk);
}

class HomeScreenStreamLoadingState extends HomeScreenStates {}

class HomeScreenStartStreaming extends HomeScreenStates {}

class HomeScreenStreamCompleted extends HomeScreenStates {}

// class HomeScreenNewChunkReceived extends HomeScreenStates {
//   final String chunk;
//   HomeScreenNewChunkReceived(this.chunk);
// }

class HomeScreenStreamError extends HomeScreenStates {
  final String error;
  HomeScreenStreamError(this.error);
}

class HomeScreenErrorState extends HomeScreenStates {
  final String errorMessage;

  HomeScreenErrorState(this.errorMessage);
}

// AI Tool Integration States
class HomeScreenToolSuggestionsUpdated extends HomeScreenStates {}

class HomeScreenToolTransitionStarted extends HomeScreenStates {}

class HomeScreenToolActivated extends HomeScreenStates {}

class HomeScreenToolDeactivated extends HomeScreenStates {}

class HomeScreenToolSuggestionsDismissed extends HomeScreenStates {}

class ChatMessageAdded extends HomeScreenStates {}

class ChatSwitched extends HomeScreenStates {}

class ChatLoaded extends HomeScreenStates {}

class ChatStatisticsUpdated extends HomeScreenStates {}

class HomeScreenNavigateToImageX extends HomeScreenStates {
  final String conversationId;
  HomeScreenNavigateToImageX(this.conversationId);
}

class HomeScreenVoiceListening extends HomeScreenStates {}

class HomeScreenVoiceRecognized extends HomeScreenStates {
  final String text;
  HomeScreenVoiceRecognized(this.text);
}

class HomeScreenVoiceStopped extends HomeScreenStates {}

class HomeScreenVoiceError extends HomeScreenStates {
  final String message;
  HomeScreenVoiceError(this.message);
}

class HomeScreenLanguageChanged extends HomeScreenStates {
  final String locale;
  HomeScreenLanguageChanged(this.locale);
}

class HomeScreenThinkingChanged extends HomeScreenStates {
  final bool isThinking;
  HomeScreenThinkingChanged(this.isThinking);
}

class HomeScreenMessageGenerationStopped extends HomeScreenStates {}

class HomeScreenEditModeEntered extends HomeScreenStates {}

class HomeScreenEditModeCancelled extends HomeScreenStates {}
