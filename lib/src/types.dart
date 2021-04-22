class InputType {
  static const int Manual = 1;
  static const int Swipe = 2;
  static const int EMV = 3;
  static const int NFC = 4;
  static const int Prepaid = 8;
  static const int Credit = 9;
  static const int Cash = 10;
  static const int Link = 30;
}

class IosReaderEventType {
  static const int Initialized = 0;
  static const int Connected = 1;
  static const int Disconnected = 2;
  static const int CardInserted = 3;
  static const int CardSwiped = 4;
  static const int EMVStarted = 5;
}

class IosErrorType {
  static const int Common = 0;
  static const int ZeroAmount = 1;
  static const int CardInsertedWrong = 2;
  static const int ReaderDisconnected = 3;
  static const int ReaderTimeout = 4;
  static const int Submit = 5;
  static const int SubmitCash = 6;
  static const int SubmitPrepaid = 7;
  static const int SubmitCredit = 8;
  static const int SubmitOuterCard = 9;
  static const int SubmitLink = 10;
  static const int Swipe = 11;
  static const int OnlineProcess = 12;
  static const int Reverse = 13;
  static const int ReverseCash = 14;
  static const int ReversePrepaid = 15;
  static const int ReverseCredit = 16;
  static const int ReverseOuterCard = 17;
  static const int ReverseLink = 18;
  static const int ReverseCNP = 19;
  static const int ReverseCAuto = 20;
  static const int ScheduleSteps = 21;
  static const int EMVError = 22;
  static const int EMVTerminated = 23;
  static const int EMVDeclined = 24;
  static const int EMVCancel = 25;
  static const int EMVCardError = 26;
  static const int EMVCardBlocked = 27;
  static const int EMVDeviceError = 28;
  static const int EMVCardNotSupported = 29;
}

class AndroidReaderEventType {
  static const int Connected = 0;
  static const int Disconnected = 1;
  static const int StartInit = 2;
  static const int InitSuccessfully = 3;
  static const int InitFailed = 4;
  static const int EjectCardTimeout = 5;
  static const int SwipeCard = 6;
  static const int EmvTransactionStarted = 7;
  static const int NfcTransactionStarted = 8;
  static const int WaitingForCard = 9;
  static const int PaymentCanceled = 10;
  static const int EjectCard = 11;
  static const int BadSwipe = 12;
  static const int LowBattery = 13;
  static const int CardTimeout = 14;
  static const int PinTimeout = 15;
}

class AndroidErrorType {
  static const int ConnectionError = 0;
  static const int ServerError = 1;
  static const int TransactionNullOrEmpty = 2;
  static const int TtkFailed = 3;
  static const int ExtAppFailed = 4;
  static const int NoSuchTransaction = 5;
  static const int InvalidInputType = 6;
  static const int InvalidAmount = 7;
  static const int EMVError = 8;
  static const int EMVTerminated = 9;
  static const int EMVDeclined = 10;
  static const int EMVCancel = 11;
  static const int EMVCardError = 12;
  static const int EMVCardBlocked = 13;
  static const int EMVDeviceError = 14;
  static const int EMVCardNotSupported = 15;
  static const int EMVZeroTRA = 16;
  static const int EMVNotAllowed = 17;
  static const int NFCNotAllowed = 18;
  static const int NFCLimitExceeded = 19;
  static const int SwipeNotAllowed = 20;
}

class ReaderEventType {
  static const int Unknown = -1;
  static const int Initialized = 0;
  static const int Connected = 1;
  static const int Disconnected = 2;
  static const int CardSwiped = 3;
  static const int EMVStarted = 4;

  static int fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidReaderEventType.InitSuccessfully:
        return Initialized;
      case AndroidReaderEventType.Connected:
        return Connected;
      case AndroidReaderEventType.InitFailed:
      case AndroidReaderEventType.PaymentCanceled:
      case AndroidReaderEventType.Disconnected:
        return Disconnected;
      case AndroidReaderEventType.SwipeCard:
        return CardSwiped;
      case AndroidReaderEventType.NfcTransactionStarted:
      case AndroidReaderEventType.EmvTransactionStarted:
        return EMVStarted;
      default:
        return Unknown;
    }
  }

  static int fromIosType(int iosType) {
    switch (iosType) {
      case IosReaderEventType.Initialized:
        return Initialized;
      case IosReaderEventType.Connected:
        return Connected;
      case IosReaderEventType.Disconnected:
        return Disconnected;
      case IosReaderEventType.CardSwiped:
        return CardSwiped;
      case IosReaderEventType.EMVStarted:
        return EMVStarted;
      default:
        return Unknown;
    }
  }
}

class ErrorType {
  static const int Unknown = -1;
  static const int ConnectionError = 0;
  static const int ServerError = 1;
  static const int EMVError = 2;
  static const int EMVTerminated = 3;
  static const int EMVDeclined = 4;
  static const int EMVCancel = 5;
  static const int EMVCardError = 6;
  static const int EMVCardBlocked = 7;
  static const int EMVDeviceError = 8;
  static const int EMVCardNotSupported = 9;
  static const int EMVZeroTRA = 10;

  static int fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidErrorType.ConnectionError:
        return ConnectionError;
      case AndroidErrorType.ServerError:
        return ServerError;
      case AndroidErrorType.EMVError:
        return EMVError;
      case AndroidErrorType.EMVTerminated:
        return EMVTerminated;
      case AndroidErrorType.EMVDeclined:
        return EMVDeclined;
      case AndroidErrorType.EMVCancel:
        return EMVCancel;
      case AndroidErrorType.EMVCardError:
        return EMVCardError;
      case AndroidErrorType.EMVCardBlocked:
        return EMVCardBlocked;
      case AndroidErrorType.EMVDeviceError:
        return EMVDeviceError;
      case AndroidErrorType.EMVCardNotSupported:
        return EMVCardNotSupported;
      case AndroidErrorType.EMVZeroTRA:
        return EMVZeroTRA;
      default:
        return Unknown;
    }
  }

  static int fromIosType(int iosType) {
    switch (iosType) {
      case IosErrorType.Submit:
        return ConnectionError;
      case IosErrorType.OnlineProcess:
        return ServerError;
      case IosErrorType.EMVError:
        return EMVError;
      case IosErrorType.EMVTerminated:
        return EMVTerminated;
      case IosErrorType.EMVDeclined:
        return EMVDeclined;
      case IosErrorType.EMVCancel:
        return EMVCancel;
      case IosErrorType.EMVCardError:
        return EMVCardError;
      case IosErrorType.EMVCardBlocked:
        return EMVCardBlocked;
      case IosErrorType.EMVDeviceError:
        return EMVDeviceError;
      case IosErrorType.EMVCardNotSupported:
        return EMVCardNotSupported;
      case IosErrorType.ZeroAmount:
        return EMVZeroTRA;
      default:
        return Unknown;
    }
  }
}
