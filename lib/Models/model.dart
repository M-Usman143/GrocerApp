class Variant {
   String name;
   String curr_price;
   String pre_price;
   String image;
   String weight;
   String discount;
   String var_id;
   bool isTrending;


  Variant({
    required this.name,
    required this.curr_price,
    required this.pre_price,
    required this.image,
    required this.weight,
    required this.discount,
    required this.var_id,
    this.isTrending = false,

  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "curr_price": curr_price,
      "pre_price": pre_price,
      "weight": weight,
      "discount": discount,
      "image": image,
      "var_id": var_id,
      "isTrending": isTrending,
    };
  }

  factory Variant.fromJson(Map<dynamic, dynamic> json) {
    return Variant(
      name: json['name'] ?? '',
      curr_price: json['curr_price'] ?? '',
      pre_price: json['pre_price'] ?? '',
      image: json['image'] ?? '',
      weight: json['weight'] ?? '',
      discount: json['discount'] ?? '',
      var_id: json['var_id'] ?? '',
      isTrending: json['isTrending'] ?? false,
    );
  }

}

class Products {
   String pro_id;
   String name;
   String image;
   String weight;
   String discount;
   String curr_price;
   String pre_price;
   List<Variant> variants;  // Added variants

  Products({
    required this.pro_id,
    required this.name,
    required this.image,
    this.weight = '',
    this.discount = '',
    this.curr_price = '',
    this.pre_price = '',
    required this.variants,  // Added variants to constructor
  });
  Map<String, dynamic> toJson() {
    return {
      "pro_id": pro_id,
      "name": name,
      "image": image,
      "variants": variants.map((variant) => variant.toJson()).toList(),
    };
  }

  factory Products.fromJson(Map<dynamic, dynamic> json) {
    List<Variant> variants = [];
    if (json['variants'] != null) {
      json['variants'].forEach((v) {
        variants.add(Variant.fromJson(v));
      });
    }

    return Products(
      pro_id: json['pro_id'] ?? '',  // Provide a default value for null
      name: json['name'] ?? '',  // Provide a default value for null
      image: json['image'] ?? '',  // Provide a default value for null
      weight: json['weight'] ?? '',  // Provide a default value for null
      discount: json['discount'] ?? '',  // Provide a default value for null
      curr_price: json['curr_price'] ?? '',  // Provide a default value for null
      pre_price: json['pre_price'] ?? '',  // Provide a default value for null
      variants: variants,
    );
  }

}

class Categories {
   String name;
   String image;
   String subheading;
   String cat_id;
   List<Products> products;

  Categories({
    required this.name,
    required this.image,
    required this.subheading,
    required this.products,
    required this.cat_id,
  });

  Map<String, dynamic> toJson() {
    return {
      "category_id": cat_id,
      "name": name,
      "image": image,
      "subheading": subheading,
      "products": products.map((product) => product.toJson()).toList(),
    };
  }


  factory Categories.fromJson(Map<dynamic, dynamic> json) {
    List<Products> products = [];
    if (json['products'] != null) {
      json['products'].forEach((v) {
        products.add(Products.fromJson(v));
      });
    }

    return Categories(
      name: json['name'] ?? '',  // Provide a default value for null
      image: json['image'] ?? '',  // Provide a default value for null
      subheading: json['subheading'] ?? '',  // Provide a default value for null
      products: products,
      cat_id: json['cat_id'] ?? '',  // Provide a default value for null
    );
  }

}

// Method to get all variants for a given product
List<Variant> getVariantsForProduct(Products product) {
  return product.variants;
}

