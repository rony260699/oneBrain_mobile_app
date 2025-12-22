import 'package:flutter/material.dart';
import '../../../repo_api/onebrain_api_service.dart';

class AttachmentPreviewWidget extends StatelessWidget {
  final List<AttachmentParsed> parsedAttachments;
  final VoidCallback? onClearAll;
  final Function(int)? onRemoveAttachment;
  final VoidCallback? onPreviewContent;
  final bool isPreviewingAttachments;

  const AttachmentPreviewWidget({
    super.key,
    required this.parsedAttachments,
    this.onClearAll,
    this.onRemoveAttachment,
    this.onPreviewContent,
    this.isPreviewingAttachments = false,
  });

  @override
  Widget build(BuildContext context) {
    if (parsedAttachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF656FE2).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and actions
          Row(
            children: [
              Icon(Icons.attach_file, color: const Color(0xFF656FE2), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${parsedAttachments.length} file(s) attached',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (parsedAttachments.isNotEmpty &&
                  parsedAttachments.every(
                    (attachment) => attachment.text.isNotEmpty,
                  ))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'AI Processed & Ready',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              if (onClearAll != null)
                InkWell(
                  onTap: onClearAll,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.clear_all,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Files list
          ...parsedAttachments.asMap().entries.map((entry) {
            int index = entry.key;
            AttachmentParsed attachment = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // File icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF656FE2).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        one_brainApiService.getFileIcon(attachment.fileName),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // File info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachment.fileName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              one_brainApiService.getFileTypeDescription(
                                attachment.fileName,
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              attachment.fileSize,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        if (attachment.text.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Processed',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Remove button
                  if (onRemoveAttachment != null)
                    InkWell(
                      onTap: () => onRemoveAttachment!(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),

          // Preview button
          if (onPreviewContent != null && parsedAttachments.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isPreviewingAttachments ? null : onPreviewContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF656FE2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon:
                    isPreviewingAttachments
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.preview, size: 18),
                label: Text(
                  isPreviewingAttachments ? 'Processing...' : 'Preview Content',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dialog to show attachment content preview
class AttachmentContentPreviewDialog extends StatelessWidget {
  final List<AttachmentParsed> attachments;

  const AttachmentContentPreviewDialog({Key? key, required this.attachments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF656FE2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFF656FE2),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI-Parsed Content (${attachments.length} file${attachments.length != 1 ? 's' : ''})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: ListView.builder(
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                one_brainApiService.getFileIcon(
                                  attachment.fileName,
                                ),
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attachment.title,
                                      style: const TextStyle(
                                        color: const Color(0xFF656FE2),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${attachment.fileSize} • ${one_brainApiService.getFileTypeDescription(attachment.fileName)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Extracted Content
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Extracted Content:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  attachment.text.isNotEmpty
                                      ? attachment.text
                                      : 'No content extracted',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Close button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF656FE2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Show the content preview dialog
void showAttachmentContentPreview(
  BuildContext context,
  List<AttachmentParsed> parsedAttachments,
) {
  showDialog(
    context: context,
    builder:
        (context) =>
            AttachmentContentPreviewDialog(attachments: parsedAttachments),
  );
}
