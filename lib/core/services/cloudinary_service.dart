import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});

class CloudinaryService {
  static const String _cloudName = 'uavyxsiu';
  static const String _uploadPreset = 'tail_wags';

  late final CloudinaryPublic _cloudinary;

  CloudinaryService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Uploads any image file to Cloudinary under [folder] and returns the secure URL.
  Future<String> uploadImage({
    required XFile imageFile,
    String folder = 'uploads',
  }) async {
    final response = await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        imageFile.path,
        folder: folder,
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl;
  }

  /// Uploads profile picture for [uid] using CloudinaryPublic.
  Future<String> uploadProfilePicture({
    required String uid,
    required XFile imageFile,
  }) async {
    return uploadImage(imageFile: imageFile, folder: 'profile_pictures');
  }
}
