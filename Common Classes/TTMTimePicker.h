//
//  TTMTimePicker.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMTimeDelayInfo.h"

typedef void(^TimeSelcted)(TTMTimeDelayInfo *timeInfo);

@interface TTMTimePicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *hoursArray;
    NSMutableArray *minutesArray;

}
@property (strong, nonatomic) UIPickerView *customPicker;
@property (nonatomic, copy) TimeSelcted timeBlock;

-(void)callingMethodForGetResponseOfTimeSelected:(TimeSelcted)timeBlock;

@end
