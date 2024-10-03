import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatefulWidget {
  final String? url; // For network resources
  final File? file; // For local files

  const MediaWidget({Key? key, this.url, this.file}) : super(key: key);

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _controller;
  bool _isVideo = false;
  bool _isAudio = false;
  bool _isNetwork = false;

  final List<String> videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', '3gp', 'm4v', 'ts', 'm2ts', 'mts', 'vob'];

  final List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heif', 'heic', 'tiff', 'ico'];

  final List<String> audioExtensions = ['mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a'];

  @override
  void initState() {
    super.initState();
    print("dsfjkldsjgklfdjkl");
    if (widget.url != null) {
      _isNetwork = true;
      final extension = widget.url!.split('.').last.toLowerCase();
      _isVideo = videoExtensions.contains(extension);
      _isAudio = audioExtensions.contains(extension);

      if (_isVideo) {
        _controller = VideoPlayerController.network(widget.url!)
          ..initialize().then((_) {
            setState(() {});
            _controller?.setVolume(0.0);
            // _controller?.play();
          }).catchError((error) {
            setState(() {});
            print('Error initializing video player: $error');
          });
      } else if (_isAudio) {}
    } else if (widget.file != null) {
      final extension = widget.file!.path.split('.').last.toLowerCase();
      _isVideo = videoExtensions.contains(extension);
      _isAudio = audioExtensions.contains(extension);

      if (_isVideo) {
        _controller = VideoPlayerController.file(widget.file!)
          ..initialize().then((_) {
            setState(() {});
            _controller?.play();
          }).catchError((error) {
            // Handle initialization error
            setState(() {});
            print('Error initializing video player: $error');
          });
        _controller?.setVolume(0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      if (_isVideo) {
        return _buildVideoPlayer();
      } else if (_isAudio) {
        return _buildAudioPlayer();
      } else {
        return _buildNetworkImage();
      }
    } else {
      if (_isVideo) {
        return _buildVideoPlayer();
      } else if (_isAudio) {
        return _buildAudioPlayer();
      } else {
        return _buildLocalImage();
      }
    }
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 200,
      width: 300,
      child: Stack(
        children: [
          _controller?.value.isInitialized == true
              ? ClipRect(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            ),
          )
              : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ), // Show loading indicator
            ),
          ),
          if (_isNetwork == true)
            Positioned(
              top: 6,
              right: 6,
              child: Icon(
                Icons.video_collection,
                size: 20,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.6), borderRadius: BorderRadius.circular(5)),
      child: Icon(
        Icons.audiotrack,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildNetworkImage() {
    return Stack(
      children: [
        Image.network(
          widget.url!,
          fit: BoxFit.cover,
          height: 200,
          width: 300,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            } else {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ), // Show loading indicator
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Center(
                child: Icon(Icons.error, color: Colors.red), // Error icon
              ),
            );
          },
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Icon(
            Icons.image,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLocalImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.file(
        widget.file!,
        fit: BoxFit.cover,
        height: 40,
        width: 70,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Center(
              child: Icon(Icons.error, color: Colors.red), // Error icon
            ),
          );
        },
      ),
    );
  }
}
