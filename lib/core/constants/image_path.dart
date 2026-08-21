class ImagePath {
  static const splashIcon = 'assets/images/icon-removebg.png';
  static const wordmark = 'assets/images/text_logo_black-removebg-preview.png';
  static const hero = 'assets/images/hero_1.png';
  static const heroTwo = 'assets/images/hero_2.png';
  static const heroThree = 'assets/images/hero_3.png';
  static const midSection = 'assets/images/mid_section.png';

  static const categorySkinCare = 'assets/images/categories/skin-care.png';
  static const categoryMakeup = 'assets/images/categories/makeup.png';
  static const categoryHairCare = 'assets/images/categories/hair-care.png';
  static const categoryBathBody = 'assets/images/categories/bath-body.png';
  static const categoryEyeCare = 'assets/images/categories/eye-care.png';
  static const categoryGiftSets = 'assets/images/categories/gift-sets.png';

  static String categoryImage(String slug, String name) {
    final category = '$slug $name'.toLowerCase();
    if (category.contains('makeup') || category.contains('make-up')) {
      return categoryMakeup;
    }
    if (category.contains('hair')) return categoryHairCare;
    if (category.contains('bath') || category.contains('body')) {
      return categoryBathBody;
    }
    if (category.contains('eye')) return categoryEyeCare;
    if (category.contains('gift') || category.contains('combo')) {
      return categoryGiftSets;
    }
    return categorySkinCare;
  }
}
