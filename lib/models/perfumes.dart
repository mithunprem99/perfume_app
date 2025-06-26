
class HomeData {
  final List<HomeField> homeFields;
  HomeData({required this.homeFields});
  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      homeFields: (json['data']['home_fields'] as List)
          .map((item) => HomeField.fromJson(item))
          .toList(),
    );
  }
}

class HomeField {
  final String type;
  final List<CarouselItem>? carouselItems;
  final List<Brand>? brands;
  final List<Category>? categories;
  final String? image;
  final int? collectionId;
  final String? name;
  final List<Product>? products;
  final Banner? banner;
  final List<Banner>? banners;

  HomeField({
    required this.type,
    this.carouselItems,
    this.brands,
    this.categories,
    this.image,
    this.collectionId,
    this.name,
    this.products,
    this.banner,
    this.banners,
  });

  factory HomeField.fromJson(Map<String, dynamic> json) {
    return HomeField(
      type: json['type'],
      carouselItems: json['carousel_items'] != null
          ? (json['carousel_items'] as List)
              .map((item) => CarouselItem.fromJson(item))
              .toList()
          : null,
      brands: json['brands'] != null
          ? (json['brands'] as List).map((item) => Brand.fromJson(item)).toList()
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((item) => Category.fromJson(item))
              .toList()
          : null,
      image: json['image'],
      collectionId: json['collection_id'],
      name: json['name'],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((item) => Product.fromJson(item))
              .toList()
          : null,
      banner: json['banner'] != null ? Banner.fromJson(json['banner']) : null,
      banners: json['banners'] != null
          ? (json['banners'] as List).map((item) => Banner.fromJson(item)).toList()
          : null,
    );
  }
}

class CarouselItem {
  final int id;
  final String image;
  final String type;
  CarouselItem({required this.id, required this.image, required this.type});
  factory CarouselItem.fromJson(Map<String, dynamic> json) {
    return CarouselItem(
      id: json['id'],
      image: json['image'],
      type: json['type'],
    );
  }
}

class Brand {
  final int id;
  final String name;
  final String image;
  Brand({required this.id, required this.name, required this.image});
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;
  Category({required this.id, required this.name, required this.image});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
class Banner {
  final int id;
  final String image;
  final String type;
  Banner({required this.id, required this.image, required this.type});
  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      image: json['image'],
      type: json['type'],
    );
  }
}

class Product {
  final int id;
  final String image;
  final String name;
  final String currency;
  final String unit;
  final bool wishlisted;
  final bool rfqStatus;
  final int cartCount;
  final int futureCartCount;
  final bool hasStock;
  final String price;
  final String actualPrice;
  final String offer;

  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.currency,
    required this.unit,
    required this.wishlisted,
    required this.rfqStatus,
    required this.cartCount,
    required this.futureCartCount,
    required this.hasStock,
    required this.price,
    required this.actualPrice,
    required this.offer,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      currency: json['currency'],
      unit: json['unit'],
      wishlisted: json['wishlisted'],
      rfqStatus: json['rfq_status'],
      cartCount: json['cart_count'],
      futureCartCount: json['future_cart_count'],
      hasStock: json['has_stock'],
      price: json['price'],
      actualPrice: json['actual_price'],
      offer: json['offer'],
    );
  }
}