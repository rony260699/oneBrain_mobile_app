# OneBrain Attachment Integration - Complete Setup Guide

## 📦 Required Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Core HTTP & API
  dio: ^5.4.0                    # HTTP client (already in your project)
  
  # File Handling
  file_picker: ^6.1.1           # File selection from device
  path: ^1.8.3                  # File path utilities
  
  # Permissions
  permission_handler: ^11.0.1   # Handle file access permissions
  
  # UI & User Experience
  flutter_spinkit: ^5.2.0       # Loading animations
  fluttertoast: ^8.2.4          # Success/error messages
  
  # State Management (if not already included)
  flutter_bloc: ^8.1.3          # BLoC pattern for state management
  
  # Screen Utilities (if not already included)
  flutter_screenutil: ^5.9.0    # Responsive design
```

## 🔧 Core Integration Files

### 1. **OneBrainApiService** (`lib/repo_api/onebrain_api_service.dart`)
```dart
final OneBrainApiService _apiService = OneBrainApiService();

// No manual authentication needed - uses existing AppInterceptor
// Automatically handles JWT tokens from SharedPreferences
```

### 2. **AttachmentPreviewWidget** (`lib/screens/home/view/attachment_preview_widget.dart`)
```dart
AttachmentPreviewWidget(
  parsedAttachments: homeCubit.parsedAttachments,
  onClearAll: () => homeCubit.clearAttachments(),
  onRemoveAttachment: (index) => homeCubit.removeAttachment(index),
  onPreviewContent: () => showAttachmentContentPreview(context, homeCubit.parsedAttachments),
  isPreviewingAttachments: homeCubit.isPreviewingAttachments,
)
```

### 3. **Updated HomeScreenCubit** (`lib/screens/home/cubit/home_screen_cubit.dart`)
```dart
// New attachment management properties
List<File> selectedAttachments = [];
List<AttachmentParsed> parsedAttachments = [];
bool isPreviewingAttachments = false;
final OneBrainApiService _apiService = OneBrainApiService();
```

## 🚀 Key Integration Points

### **Authentication**
```dart
// ✅ AUTOMATIC - No manual setup required
// Authentication handled by existing AppInterceptor
// JWT tokens automatically retrieved from SharedPreferences
// Authorization header: 'Bearer YOUR_JWT_TOKEN'
```

### **File Parsing Workflow**
```dart
// Step 1: Auto-parse when files are selected
void addAttachment(String filePath) {
  selectedAttachments.add(File(filePath));
  _autoPreviewAttachments(); // Automatic background processing
}

// Step 2: Parse with AI
Future<List<AttachmentParsed>?> previewAttachments() async {
  return await _apiService.parseAttachmentsPreview(
    selectedAttachments,
    conversationId: currentChatID,
    onStatusUpdate: (status) => print("Status: $status"),
  );
}
```

### **Streaming Message Sending**
```dart
// Step 3: Send with real-time AI response
await _apiService.sendMessageWithAttachments(
  conversationId: currentChatID,
  message: userMessage,
  attachments: parsedAttachments,
  model: 'gpt-4o',
  company: 'openai',
  onChunk: (chunk) => updateUIWithChunk(chunk),
  onStatus: (status) => showStatus(status),
  onError: (error) => showError(message: error),
);
```

### **Error Handling**
```dart
try {
  // API calls
} on DioException catch (e) {
  showError(message: 'API Error: ${e.response?.data['error'] ?? e.message}');
} catch (e) {
  showError(message: 'Error: $e');
}
```

### **File Validation**
```dart
// Automatic validation in OneBrainApiService
// - File types: PDF, Word, Excel, PowerPoint, Images, Audio, Text, Archives
// - Size limit: 50MB per file
// - Count limit: Maximum 10 files
// - User-friendly error messages
```

## 🌐 Backend API Endpoints

| Feature | Endpoint | Purpose | Model Used |
|---------|----------|---------|------------|
| **Parse Files** | `POST /conversation/parse-attachments-preview` | Extract content from files with AI | `gpt-4.1-nano` |
| **Send Message** | `POST /conversation/add-message-to-conversation/:id` | Send message with attachments | User-selected model |
| **Image Analysis** | `POST /conversation/process-image-intelligent` | Quick image analysis | `gpt-4.1-nano` |
| **Audio Transcription** | `POST /conversation/process-audio-transcription` | Convert audio to text | Whisper |

## 📱 UI Integration Examples

### **Basic Usage** (`lib/examples/simple_attachment_example.dart`)
```dart
// Simple 3-step process
class SimpleAttachmentExample extends StatefulWidget {
  // 1. Select files
  // 2. Parse with AI  
  // 3. Send message
}
```

### **Advanced Usage** (`lib/examples/attachment_usage_example.dart`)
```dart
// Full-featured implementation
class AttachmentUsageExample extends StatefulWidget {
  // Complete workflow with professional UI
  // File management, preview, validation
  // Real-time status updates
}
```

### **Production Integration** (Your `HomeScreen`)
```dart
// Replace existing attachment preview with:
AttachmentPreviewWidget(
  parsedAttachments: homeCubit.parsedAttachments,
  // ... callbacks
)

