class RequestedItemModel {
  int totalRequested;
  int totalUderProcessing;
  int totalToBeReceived;

  int activeUsers;
  int onWarrantyProcess;
  int expiredItems;
  int totalUnderWarranty;
  int expiredThisMonth;

  RequestedItemModel({
    this.totalRequested,
    this.totalUderProcessing,
    this.totalToBeReceived,
    //
    this.activeUsers,
    this.onWarrantyProcess,
    this.expiredItems,
    this.totalUnderWarranty,
    this.expiredThisMonth,
  });

  RequestedItemModel.fromJson(Map<String, dynamic> json) {
    totalRequested = json['total_requested'];
    totalUderProcessing = json['total_under_processing'];
    totalToBeReceived = json['product_tobe_recieved'];
    //
    activeUsers = json['total_active_user'];
    onWarrantyProcess = json['on_warrenty_process'];
    expiredItems = json['total_expired_items'];
    totalUnderWarranty = json['total_under_warrenty'];
    expiredThisMonth = json['expire_this_month'];
  }
}
