import 'dart:io';
import 'dart:ui' show Rect;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';

/// Google ML Kit을 사용한 OCR 서비스
class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
  final _logger = Logger();

  /// 이미지에서 텍스트 추출
  Future<String> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      _logger.i('OCR 성공: ${recognizedText.blocks.length}개 블록 인식');
      return recognizedText.text;
    } catch (e) {
      _logger.e('OCR 실패: $e');
      rethrow;
    }
  }

  /// 이미지에서 구조화된 텍스트 추출 (블록, 라인별)
  Future<RecognizedTextResult> extractStructuredText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final blocks = <TextBlockData>[];

      for (final block in recognizedText.blocks) {
        final lines = <String>[];
        for (final line in block.lines) {
          lines.add(line.text);
        }

        blocks.add(TextBlockData(
          text: block.text,
          lines: lines,
          boundingBox: block.boundingBox,
          confidence: _calculateBlockConfidence(block),
        ));
      }

      _logger.i('구조화된 OCR 성공: ${blocks.length}개 블록');

      return RecognizedTextResult(
        fullText: recognizedText.text,
        blocks: blocks,
      );
    } catch (e) {
      _logger.e('구조화된 OCR 실패: $e');
      rethrow;
    }
  }

  /// 블록의 평균 신뢰도 계산 (추정)
  double _calculateBlockConfidence(TextBlock block) {
    // ML Kit은 현재 신뢰도를 직접 제공하지 않으므로
    // 텍스트 길이와 구조로 추정
    if (block.text.isEmpty) return 0.0;

    double confidence = 0.7; // 기본값

    // 텍스트가 길수록 신뢰도 증가
    if (block.text.length > 10) confidence += 0.1;
    if (block.text.length > 20) confidence += 0.1;

    // 라인 수가 많을수록 신뢰도 증가
    if (block.lines.length > 2) confidence += 0.05;

    return confidence > 1.0 ? 1.0 : confidence;
  }

  /// 리소스 해제
  void dispose() {
    _textRecognizer.close();
  }
}

/// 인식된 텍스트 결과
class RecognizedTextResult {
  final String fullText;
  final List<TextBlockData> blocks;

  RecognizedTextResult({
    required this.fullText,
    required this.blocks,
  });

  /// 라인 단위로 분할
  List<String> get lines {
    return fullText.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  /// 신뢰도 높은 블록만 필터링
  List<TextBlockData> getHighConfidenceBlocks({double threshold = 0.7}) {
    return blocks.where((block) => block.confidence >= threshold).toList();
  }
}

/// 텍스트 블록 데이터
class TextBlockData {
  final String text;
  final List<String> lines;
  final Rect boundingBox;
  final double confidence;

  TextBlockData({
    required this.text,
    required this.lines,
    required this.boundingBox,
    required this.confidence,
  });

  @override
  String toString() {
    return 'TextBlock(text: $text, lines: ${lines.length}, confidence: ${confidence.toStringAsFixed(2)})';
  }
}
