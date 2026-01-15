import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

/// 이미지 전처리 서비스
class ImageProcessor {
  final _logger = Logger();

  /// 이미지 최적화 (리사이징 + 압축)
  Future<File> optimizeImage(File imageFile) async {
    try {
      // 이미지 로드
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('이미지 디코딩 실패');
      }

      _logger.i('원본 이미지: ${image.width}x${image.height}');

      // 리사이징 (최대 1920x1920)
      if (image.width > 1920 || image.height > 1920) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? 1920 : null,
          height: image.height > image.width ? 1920 : null,
        );
        _logger.i('리사이징 완료: ${image.width}x${image.height}');
      }

      // 임시 파일 생성
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/optimized_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      // JPEG 압축 (품질 85)
      final compressedBytes = img.encodeJpg(image, quality: 85);
      await tempFile.writeAsBytes(compressedBytes);

      _logger.i('이미지 최적화 완료: ${compressedBytes.length} bytes');

      return tempFile;
    } catch (e) {
      _logger.e('이미지 최적화 실패: $e');
      rethrow;
    }
  }

  /// 명도/콘트라스트 향상
  Future<File> enhanceContrast(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('이미지 디코딩 실패');
      }

      // 콘트라스트 증가 (10%)
      image = img.adjustColor(image, contrast: 1.1);

      // 밝기 약간 증가 (5%)
      image = img.adjustColor(image, brightness: 1.05);

      // 샤프닝 (3x3 커널)
      image = img.convolution(image, filter: [
        0, -1, 0,
        -1, 5, -1,
        0, -1, 0,
      ]);

      // 저장
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      final compressedBytes = img.encodeJpg(image, quality: 90);
      await tempFile.writeAsBytes(compressedBytes);

      _logger.i('콘트라스트 향상 완료');

      return tempFile;
    } catch (e) {
      _logger.e('콘트라스트 향상 실패: $e');
      rethrow;
    }
  }

  /// 이미지 회전 (자동 감지는 ML Kit에서 처리)
  Future<File> rotateImage(File imageFile, int degrees) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('이미지 디코딩 실패');
      }

      // 회전 각도에 따라 처리
      if (degrees == 90) {
        image = img.copyRotate(image, angle: 90);
      } else if (degrees == 180) {
        image = img.copyRotate(image, angle: 180);
      } else if (degrees == 270) {
        image = img.copyRotate(image, angle: 270);
      }

      // 저장
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/rotated_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      final compressedBytes = img.encodeJpg(image, quality: 90);
      await tempFile.writeAsBytes(compressedBytes);

      _logger.i('이미지 회전 완료: $degrees도');

      return tempFile;
    } catch (e) {
      _logger.e('이미지 회전 실패: $e');
      rethrow;
    }
  }

  /// 그레이스케일 변환 (OCR 정확도 향상)
  Future<File> convertToGrayscale(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('이미지 디코딩 실패');
      }

      // 그레이스케일 변환
      image = img.grayscale(image);

      // 저장
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/gray_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = File(tempPath);

      final compressedBytes = img.encodeJpg(image, quality: 90);
      await tempFile.writeAsBytes(compressedBytes);

      _logger.i('그레이스케일 변환 완료');

      return tempFile;
    } catch (e) {
      _logger.e('그레이스케일 변환 실패: $e');
      rethrow;
    }
  }

  /// 전체 전처리 파이프라인
  Future<File> preprocessForOcr(File imageFile) async {
    try {
      print('이미지 전처리 시작: ${imageFile.path}');

      // 파일 크기 확인
      final fileSize = await imageFile.length();
      print('원본 파일 크기: ${fileSize / (1024 * 1024)} MB');

      // 1. 최적화만 수행 (리사이징 + 압축)
      // 콘트라스트 향상은 메모리 많이 사용하므로 제외
      File processed = await optimizeImage(imageFile);

      print('전처리 완료: ${processed.path}');

      return processed;
    } catch (e, stackTrace) {
      print('이미지 전처리 실패: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 이미지 크기 확인
  Future<ImageSize> getImageSize(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('이미지 디코딩 실패');
    }

    return ImageSize(
      width: image.width,
      height: image.height,
      fileSize: bytes.length,
    );
  }

  /// 이미지 크기 검증 (5MB 제한)
  Future<bool> validateImageSize(File imageFile) async {
    final size = await imageFile.length();
    return size <= 5 * 1024 * 1024; // 5MB
  }
}

/// 이미지 크기 정보
class ImageSize {
  final int width;
  final int height;
  final int fileSize;

  ImageSize({
    required this.width,
    required this.height,
    required this.fileSize,
  });

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  @override
  String toString() {
    return 'ImageSize(${width}x$height, $fileSizeFormatted)';
  }
}