// Update send button condition:
opacity: (homeCubit.txtMessage.text.isNotEmpty || homeCubit.parsedAttachments.isNotEmpty) ? 1.0 : 0.5,
```

## 🔒 Security & Permissions

### **Android Permissions** (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

### **iOS Permissions** (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos for attachments</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images</string>
```

## 🎯 Supported File Types

### **Documents**
- **PDF:** `application/pdf`
- **Word:** `.doc`, `.docx`
- **Excel:** `.xls`, `.xlsx`
- **PowerPoint:** `.ppt`, `.pptx`

### **Media**
- **Images:** `.jpg`, `.jpeg`, `.png`, `.webp`
- **Audio:** `.mp3`, `.wav`, `.mpeg`

### **Text & Data**
- **Text:** `.txt`, `.csv`

### **Archives**
- **Compressed:** `.zip`, `.rar`

## ⚡ Performance Optimizations

### **Background Processing**
```dart
// Files processed immediately when selected
void addAttachment(String filePath) {
  selectedAttachments.add(File(filePath));
  _autoPreviewAttachments(); // Background AI processing
}
```

### **Memory Management**
```dart
// Automatic cleanup after sending
void clearAttachments() {
  selectedAttachments.clear();
  parsedAttachments.clear();
  isPreviewingAttachments = false;
}
```

### **Network Optimization**
- Reuses existing `DioHelper` instance
- Connection pooling and timeout handling
- Efficient multipart form data uploads
- Streaming responses for real-time feedback

## 🧪 Testing Your Integration

### **1. File Selection Test**
```dart
// Test file picker integration
await _selectFiles();
assert(selectedAttachments.isNotEmpty);
```

### **2. AI Parsing Test**
```dart
// Test AI content extraction
final parsed = await _apiService.parseAttachmentsPreview(files);
assert(parsed.isNotEmpty);
assert(parsed.first.text.isNotEmpty);
```

### **3. Message Sending Test**
```dart
// Test streaming message with attachments
await _apiService.sendMessageWithAttachments(
  // ... parameters
  onChunk: (chunk) => assert(chunk.isNotEmpty),
);
```

## 🚨 Common Issues & Solutions

### **Issue: Authentication Errors**
```dart
// ✅ Solution: Ensure user is logged in
// Authentication is automatic via AppInterceptor
// Check SharedPreferenceUtil.getUserData()?.accessToken
```

### **Issue: File Upload Fails**
```dart
// ✅ Solution: Check file size and type
// Max 50MB per file, 10 files total
// Use validateAttachments() before upload
```

### **Issue: Streaming Not Working**
```dart
// ✅ Solution: Check StreamPostService initialization
// Ensure proper URL construction and callback handling
```

### **Issue: UI Not Updating**
```dart
// ✅ Solution: Emit proper BLoC states
// Use emit(HomeScreenSuccessState()) after operations
```

## 📋 Integration Checklist

- [ ] **Dependencies Added** - All required packages in `pubspec.yaml`
- [ ] **Permissions Configured** - Android & iOS file access permissions
- [ ] **OneBrainApiService Integrated** - Service class added and configured
- [ ] **AttachmentPreviewWidget Added** - UI component integrated
- [ ] **HomeScreenCubit Updated** - State management enhanced
- [ ] **HomeScreen UI Updated** - Attachment preview widget integrated
- [ ] **File Validation Working** - Type and size validation functional
- [ ] **AI Parsing Working** - Background content extraction operational
- [ ] **Streaming Working** - Real-time AI responses functional
- [ ] **Error Handling Complete** - User-friendly error messages
- [ ] **Memory Management** - Proper cleanup and resource management

## 🎉 Ready to Use!

Your OneBrain mobile app now has complete attachment functionality matching your web application:

- **🤖 AI-Powered:** Intelligent content extraction using `gpt-4.1-nano`
- **📱 Mobile-Optimized:** Touch-friendly UI with professional design
- **⚡ Real-time:** Streaming responses and background processing
- **🔒 Secure:** Automatic authentication and file validation
- **🎯 Production-Ready:** Comprehensive error handling and optimization

The integration provides the exact same capabilities as your web application while being specifically optimized for mobile interaction patterns! 