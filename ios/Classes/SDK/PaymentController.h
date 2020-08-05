#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PaymentContext.h"
#import "RecurrentPaymentContext.h"
#import "ReversePaymentContext.h"
#import "TransactionData.h"
#import "Purchase.h"
#import "Tag.h"
#import "BTDevice.h"
#import "APIResult.h"
#import "APIHistoryResult.h"
#import "APIAuthenticationResult.h"
#import "APIFiscalInfoResult.h"
#import "APIFiscalizeResult.h"
#import "APIPrepareResult.h"

typedef enum
{
    PaymentControllerReaderType_C15,
    PaymentControllerReaderType_P15,
    PaymentControllerReaderType_P17,
} PaymentControllerReaderType;

typedef enum
{
    PaymentControllerErrorType_COMMON,
    PaymentControllerErrorType_ZERO_AMOUNT,
    PaymentControllerErrorType_CARD_INSERTED_WRONG,
    PaymentControllerErrorType_READER_DISCONNECTED,
    PaymentControllerErrorType_READER_TIMEOUT,
    PaymentControllerErrorType_SUBMIT,
    PaymentControllerErrorType_SUBMIT_CASH,
    PaymentControllerErrorType_SUBMIT_PREPAID,
    PaymentControllerErrorType_SUBMIT_CREDIT,
    PaymentControllerErrorType_SUBMIT_OUTER_CARD,
    PaymentControllerErrorType_SUBMIT_LINK,
    PaymentControllerErrorType_SWIPE,
    PaymentControllerErrorType_ONLINE_PROCESS,
    PaymentControllerErrorType_REVERSE,
    PaymentControllerErrorType_REVERSE_CASH,
    PaymentControllerErrorType_REVERSE_PREPAID,
    PaymentControllerErrorType_REVERSE_CREDIT,
    PaymentControllerErrorType_REVERSE_OUTER_CARD,
    PaymentControllerErrorType_REVERSE_LINK,
    PaymentControllerErrorType_REVERSE_CNP,
    PaymentControllerErrorType_REVERSE_AUTO,
    PaymentControllerErrorType_SCHEDULE_STEPS,
    PaymentControllerErrorType_EMV_ERROR,
    PaymentControllerErrorType_EMV_TERMINATED,
    PaymentControllerErrorType_EMV_DECLINED,
    PaymentControllerErrorType_EMV_CANCEL,
    PaymentControllerErrorType_EMV_CARD_ERROR,
    PaymentControllerErrorType_EMV_CARD_BLOCKED,
    PaymentControllerErrorType_EMV_DEVICE_ERROR,
    PaymentControllerErrorType_EMV_CARD_NOT_SUPPORTED
} PaymentControllerErrorType;

typedef enum
{
    PaymentControllerReaderEventType_INITIALIZED,
    PaymentControllerReaderEventType_CONNECTED,
    PaymentControllerReaderEventType_DISCONNECTED,
    PaymentControllerReaderEventType_CARD_INSERTED,
    PaymentControllerReaderEventType_CARD_SWIPED,
    PaymentControllerReaderEventType_EMV_STARTED
} PaymentControllerReaderEventType;

@protocol PaymentControllerDelegate<NSObject>
-(void)PaymentControllerStartTransaction:(NSString *)transactionID;
-(void)PaymentControllerDone:(TransactionData *)transactionData;
-(void)PaymentControllerError:(PaymentControllerErrorType)error Message:(NSString *)message;
-(void)PaymentControllerReaderEvent:(PaymentControllerReaderEventType)event;
-(void)PaymentControllerRequestCardApplication:(NSArray *)applications;
-(void)PaymentControllerRequestBTDevice:(NSArray *)devices;
-(void)PaymentControllerScheduleStepsStart;
-(void)PaymentControllerScheduleStepsCreated:(NSArray *)scheduleSteps;
@end

@interface PaymentController : NSObject

+(PaymentController *)instance;
+(void)destroy;

-(NSString *)version;
-(NSArray *)supportedReaders;
-(NSDictionary *)readerInfo;
-(void)setPaymentContext:(PaymentContext *)paymentContext;
-(void)setClientProductCode:(NSString *)clientProductCode;
-(void)setDelegate:(id<PaymentControllerDelegate>)delegate;
-(BOOL)isReaderConnected;
-(void)setCardApplication:(int)application;
-(void)saveBTDevice:(BTDevice *)device;
-(void)setBTDevice:(BTDevice *)device;
-(void)enable;
-(void)disable;
-(void)retry;
-(void)scheduleStepsConfirm;
-(void)pingReaderWithDoneAction:(void (^)(NSDictionary *))doneAction;
-(void)setSingleStepAuthentication:(BOOL)singleStepAuthentication;

-(APIAuthenticationResult *)authentication;
-(APIHistoryResult *)historyWithPage:(int)page;
-(APIHistoryResult *)historyWithTransactionID:(NSString *)transactionID;
-(APIFiscalInfoResult *)fiscalInfoWithTrId:(NSString *)trId;
-(APIFiscalizeResult *)fiscalizeWithTrId:(NSString *)trId;
-(APIPrepareResult *)prepareWithProductCode:(NSString *)productCode PrepareData:(NSDictionary *)prepareData;
-(APIResult *)adjustWithTrId:(NSString *)trId Signature:(NSData *)signature ReceiptEmail:(NSString *)receiptEmail ReceiptPhone:(NSString *)receiptPhone;
-(APIResult *)adjustWithScheduleId:(NSString *)scheduleId Signature:(NSData *)signature ReceiptEmail:(NSString *)receiptEmail ReceiptPhone:(NSString *)receiptPhone;
-(APIResult *)reverseAdjustWithTrId:(NSString *)trId Signature:(NSData *)signature ReceiptEmail:(NSString *)receiptEmail ReceiptPhone:(NSString *)receiptPhone;
-(APIResult *)paymentStatusWithTrId:(NSString *)trId;
-(void)paymentStatusWithTrId:(NSString *)trId DoneAction:(void (^)(APIResult *result))action;
-(void)setEmail:(NSString *)email Password:(NSString *)password;
-(void)search4BTReadersWithType:(PaymentControllerReaderType)readerType;
-(void)stopSearch4BTReaders;
-(void)setReaderType:(PaymentControllerReaderType)readerType;
-(void)setRequestTimeout:(int)timeout;

@end
