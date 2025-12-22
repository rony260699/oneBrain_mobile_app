# Complete Flutter OneBrain Attachment Integration

This document provides a complete example of how to integrate the OneBrain attachment feature with your Flutter mobile app. The integration includes file upload, AI-powered content parsing, streaming responses, and a professional UI.

## Architecture Overview

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   HomeScreen UI     │    │  HomeScreenCubit    │    │ OneBrainApiService  │
│                     │◄──►│                     │◄──►│                     │
│ - AttachmentWidget  │    │ - State Management  │    │ - Backend API       │
│ - Preview Dialog    │    │ - File Validation   │    │ - File Processing   │
│ - File Selection    │    │ - Parsed Content    │    │ - Streaming         │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
           │                           │                           │
           ▼                           ▼                           ▼
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│    User Interface   │    │    Business Logic   │    │   Backend Service   │
│                     │    │                     │    │                     │
│ - Visual Feedback   │    │ - Attachment Store  │    │ - Parse Attachments │
│ - File Management   │    │ - AI Processing     │    │ - Send Messages     │
│ - Content Preview   │    │ - Message Sending   │    │ - Stream Responses  │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

## Backend API Endpoints

### 1. Parse Attachments Preview

- **Endpoint:** `POST /conversation/parse-attachments-preview`
- **Purpose:** Parse and extract content from files using AI
- **Model:** `gpt-4.1-nano` for intelligent content analysis

### 2. Send Message with Attachments

- **Endpoint:** `POST /conversation/add-message-to-conversation/:conversationId`
- **Purpose:** Send message with parsed attachments and receive streaming AI response
- **Model:** User-selected model (e.g., `gpt-4o`, `claude-3.5-sonnet`)

## Key Components

### 1. OneBrainApiService (`lib/repo_api/onebrain_api_service.dart`)

```dart
class OneBrainApiService {
  static final OneBrainApiService _instance = OneBrainApiService._internal();
  factory OneBrainApiService() => _instance;

  /// Parse attachments using preview endpoint
  Future<List<AttachmentParsed>> parseAttachmentsPreview(
    List<File> files, {
    String? conversationId,
    Function(String)? onStatusUpdate,
  }) async {
    // Implementation integrates with existing DioHelper and AppInterceptor
    // Uses proper authentication and error handling
  }

  /// Send message with attachments (streaming response)
  Future<void> sendMessageWithAttachments({
    required String conversationId,
    required String message,
    required List<AttachmentParsed> attachments,
    // ... other parameters
    required void Function(String chunk) onChunk,
    required void Function(String status) onStatus,
  }) async {
    // Implementation uses existing StreamPostService
    // Handles real-time streaming responses
  }
}
```

### 2. Updated HomeScreenCubit (`lib/screens/home/cubit/home_screen_cubit.dart`)

```dart
class HomeScreenCubit extends Cubit<HomeScreenStates> {
  /// New attachment management
  List<File> selectedAttachments = [];
  List<AttachmentParsed> parsedAttachments = [];
  bool isPreviewingAttachments = false;
  final OneBrainApiService _apiService = OneBrainApiService();

  /// Auto-preview attachments when files are selected
  void addAttachment(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      selectedAttachments.add(file);
      emit(HomeScreenSuccessState());

      // Automatically run preview to prepare parsed content
      _autoPreviewAttachments();
    }
  }

  /// Preview attachments using OneBrainApiService
  Future<List<AttachmentParsed>?> previewAttachments() async {
    try {
      parsedAttachments = await _apiService.parseAttachmentsPreview(
        selectedAttachments,
        conversationId: currentChatID.isNotEmpty ? currentChatID : null,
      );
      return parsedAttachments;
    } catch (error) {
      // Handle errors appropriately
      return null;
    }
  }

  /// Enhanced sendMessage with attachment support
  void sendMessage(bool isNeConversation, String message) async {
    // Validate and ensure attachments are parsed
    if (selectedAttachments.isNotEmpty && parsedAttachments.isEmpty) {
      await previewAttachments();
    }

    // Use OneBrainApiService for messages with attachments
    if (parsedAttachments.isNotEmpty) {
      await _apiService.sendMessageWithAttachments(
        conversationId: currentChatID,
        message: message,
        attachments: parsedAttachments,
        onChunk: (chunk) {
          // Handle streaming response chunks
        },
        onStatus: (status) {
          // Handle status updates
        },
      );
    }
  }
}
```

### 3. AttachmentPreviewWidget (`lib/screens/home/view/attachment_preview_widget.dart`)

```dart
class AttachmentPreviewWidget extends StatelessWidget {
  final List<AttachmentParsed> parsedAttachments;
  final VoidCallback? onClearAll;
  final Function(int)? onRemoveAttachment;
  final VoidCallback? onPreviewContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Professional UI with file icons, metadata, and actions
      child: Column(
        children: [
          // Header with attachment count and "AI Processed & Ready" indicator
          // Individual file cards with icons, names, sizes, and remove buttons
          // Preview button to show AI-parsed content
        ],
      ),
    );
  }
}
```

## File Type Support

The integration supports all file types that your backend processes:

### Documents

