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
  static const int Initialization = 0;
  static const int Connected = 1;
  static const int Disconnected = 2;
  static const int CardInserted = 3;
  static const int CardSwiped = 4;
  static const int EMVStarted = 5;
}

class IosErrorType {
  static const int Common = 0;
  static const int CardInsertedWrong = 1;
  static const int ReaderDisconnected = 2;
  static const int ReaderTimeout = 3;
  static const int Submit = 4;
  static const int SubmitCash = 5;
  static const int SubmitPrepaid = 6;
  static const int SubmitCredit = 7;
  static const int SubmitLink = 8;
  static const int Swipe = 9;
  static const int OnlineProcess = 10;
  static const int Reverse = 11;
  static const int ReverseCash = 12;
  static const int ReversePrepaid = 13;
  static const int ReverseCredit = 14;
  static const int ScheduleSteps = 15;
  static const int EMVError = 16;
  static const int EMVTerminated = 17;
  static const int EMVDeclined = 18;
  static const int EMVCancel = 19;
  static const int EMVCardError = 20;
  static const int EMVCardBlocked = 21;
  static const int EMVDeviceError = 22;
  static const int EMVCardNotSupported = 23;
  static const int EMVZeroTRA = 24;
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
  static const int Initialization = 0;
  static const int Connected = 1;
  static const int Disconnected = 2;
  static const int CardSwiped = 3;
  static const int EMVStarted = 4;

  static fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidReaderEventType.InitSuccessfully:
        return Initialization;
        break;
      case AndroidReaderEventType.Connected:
        return Connected;
        break;
      case AndroidReaderEventType.Disconnected:
        return Disconnected;
        break;
      case AndroidReaderEventType.SwipeCard:
        return CardSwiped;
        break;
      case AndroidReaderEventType.NfcTransactionStarted:
      case AndroidReaderEventType.EmvTransactionStarted:
        return EMVStarted;
        break;
      default:
        return Unknown;
        break;
    }
  }

  static fromIosType(int iosType) {
    switch (iosType) {
      case IosReaderEventType.Initialization:
        return Initialization;
        break;
      case IosReaderEventType.Connected:
        return Connected;
        break;
      case IosReaderEventType.Disconnected:
        return Disconnected;
        break;
      case IosReaderEventType.CardSwiped:
        return CardSwiped;
        break;
      case IosReaderEventType.EMVStarted:
        return EMVStarted;
        break;
      default:
        return Unknown;
        break;
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

  static fromAndroidType(int androidType) {
    switch (androidType) {
      case AndroidErrorType.ConnectionError:
        return ConnectionError;
        break;
      case AndroidErrorType.ServerError:
        return ServerError;
        break;
      case AndroidErrorType.EMVError:
        return EMVError;
        break;
      case AndroidErrorType.EMVTerminated:
        return EMVTerminated;
        break;
      case AndroidErrorType.EMVDeclined:
        return EMVDeclined;
        break;
      case AndroidErrorType.EMVCancel:
        return EMVCancel;
        break;
      case AndroidErrorType.EMVCardError:
        return EMVCardError;
        break;
      case AndroidErrorType.EMVCardBlocked:
        return EMVCardBlocked;
        break;
      case AndroidErrorType.EMVDeviceError:
        return EMVDeviceError;
        break;
      case AndroidErrorType.EMVCardNotSupported:
        return EMVCardNotSupported;
        break;
      case AndroidErrorType.EMVZeroTRA:
        return EMVZeroTRA;
        break;
      default:
        return Unknown;
        break;
    }
  }

  static fromIosType(int iosType) {
    switch (iosType) {
      case IosErrorType.Submit:
        return ConnectionError;
        break;
      case IosErrorType.OnlineProcess:
        return ServerError;
        break;
      case IosErrorType.EMVError:
        return EMVError;
        break;
      case IosErrorType.EMVTerminated:
        return EMVTerminated;
        break;
      case IosErrorType.EMVDeclined:
        return EMVDeclined;
        break;
      case IosErrorType.EMVCancel:
        return EMVCancel;
        break;
      case IosErrorType.EMVCardError:
        return EMVCardError;
        break;
      case IosErrorType.EMVCardBlocked:
        return EMVCardBlocked;
        break;
      case IosErrorType.EMVDeviceError:
        return EMVDeviceError;
        break;
      case IosErrorType.EMVCardNotSupported:
        return EMVCardNotSupported;
        break;
      case IosErrorType.EMVZeroTRA:
        return EMVZeroTRA;
        break;
      default:
        return Unknown;
        break;
    }
  }
}
