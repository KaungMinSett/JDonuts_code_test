import '../../app/data/catalog_database.dart';
import '../domain/product.dart';

extension ProductRowMapping on ProductRow {
  // Expose the same domain product shape to Home and Product Detail.
  Product toProduct() => (
    id: id,
    code: code,
    name: name,
    description: description,
    priceMmk: priceMmk,
    isNew: isNew,
    discountPercent: discountPercent,
    imageAsset: imageAsset,
  );
}
