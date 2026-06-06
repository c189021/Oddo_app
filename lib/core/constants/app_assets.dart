/// Mascot (탄카츄) poses referenced across screens. Each maps to an image file
/// that will be dropped into `assets/images/character/` later. Until then,
/// `MascotImage` renders a styled placeholder, so missing files are harmless.
enum MascotPose {
  front,
  waving,
  thinking,
  writing,
  heart,
  clipboard,
  mic,
  mirror,
  shield,
  celebrate,
  sorry,
  letter,
  check,
  camera,
  counselor,
  wink,
}

/// Centralized asset path constants.
abstract final class AppAssets {
  AppAssets._();

  static const String _imageBase = 'assets/images';
  static const String _characterBase = '$_imageBase/character';
  static const String _iconBase = 'assets/icons';

  static const String logo = '$_imageBase/oddo_logo.png';

  /// Single unified mascot placeholder used everywhere for now. Per-pose
  /// images ([mascot]) will replace it in one pass once art is ready.
  static const String tankachuPlaceholder =
      'assets/characters/tankachu_placeholder.png';

  /// Resolves a character image path for the given [pose].
  static String mascot(MascotPose pose) => '$_characterBase/${pose.name}.png';

  static String icon(String name) => '$_iconBase/$name.png';
}
