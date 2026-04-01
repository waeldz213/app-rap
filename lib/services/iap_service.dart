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

  /// Initiates a subscription purchase flow.
  /// Returns true if the purchase was initiated successfully.
  Future<bool> purchaseSubscription(String productId) async {
    // TODO: Implement real purchase flow with in_app_purchase package.
    // For now, return false to signal that IAP is not yet available.
    return false;
  }

  /// Restores previously completed purchases.
  /// Returns true if restore was initiated successfully.
  Future<bool> restorePurchases() async {
    // TODO: Implement restore purchases with in_app_purchase package.
    return false;
  }

  void dispose() {
    // TODO: Cancel subscription to purchase stream
  }
}
