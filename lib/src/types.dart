class InputType {
  static const int manual = 1;
  static const int swipe = 2;
  static const int emv = 3;
  static const int nfc = 4;
  static const int prepaid = 8;
  static const int credit = 9;
  static const int cash = 10;
  static const int link = 30;
}

class IosReaderEventType {
  static const int initialized = 0;
  static const int connected = 1;
  static const int disconnected = 2;
  static const int cardInserted = 3;
  static const int cardSwiped = 4;
  static const int emvStarted = 5;
}

class IosErrorType {
  static const int common = 0;
  static const int zeroAmount = 1;
  static const int cardInsertedWrong = 2;
  static const int readerDisconnected = 3;
  static const int readerTimeout = 4;
  static const int submit = 5;
  static const int submitCash = 6;
  static const int submitPrepaid = 7;
  static const int submitCredit = 8;
  static const int submitOuterCard = 9;
  static const int submitLink = 10;
  static const int swipe = 11;
  static const int onlineProcess = 12;
  static const int reverse = 13;
  static const int reverseCash = 14;
  static const int reversePrepaid = 15;
  static const int reverseCredit = 16;
  static const int reverseOuterCard = 17;
  static const int reverseLink = 18;
  static const int reverseCNP = 19;
  static const int reverseCAuto = 20;
  static const int scheduleSteps = 21;
  static const int emvError = 22;
  static const int emvTerminated = 23;
  static const int emvDeclined = 24;
  static const int emvCancel = 25;
  static const int emvCardError = 26;
  static const int emvCardBlocked = 27;
  static const int emvDeviceError = 28;
  static const int emvCardNotSupported = 29;
}

class AndroidReaderEventType {
  static const int connected = 0;
  static const int disconnected = 1;
  static const int startInit = 2;
  static const int initSuccessfully = 3;
  static const int initFailed = 4;
  static const int ejectCardTimeout = 5;
  static const int swipeCard = 6;
  static const int emvTransactionStarted = 7;
  static const int nfcTransactionStarted = 8;
  static const int waitingForCard = 9;
  static const int paymentCanceled = 10;
  static const int ejectCard = 11;
  static const int badSwipe = 12;
  static const int lowBattery = 13;
  static const int cardTimeout = 14;
  static const int pinTimeout = 15;
}

class AndroidErrorType {
  static const int connectionError = 0;
  static const int serverError = 1;
  static const int transactionNullOrEmpty = 2;
  static const int ttkFailed = 3;
  static const int extAppFailed = 4;
  static const int noSuchTransaction = 5;
  static const int invalidInputType = 6;
  static const int invalidAmount = 7;
  static const int emvError = 8;
  static const int emvTerminated = 9;
  static const int emvDeclined = 10;
  static const int emvCancel = 11;
  static const int emvCardError = 12;
  static const int emvCardBlocked = 13;
  static const int emvDeviceError = 14;
  static const int emvCardNotSupported = 15;
  static const int emvZeroTRA = 16;
  static const int emvNotAllowed = 17;
  static const int nfcNotAllowed = 18;
  static const int nfcLimitExceeded = 19;
  static const int swipeNotAllowed = 20;
}

class ReaderEventType {
  static const int unknown = -1;
  static const int initialized = 0;
  static const int connected = 1;
  static const int disconnected = 2;
  static const int cardSwiped = 3;
  static const int emvStarted = 4;

  static int fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidReaderEventType.initSuccessfully:
        return initialized;
      case AndroidReaderEventType.connected:
        return connected;
      case AndroidReaderEventType.initFailed:
      case AndroidReaderEventType.paymentCanceled:
      case AndroidReaderEventType.disconnected:
        return disconnected;
      case AndroidReaderEventType.swipeCard:
        return cardSwiped;
      case AndroidReaderEventType.nfcTransactionStarted:
      case AndroidReaderEventType.emvTransactionStarted:
        return emvStarted;
      default:
        return unknown;
    }
  }

  static int fromIosType(int iosType) {
    switch (iosType) {
      case IosReaderEventType.initialized:
        return initialized;
      case IosReaderEventType.connected:
        return connected;
      case IosReaderEventType.disconnected:
        return disconnected;
      case IosReaderEventType.cardSwiped:
        return cardSwiped;
      case IosReaderEventType.emvStarted:
        return emvStarted;
      default:
        return unknown;
    }
  }
}

class ErrorType {
  static const int unknown = -1;
  static const int connectionError = 0;
  static const int serverError = 1;
  static const int emvError = 2;
  static const int emvTerminated = 3;
  static const int emvDeclined = 4;
  static const int emvCancel = 5;
  static const int emvCardError = 6;
  static const int emvCardBlocked = 7;
  static const int emvDeviceError = 8;
  static const int emvCardNotSupported = 9;
  static const int emvZeroTRA = 10;

  static int fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidErrorType.connectionError:
        return connectionError;
      case AndroidErrorType.serverError:
        return serverError;
      case AndroidErrorType.emvError:
        return emvError;
      case AndroidErrorType.emvTerminated:
        return emvTerminated;
      case AndroidErrorType.emvDeclined:
        return emvDeclined;
      case AndroidErrorType.emvCancel:
        return emvCancel;
      case AndroidErrorType.emvCardError:
        return emvCardError;
      case AndroidErrorType.emvCardBlocked:
        return emvCardBlocked;
      case AndroidErrorType.emvDeviceError:
        return emvDeviceError;
      case AndroidErrorType.emvCardNotSupported:
        return emvCardNotSupported;
      case AndroidErrorType.emvZeroTRA:
        return emvZeroTRA;
      default:
        return unknown;
    }
  }

  static int fromIosType(int iosType) {
    switch (iosType) {
      case IosErrorType.submit:
        return connectionError;
      case IosErrorType.onlineProcess:
        return serverError;
      case IosErrorType.emvError:
        return emvError;
      case IosErrorType.emvTerminated:
        return emvTerminated;
      case IosErrorType.emvDeclined:
        return emvDeclined;
      case IosErrorType.emvCancel:
        return emvCancel;
      case IosErrorType.emvCardError:
        return emvCardError;
      case IosErrorType.emvCardBlocked:
        return emvCardBlocked;
      case IosErrorType.emvDeviceError:
        return emvDeviceError;
      case IosErrorType.emvCardNotSupported:
        return emvCardNotSupported;
      case IosErrorType.zeroAmount:
        return emvZeroTRA;
      default:
        return unknown;
    }
  }
}
