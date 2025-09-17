import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class PDFReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdfTitle;
  final int pdfId;

  const PDFReaderScreen({
    super.key,
    required this.pdfUrl,
    required this.pdfTitle,
    required this.pdfId,
  });

  @override
  State<PDFReaderScreen> createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  String? localPath;
  bool _isLoading = true;
  bool _isDownloading = false;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    try {
      setState(() {
        _isDownloading = true;
        _errorMessage = null;
      });

      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName =
          '${widget.pdfId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(widget.pdfUrl, filePath);

      setState(() {
        localPath = filePath;
        _isDownloading = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _isLoading = false;
        _errorMessage = 'Failed to download PDF: $e';
      });
    }
  }

  void _onPageChanged(int page, int total) {
    setState(() {
      _currentPage = page;
      _totalPages = total;
    });
  }

  void _onViewCreated(PDFViewController controller) {
    setState(() {
      _isReady = true;
    });
  }

  void _onRender(int pages) {
    setState(() {
      _totalPages = pages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.pdfTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          if (_isReady && _totalPages > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          IconButton(
            onPressed: () {
              // TODO: Implement PDF sharing
              Get.snackbar('Info', 'Share functionality will be implemented');
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: _buildBody(theme),
      bottomNavigationBar: _isReady && _totalPages > 0
          ? _buildBottomNavigation(theme)
          : null,
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading || _isDownloading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDownloading) ...[
              CircularProgressIndicator(color: theme.colorScheme.primary),
              SizedBox(height: 16),
              Text(
                'Downloading PDF...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              CircularProgressIndicator(color: theme.colorScheme.primary),
              SizedBox(height: 16),
              Text(
                'Loading PDF...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            SizedBox(height: 16),
            Text(
              'Error',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _downloadPDF,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (localPath == null) {
      return Center(
        child: Text(
          'PDF not available',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return PDFView(
      filePath: localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      onRender: (pages) => _onRender(pages ?? 0),
      onViewCreated: _onViewCreated,
      onPageChanged: (page, total) => _onPageChanged(page ?? 0, total ?? 0),
      onError: (error) {
        setState(() {
          _errorMessage = 'Failed to load PDF: $error';
        });
      },
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () {
                    // TODO: Navigate to previous page
                  }
                : null,
            icon: Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
          Expanded(
            child: Slider(
              value: _currentPage.toDouble(),
              max: (_totalPages - 1).toDouble(),
              divisions: _totalPages - 1,
              onChanged: (value) {
                // TODO: Navigate to specific page
              },
            ),
          ),
          IconButton(
            onPressed: _currentPage < _totalPages - 1
                ? () {
                    // TODO: Navigate to next page
                  }
                : null,
            icon: Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
