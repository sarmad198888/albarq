class OrderModel {
  final String id;

  final String restaurantName;

  final String customerName;

  final String customerAddress;

  final String customerPhone;

  final double distance;

  final int deliveryPrice;

  final int orderTotal;

  final String paymentMethod;

  final String status;

  const OrderModel({
    required this.id,
    required this.restaurantName,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.distance,
    required this.deliveryPrice,
    required this.orderTotal,
    required this.paymentMethod,
    required this.status,
  });
}