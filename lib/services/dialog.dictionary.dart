enum DialogDictionaryType { EN, FR, RU }

const lag = DialogDictionaryType.EN;

DialogDictionary getCurrentLang() {
  switch (lag) {
    case DialogDictionaryType.FR:
      return DialogDictionaryFr();
    case DialogDictionaryType.RU:
      return DialogDictionaryRu();
    default:
      return DialogDictionary();
  }
}

class DialogDictionary {
  final String confirmProductionSchedule = "Please confirm production schedule";
  final String orderScheduleDone = "Confirm";
  final String yards = "Yards";
  final String savedItems = "Saved Items";
  final String wallet = "Wallet";
  final String settings = "Settings";
  final String about = "About";
  final String logout = "Logout";
  final String home = "Home";
  final String products = "Products";
  final String myOrders = "My Orders";
  final String searchProducts = "Search Products";
  final String chooseDispatchMethod = "Choose dispatch method";
  final String creditToWallet = "Credit";
  final String debitToWallet = "Payment for";
  final String paymentReceived =
      "Your payment was successful and your order is being processed.";

  final String cubicMetresAvailable = "cubic metres available.";

  final String productScheduleNotConfirmed =
      "Production schedule can\’t be confirmed until the quantity requested is complete.";
  final String pickupAdvise =
      "You are advised to arrive at the yard one hour before production commences.";
}

class DialogDictionaryFr extends DialogDictionary {
  final String confirmProductionSchedule = "Please confirm production schedule.";
  final String orderScheduleDone = "Confirm";
  final String yards = "Yards";
  final String savedItems = "Saved Items";
}

class DialogDictionaryRu extends DialogDictionary {
  final String confirmProductionSchedule = "Please confirm production schedule.";
  final String orderScheduleDone = "Confirm";
  final String yards = "Yards";
  final String savedItems = "Saved Items";
}

DialogDictionary get dialogDictionary => getCurrentLang();
