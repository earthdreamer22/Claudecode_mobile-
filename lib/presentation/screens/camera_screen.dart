import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../config/constants.dart';
import '../../utils/ocr_service.dart';
import '../../utils/image_processor.dart';
import 'receipt_review_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      print('카메라 초기화 시작');
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        print('사용 가능한 카메라 없음');
        if (mounted) {
          _showError('카메라를 사용할 수 없습니다.');
        }
        return;
      }

      print('카메라 개수: ${_cameras!.length}');

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium, // high → medium으로 변경 (메모리 절약)
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // JPEG 포맷 명시
      );

      print('카메라 컨트롤러 초기화 중...');
      await _cameraController!.initialize();
      print('카메라 초기화 완료');

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e, stackTrace) {
      print('카메라 초기화 오류: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        _showError('카메라 초기화 실패: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // 사진 촬영
      print('카메라 촬영 시작');
      final image = await _cameraController!.takePicture();
      print('촬영 완료: ${image.path}');

      final imageFile = File(image.path);

      // 파일 존재 확인
      if (!await imageFile.exists()) {
        throw Exception('촬영된 이미지 파일을 찾을 수 없습니다.');
      }

      print('이미지 파일 크기: ${await imageFile.length()} bytes');

      // OCR 처리로 이동
      await _processImage(imageFile);
    } catch (e, stackTrace) {
      print('사진 촬영 오류: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        _showError('사진 촬영 실패: ${e.toString()}');
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _isProcessing = true;
      });

      final imageFile = File(pickedFile.path);

      // 파일 존재 확인
      if (!await imageFile.exists()) {
        if (mounted) {
          _showError('이미지 파일을 찾을 수 없습니다.');
          setState(() {
            _isProcessing = false;
          });
        }
        return;
      }

      // 이미지 크기 검증
      final imageProcessor = ImageProcessor();
      final isValid = await imageProcessor.validateImageSize(imageFile);

      if (!isValid) {
        if (mounted) {
          _showError(AppConstants.errorImageTooLarge);
          setState(() {
            _isProcessing = false;
          });
        }
        return;
      }

      // OCR 처리로 이동
      await _processImage(imageFile);
    } catch (e) {
      print('갤러리 선택 오류: $e');
      if (mounted) {
        _showError('갤러리에서 이미지를 불러오는데 실패했습니다.');
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      // 파일 존재 재확인
      if (!await imageFile.exists()) {
        throw Exception('이미지 파일이 존재하지 않습니다.');
      }

      // 이미지 전처리
      final imageProcessor = ImageProcessor();
      final processedImage = await imageProcessor.preprocessForOcr(imageFile);

      if (!await processedImage.exists()) {
        throw Exception('이미지 전처리에 실패했습니다.');
      }

      // OCR 텍스트 추출
      final ocrService = OcrService();
      String ocrText = '';

      try {
        ocrText = await ocrService.extractTextFromImage(processedImage);
      } catch (ocrError) {
        print('OCR 오류: $ocrError');
        throw Exception('텍스트 인식에 실패했습니다.');
      } finally {
        ocrService.dispose();
      }

      if (ocrText.trim().isEmpty) {
        if (mounted) {
          _showError(AppConstants.errorNoReceiptDetected);
          setState(() {
            _isProcessing = false;
          });
        }
        return;
      }

      // 영구 저장 경로로 복사
      final appDir = await getApplicationDocumentsDirectory();
      final permanentDir = Directory('${appDir.path}/receipts');

      if (!await permanentDir.exists()) {
        await permanentDir.create(recursive: true);
      }

      final permanentPath =
          '${appDir.path}/receipts/receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await processedImage.copy(permanentPath);

      // 복사된 파일 존재 확인
      if (!await File(permanentPath).exists()) {
        throw Exception('이미지 저장에 실패했습니다.');
      }

      if (!mounted) return;

      // 영수증 검증 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ReceiptReviewScreen(
            imagePath: permanentPath,
            ocrText: ocrText,
          ),
        ),
      );
    } catch (e) {
      print('이미지 처리 오류: $e');
      if (mounted) {
        _showError('이미지 처리 중 오류가 발생했습니다: ${e.toString().substring(0, 50)}');
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('영수증 촬영'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _isInitialized
          ? Stack(
              children: [
                // 카메라 프리뷰 (전체 화면)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _cameraController!.value.previewSize!.height,
                      height: _cameraController!.value.previewSize!.width,
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                ),

                // 영수증 가이드 오버레이
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '영수증을 프레임 안에 맞춰주세요',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 처리 중 오버레이
                if (_isProcessing)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'OCR 처리 중...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
      bottomNavigationBar: !_isProcessing && _isInitialized
          ? Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 갤러리 버튼
                    IconButton(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      color: Colors.white,
                      iconSize: 32,
                    ),

                    // 촬영 버튼
                    GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // 플래시 버튼 (placeholder)
                    IconButton(
                      onPressed: () {
                        // TODO: 플래시 토글
                      },
                      icon: const Icon(Icons.flash_off),
                      color: Colors.white,
                      iconSize: 32,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
