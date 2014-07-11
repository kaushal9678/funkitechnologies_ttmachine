//
//  TTMDateTimePicker.h
//  TextTimeMachine
//
//  Created by Komal Kumar on 10/06/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#define currentMonth [currentMonthString integerValue]
typedef void(^TimeDateSelcted)(NSString *timeInfo);

@interface TTMDateTimePicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
}
@property (nonatomic, copy) TimeDateSelcted timeBlock;

@property (strong, nonatomic) UIPickerView *customPicker;

-(void)callingMethodForGetResponseOfTimeSelected:(TimeDateSelcted)timeBlock;

@end
