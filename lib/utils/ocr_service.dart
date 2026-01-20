import 'dart:io';
import 'dart:ui' show Rect;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'llm_parser_service.dart';

/// Google ML Kit을 사용한 OCR 서비스
class OcrService {
  // Korean 스크립트 사용 (한글 영수증 인식)
  TextRecognizer? _textRecognizer;

  OcrService() {
    try {
      print('OCR 서비스 초기화 시작 (Korean)');
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
      print('OCR 서비스 초기화 완료');
    } catch (e) {
      print('OCR 서비스 초기화 실패: $e');
    }
  }

  /// 이미지에서 텍스트 추출
  Future<String> extractTextFromImage(File imageFile) async {
    print('OCR 텍스트 추출 시작: ${imageFile.path}');

    if (_textRecognizer == null) {
      print('OCR: TextRecognizer가 null입니다. 재초기화 시도...');
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
    }

    try {
      // 파일 존재 확인
      if (!await imageFile.exists()) {
        throw Exception('이미지 파일이 존재하지 않습니다: ${imageFile.path}');
      }

      final fileSize = await imageFile.length();
      print('OCR 이미지 파일 크기: ${fileSize / 1024} KB');

      print('OCR InputImage 생성 중...');
      final inputImage = InputImage.fromFile(imageFile);
      print('OCR InputImage 생성 완료');

      print('OCR 텍스트 인식 시작...');
      final recognizedText = await _textRecognizer!.processImage(inputImage);
      print('OCR 텍스트 인식 완료: ${recognizedText.blocks.length}개 블록');

      // OCR Raw 텍스트 로그 출력
      print('=== OCR RAW TEXT START ===');
      print(recognizedText.text);
      print('=== OCR RAW TEXT END ===');

      // 블록별 상세 로그
      print('=== OCR BLOCKS DETAIL ===');
      for (int i = 0; i < recognizedText.blocks.length; i++) {
        final block = recognizedText.blocks[i];
        print('Block[$i]: "${block.text}"');
        for (int j = 0; j < block.lines.length; j++) {
          print('  Line[$j]: "${block.lines[j].text}"');
        }
      }
      print('=== OCR BLOCKS END ===');

      return recognizedText.text;
    } catch (e, stackTrace) {
      print('OCR 실패: $e');
      print('OCR Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 이미지에서 구조화된 텍스트 추출 (블록, 라인별)
  Future<RecognizedTextResult> extractStructuredText(File imageFile) async {
    if (_textRecognizer == null) {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
    }

    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

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

      print('구조화된 OCR 성공: ${blocks.length}개 블록');

      return RecognizedTextResult(
        fullText: recognizedText.text,
        blocks: blocks,
      );
    } catch (e, stackTrace) {
      print('구조화된 OCR 실패: $e');
      print('Stack trace: $stackTrace');
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

  /// OCR + LLM 파싱 통합 (권장)
  Future<LlmParseResult?> extractAndParseWithLlm(File imageFile) async {
    print('OCR + LLM 파싱 시작');

    try {
      // 1. OCR로 텍스트 추출
      final structuredResult = await extractStructuredText(imageFile);

      // 2. 블록 데이터 준비
      final blocks = structuredResult.blocks.map((block) => {
        'text': block.text,
        'lines': block.lines,
      }).toList();

      // 3. LLM으로 파싱
      final llmParser = LlmParserService();
      final result = await llmParser.parseReceipt(
        ocrText: structuredResult.fullText,
        blocks: blocks,
      );

      if (result != null) {
        print('LLM 파싱 성공: ${result.items.length}개 항목');
        for (final item in result.items) {
          print('  - ${item.name}: ${item.quantity}개 x ${item.price}원');
        }
      } else {
        print('LLM 파싱 실패 - fallback 필요');
      }

      return result;
    } catch (e, stackTrace) {
      print('OCR + LLM 파싱 오류: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// 리소스 해제
  void dispose() {
    print('OCR 서비스 dispose 시작');
    try {
      _textRecognizer?.close();
      _textRecognizer = null;
      print('OCR 서비스 dispose 완료');
    } catch (e) {
      print('OCR dispose 오류: $e');
    }
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
