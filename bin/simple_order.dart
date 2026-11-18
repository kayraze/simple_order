const Map<String, double> _kCanteenMenu = {
  'Adobo rice': 85.0,
  'Iced tea': 35.0,
  'Turon': 25.0,
};

class LineItem {
  final String menuItem;
  final double unitCost;
  final int quantity;

  const LineItem({
    required this.menuItem,
    required this.unitCost,
    required this.quantity,
  });

  double get totalCost => unitCost * quantity;
}

class ReceiptPrinter {
  static const double _discountThreshold = 300.0;
  static const double _discountRate = 0.10;

  static void generate(List<LineItem> items, {String? targetCustomer}) {
    final patron = targetCustomer?.trim().isNotEmpty == true
        ? targetCustomer!
        : 'Guest';
    print('Order for $patron');

    for (final item in items) {
      final description = '${item.quantity} x ${item.menuItem}';
      final formattedPrice = item.totalCost.toStringAsFixed(2);
      print('${description.padRight(18)} ${formattedPrice.padLeft(8)}');
    }

    final grossSum = items.fold<double>(
      0.0,
      (acc, curr) => acc + curr.totalCost,
    );
    print('Subtotal          ${grossSum.toStringAsFixed(2).padLeft(8)}');

    if (grossSum >= _discountThreshold) {
      final deduction = grossSum * _discountRate;
      print('Discount 10%     -${deduction.toStringAsFixed(2).padLeft(8)}');
      final netSum = grossSum - deduction;
      print('Total             ${netSum.toStringAsFixed(2).padLeft(8)}');
    } else {
      print('Total             ${grossSum.toStringAsFixed(2).padLeft(8)}');
    }
    print('');
  }
}

class CanteenSystem {
  static LineItem createEntry(String itemKey, int count) {
    final cost = _kCanteenMenu[itemKey];
    if (cost == null) {
      throw ArgumentError(
        'Catalog Error: "$itemKey" is invalid or unavailable.',
      );
    }
    return LineItem(menuItem: itemKey, unitCost: cost, quantity: count);
  }
}

void main() {
  final primaryCart = [
    CanteenSystem.createEntry('Adobo rice', 3),
    CanteenSystem.createEntry('Iced tea', 1),
    CanteenSystem.createEntry('Turon', 3),
  ];
  ReceiptPrinter.generate(primaryCart);

  final secondaryCart = [
    CanteenSystem.createEntry('Adobo rice', 1),
    CanteenSystem.createEntry('Turon', 2),
  ];
  ReceiptPrinter.generate(secondaryCart, targetCustomer: 'Maria');
}
