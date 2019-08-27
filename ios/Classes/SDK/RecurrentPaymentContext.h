//
//  RecurrentPaymentContext.h
//  ibox.pro.sdk.external
//
//  Created by Axon on 5/12/15.
//  Copyright (c) 2015 ibox. All rights reserved.
//

#import "PaymentContext.h"

typedef enum
{
    ScheduleType_DelayedOnce = 0,
    ScheduleType_Weekly = 1,
    ScheduleType_Monthly = 2,
    ScheduleType_Quarterly = 3,
    ScheduleType_Annual = 4,
    ScheduleType_ArbitraryDates = 5
} ScheduleType;

typedef enum
{
    ScheduleEndType_Date = 1,
    ScheduleEndType_Count = 2
} ScheduleEndType;

@interface RecurrentPaymentContext : PaymentContext

@property (nonatomic) ScheduleType Type;
@property (nonatomic) ScheduleEndType EndType;
@property (nonatomic, retain) NSString *StartDate;
@property (nonatomic, retain) NSString *EndDate;
@property (nonatomic, retain) NSArray *Dates;
@property (nonatomic) int EndCount;
@property (nonatomic) int Month;
@property (nonatomic) int Day;
@property (nonatomic) int Hour;
@property (nonatomic) int Minute;

@end
