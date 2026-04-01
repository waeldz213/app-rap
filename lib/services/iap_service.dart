// Placeholder IAP service - implement with in_app_purchase package
// when ready to go to production.

class IapService {
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  Future<void> initialize() async {
    // TODO: Initialize in_app_purchase
    // final available = await InAppPurchase.instance.isAvailable();
    // _isAvailable = available;
    _isAvailable = false;
  }

  Future<void> purchaseSubscription(String productId) async {
    // TODO: Implement purchase flow
    throw UnimplementedError('IAP not yet implemented');
  }

  Future<void> restorePurchases() async {
    // TODO: Implement restore purchases
    throw UnimplementedError('IAP not yet implemented');
  }

  void dispose() {
    // TODO: Cancel subscription to purchase stream
  }
}
