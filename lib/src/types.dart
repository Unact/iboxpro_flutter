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

class CurrencyType {
  static const int RUB = 0;
  static const int VND = 1;
}

class ReaderType {
  static const int C15 = 0;
  static const int P15 = 1;
  static const int P17 = 2;
}

class ReaderEventType {
  static const int Initialization = 0;
  static const int Connected = 1;
  static const int Disconnected = 2;
  static const int CardInserted = 3;
  static const int CardSwiped = 4;
  static const int EMVStarted = 5;
}

class ErrorType {
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