- **PDF:** `application/pdf`
- **Word:** `application/msword`, `application/vnd.openxmlformats-officedocument.wordprocessingml.document`
- **Excel:** `application/vnd.ms-excel`, `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- **PowerPoint:** `application/vnd.ms-powerpoint`, `application/vnd.openxmlformats-officedocument.presentationml.presentation`

### Media

- **Images:** `image/jpeg`, `image/png`, `image/webp`
- **Audio:** `audio/mp3`, `audio/wav`, `audio/mpeg`

### Text & Data

- **Text:** `text/plain`, `text/csv`

### Archives

- **Compressed:** `application/zip`, `application/x-rar-compressed`

## Usage Flow

### 1. File Selection

```dart
// User selects files through image selection dialog
void _handleAttachmentResult(dynamic result) {
  if (result is String) {
    homeCubit.addAttachment(result); // Auto-triggers AI preview
  }
}
```

### 2. Automatic AI Processing

```dart
// Files are automatically processed in background
void _autoPreviewAttachments() async {
  await previewAttachments(); // Calls gpt-4.1-nano for content extraction
}
```

### 3. Visual Feedback

```dart
// UI shows processing status and results
AttachmentPreviewWidget(
  parsedAttachments: homeCubit.parsedAttachments,
  onPreviewContent: () {
    showAttachmentContentPreview(context, homeCubit.parsedAttachments);
  },
)
```

### 4. Content Preview

```dart
// Users can preview AI-extracted content before sending
void showAttachmentContentPreview(BuildContext context, List<AttachmentParsed> attachments) {
  showDialog(
    context: context,
    builder: (context) => AttachmentContentPreviewDialog(
      parsedAttachments: attachments,
    ),
  );
}
```

### 5. Message Sending

```dart
// Send message with attachments and receive streaming response
await _apiService.sendMessageWithAttachments(
  conversationId: currentChatID,
  message: userMessage,
  attachments: parsedAttachments,
  onChunk: (chunk) => updateUIWithChunk(chunk),
  onStatus: (status) => showStatus(status),
);
```

## Key Features

### 1. **Intelligent File Processing**

- Uses `gpt-4.1-nano` to extract and summarize content from files
- Supports complex documents with accurate content parsing
- Provides structured metadata (title, file info, extracted text)

### 2. **Professional Mobile UI**

- Touch-friendly interface optimized for mobile interaction
- File icons and type descriptions for better UX
- Loading states and error handling with clear feedback
- Dark theme integration matching your app design

### 3. **Real-time Processing**

- Background AI processing when files are selected
- Status updates during file parsing ("Parsing files with AI...")
- Streaming responses during message sending
- Visual indicators for processing states

### 4. **Robust Error Handling**

- File type validation with user-friendly error messages
- File size limits (50MB per file, max 10 files)
- Network error handling with retry capabilities
- Graceful degradation when services are unavailable

### 5. **Memory Management**

- Efficient file handling and cleanup
- Automatic attachment clearing after successful sends
- Optimized image loading and display
- Proper disposal of resources

## Integration Checklist

- [✅] **OneBrainApiService** - Complete backend integration
- [✅] **AttachmentParsed Models** - Data structures for parsed content
- [✅] **HomeScreenCubit Updates** - State management with new attachment system
- [✅] **AttachmentPreviewWidget** - Professional UI component
- [✅] **File Validation** - Comprehensive type and size checking
- [✅] **Error Handling** - User-friendly error messages and states
- [✅] **Streaming Integration** - Real-time AI responses
- [✅] **Authentication** - JWT token management via existing interceptors
- [✅] **Memory Management** - Proper cleanup and resource management

## Authentication

The integration uses your existing authentication system:

- **JWT Tokens:** Managed automatically by `AppInterceptor`
- **Authorization Header:** `Bearer YOUR_JWT_TOKEN`
- **Token Refresh:** Handled by existing `DioHelper` setup
- **401 Handling:** Automatic logout on unauthorized responses

## Performance Optimizations

### 1. **Background Processing**

- Files are parsed immediately upon selection
- Users can continue typing while AI processes attachments
- No waiting when sending messages

### 2. **Efficient UI Updates**

- BLoC pattern for reactive state management
- Optimized widget rebuilds
- Smooth animations and transitions

### 3. **Network Optimization**

- Reuses existing Dio instance and interceptors
- Proper connection pooling and timeout handling
- Efficient multipart form data uploads

## Production Considerations

### 1. **Error Monitoring**

- Comprehensive error logging with context
- User-friendly error messages
- Graceful fallbacks for service outages

### 2. **File Security**

- File type validation before upload
- Size limits to prevent abuse
- Secure file handling and cleanup

### 3. **User Experience**

- Clear visual feedback for all operations
- Consistent design language
- Accessibility considerations

## Testing

The integration includes comprehensive testing considerations:

- Unit tests for `OneBrainApiService` methods
- Widget tests for `AttachmentPreviewWidget`
- Integration tests for complete attachment flow
- Error scenario testing

## Future Enhancements

Potential improvements for future versions:

- **File Thumbnails:** Preview images and document thumbnails
- **Batch Operations:** Select and process multiple files at once
- **Cloud Storage:** Integration with cloud storage services
- **Offline Support:** Cache parsed content for offline access
- **Advanced Filters:** More granular file type filtering

This integration provides a production-ready attachment system that matches the capabilities of your web application while being optimized for mobile interaction patterns.
