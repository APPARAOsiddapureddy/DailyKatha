import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import 'permission_service.dart';

class SafeImagePicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickFromGallery(BuildContext context) async {
    try {
      final granted = await PermissionService.requestGalleryPermission();
      if (!granted) {
        if (context.mounted) {
          await PermissionService.showPermissionDeniedDialog(context, 'Gallery');
        }
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image == null) return null;
      final ok = await _validateXFile(image);
      if (!ok) {
        if (context.mounted) _showErrorSnackBar(context, 'Selected image is unavailable. Please try again.');
        return null;
      }
      return image;
    } on PlatformException catch (e) {
      debugPrint('Image picker PlatformException: ${e.code} — ${e.message}');
      if (context.mounted) _showErrorSnackBar(context, 'Could not open gallery. Please try again.');
      return null;
    } catch (e) {
      debugPrint('Image picker unexpected error: $e');
      if (context.mounted) _showErrorSnackBar(context, 'Something went wrong. Please try again.');
      return null;
    }
  }

  static Future<XFile?> pickFromCamera(BuildContext context) async {
    try {
      final granted = await PermissionService.requestCameraPermission();
      if (!granted) {
        if (context.mounted) {
          await PermissionService.showPermissionDeniedDialog(context, 'Camera');
        }
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) return null;
      final ok = await _validateXFile(image);
      if (!ok) {
        if (context.mounted) _showErrorSnackBar(context, 'Captured image is unavailable. Please try again.');
        return null;
      }
      return image;
    } on PlatformException catch (e) {
      debugPrint('Camera PlatformException: ${e.code} — ${e.message}');
      if (context.mounted) _showErrorSnackBar(context, 'Could not open camera. Please check permissions.');
      return null;
    } catch (e) {
      debugPrint('Camera unexpected error: $e');
      if (context.mounted) _showErrorSnackBar(context, 'Something went wrong. Please try again.');
      return null;
    }
  }

  static Future<CroppedFile?> cropImage(BuildContext context, String sourcePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 92,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.scaffoldDark,
            toolbarWidgetColor: AppColors.accentGold,
            backgroundColor: AppColors.scaffoldDark,
            activeControlsWidgetColor: AppColors.accentGold,
            cropFrameColor: AppColors.accentGold,
            cropGridColor: AppColors.accentGold,
            showCropGrid: true,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
            aspectRatioLockEnabled: false,
          ),
        ],
      );
      return croppedFile;
    } on PlatformException catch (e) {
      debugPrint('Crop PlatformException: ${e.code} — ${e.message}');
      if (context.mounted) _showErrorSnackBar(context, 'Could not crop image. Please try again.');
      return null;
    } catch (e) {
      debugPrint('Crop unexpected error: $e');
      return null;
    }
  }

  static Future<bool> _validateXFile(XFile xfile) async {
    final file = File(xfile.path);
    final exists = await file.exists();
    if (!exists) {
      debugPrint('Image file does not exist at path: ${xfile.path}');
      return false;
    }
    final bytes = await file.length();
    if (bytes == 0) {
      debugPrint('Image file is empty');
      return false;
    }
    return true;
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

