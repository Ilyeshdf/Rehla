import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../../config/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/journey_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../models/post_model.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String locationName;

  const CameraCaptureScreen({super.key, required this.locationName});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  XFile? _capturedImage;
  File? _filteredImage;
  bool _isProcessing = false;
  Position? _currentPosition;
  final String _selectedFilter = 'طبيعي'; 
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCameraAndLocation();
  }

  Future<void> _initCameraAndLocation() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _setupCameraController(_cameras[_selectedCameraIndex]);
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission p = await Geolocator.checkPermission();
        if (p == LocationPermission.always ||
            p == LocationPermission.whileInUse) {
          _currentPosition = await Geolocator.getCurrentPosition();
        }
      }
    } catch (e) {
      debugPrint("Init error: \$e");
    }
  }

  Future<void> _setupCameraController(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera Error: \$e");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isProcessing) return;

    setState(() {
      _isCameraInitialized = false;
    });

    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _setupCameraController(_cameras[_selectedCameraIndex]);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
        _isProcessing = false;
      });
      await _processImage(image.path);
    } catch (e) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _processImage(String path) async {
    setState(() => _isProcessing = true);
    try {

      if (_selectedFilter == 'طبيعي') {
        setState(() {
          _filteredImage = File(path);
          _isProcessing = false;
        });
        return;
      }

      final File imageFile = File(path);
      final bytes = await imageFile.readAsBytes();
      img.Image? rawImage = img.decodeImage(bytes);

      if (rawImage == null) {

        setState(() {
          _filteredImage = File(path);
          _isProcessing = false;
        });
        return;
      }

      if (_selectedFilter == 'دافئ') {
        img.colorOffset(rawImage, red: 20, green: 10, blue: -20);
      } else if (_selectedFilter == 'بارد') {
        img.colorOffset(rawImage, red: -10, green: 10, blue: 30);
      }

      final compressedBytes = img.encodeJpg(rawImage, quality: 80);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(compressedBytes);

      setState(() {
        _filteredImage = tempFile;
        _isProcessing = false;
      });
    } catch (e) {

      setState(() {
        _filteredImage = File(path);
        _isProcessing = false;
      });
    }
  }

  Future<void> _saveAndReturn() async {
    log("slm");

    if (_filteredImage == null) return;
    setState(() => _isProcessing = true);

    try {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Moment captured and posted! 🎉'),
          backgroundColor: AppConstants.accentTeal,
        ),
      );

      if (true) {
        final userProvider = context.read<UserProvider>();
        final journey = context.read<JourneyProvider>();
        final user = userProvider.currentUser;

        if (user != null) {

          final newPost = PostModel(
            id: 'p_${DateTime.now().millisecondsSinceEpoch}',
            userId: user.id,
            username: user.username,
            wilayaBadge: user.wilaya,
            journeyId: journey.journeyId.isNotEmpty
                ? journey.journeyId
                : 'j_auto',
            photoUrl: _filteredImage!
                .path, 
            caption: 'استكشفت ${widget.locationName} اليوم! ⛰️🇩🇿 #الجزائر',
            tags: ['#رحلة', '#اكتشف_الجزائر'],
            createdAt: DateTime.now(),
            distanceKm: journey.distanceKm,
            time: journey.duration,
            difficulty: journey.difficulty,
          );

          await context.read<FeedProvider>().addPost(newPost);
          await userProvider.addXp(150); 

          context.read<NavigationProvider>().setIndex(0);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Moment captured and posted! 🎉'),
              backgroundColor: AppConstants.accentTeal,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {

          Navigator.of(context).pop(_filteredImage!.path);
        }
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing && _capturedImage == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_capturedImage != null && _filteredImage != null) {
      return _buildPreviewScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraInitialized)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_controller!),
            )
          else
            const Center(child: CircularProgressIndicator()),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.locationName,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 48), 
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.white38,
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: _switchCamera,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.network(_filteredImage!.path, fit: BoxFit.cover),
          ),

          Positioned(
            bottom: 140,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.locationName,
                    style: GoogleFonts.cairo(
                      color: AppConstants.accentGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (_currentPosition != null)
                    Text(
                      '\${_currentPosition!.latitude.toStringAsFixed(4)}, \${_currentPosition!.longitude.toStringAsFixed(4)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () {
                  setState(() {
                    _capturedImage = null;
                    _filteredImage = null;
                  });
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _capturedImage = null;
                            _filteredImage = null;
                          });
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: Text(
                          'REPEAT',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _saveAndReturn,
                        icon: _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(
                          'POST IT',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.accentTeal,
                          foregroundColor: AppConstants.backgroundDark,
                          elevation: 8,
                          shadowColor: AppConstants.accentTeal.withValues(
                            alpha: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
