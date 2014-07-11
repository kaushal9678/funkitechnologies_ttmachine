//
//  TTMDelayTimeView.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//
#import "MessageSetting.h"
#import "TTMTimePicker.h"
#import "RadioButton.h"
#import "TTMSingleTon.h"
#import "TTMMessageSettings.h"
#import "TTMDelayTimeView.h"
#import "TTMDateTimePicker.h"


@implementation TTMDelayTimeView
@synthesize  timeDelay = _timeDelay;
@synthesize isDurationSelected = _isDurationSelected;
@synthesize isSpecificSelected = _isSpecificSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self headerLabel:@"Delay Time" frame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self headerLabel:@"Contact Status" frame:CGRectMake(0, 33, self.frame.size.width/2 - 1, 30)];

        [self headerLabel:@"Message Delay" frame:CGRectMake(self.frame.size.width/2 + 1, 33, self.frame.size.width/2, 30)];
        
        [self headerLabel:@"Delayed duration" frame:CGRectMake(self.frame.size.width/2 - 80, 70, self.frame.size.width/2, 30)];
        
        [self headerLabel:@"Deliver at specific time" frame:CGRectMake(self.frame.size.width/2 - 100, 180, self.frame.size.width/2 + 30, 30)];
        
        [self addDoneButtonOnView];
        
        [self createRadioButton];
        
        [self addClearButtonOnView];
        
        [self addSeletedTimeButtonOnView];
        
        [self addSeletedDateTimeButtonOnView];
    }
    return self;
}

-(TTMTimeDelayInfo *)timeDelay {
    if(!_timeDelay) {
        _timeDelay = [[TTMTimeDelayInfo alloc] init];
    }
    return _timeDelay;
}

-(void)createRadioButton {
    
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    if([dataArray count] > 0) {
        MessageSetting *delayInfo = [dataArray objectAtIndex:0];
        [self.timeDelay setIsSpecificTimeEnabled:[delayInfo.isSpecific boolValue]];
        [self.timeDelay setIsdurationEnabled:[delayInfo.isDuration boolValue]];
        self.isSpecificSelected = [delayInfo.isSpecific boolValue];
        self.isDurationSelected = [delayInfo.isDuration boolValue];
    }
    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:2];
	CGRect btnRect = CGRectMake(self.frame.size.width - 105, 120, 100, 30);
    int index = 0;
	for (NSString* optionTitle in @[@"Enable ", @"Enable"]) {
		RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        __weak typeof(btn) weakSelf = btn;

		[btn setAction:kUIButtonBlockTouchUpInside withBlock:^{
            // Lets handle ValueChanged event only for selected button, and ignore for deselected
            if([[weakSelf titleLabel].text isEqualToString:@"Enable "]) {
                self.isSpecificSelected = NO;
                self.isDurationSelected = YES;
                
            }else {
               
                self.isSpecificSelected = YES;
                self.isDurationSelected = NO;
            }
        }];
		btnRect.origin.y += 100;
        btn.tag = 2349 + index;
        index = index + 1;
		[btn setTitle:optionTitle forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		[btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
		[btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
		btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
		[self addSubview:btn];
		[buttons addObject:btn];
        [btn deselectAllButtons];
	}
	
	[buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    if(self.timeDelay.isdurationEnabled) {
        [buttons[0] setSelected:YES];
    }else if(self.timeDelay.isSpecificTimeEnabled) {
        [buttons[1] setSelected:YES];

    }
//
//	[buttons[0] setSelected:NO]; // Making the first button initially selected
//    [buttons[1] setSelected:NO]; // Making the first button initially selected

}


-(void)headerLabel:(NSString *)textString frame:(CGRect)position {
    UILabel *lbl1 = [[UILabel alloc] init];
    /*important--------- */lbl1.textColor = [UIColor blackColor];
    [lbl1 setFrame:position];
    lbl1.backgroundColor=[UIColor blackColor];
    lbl1.textColor=[UIColor whiteColor];
    lbl1.userInteractionEnabled=NO;
    [lbl1 setTextAlignment:NSTextAlignmentCenter];
    lbl1.text= textString;
    [self addSubview:lbl1];
}

-(IBAction)clearButtonPressed:(id)sender {
    
    [self.timeDelay setIsSpecificTimeEnabled:NO];
    [self.timeDelay setIsdurationEnabled:NO];
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    BOOL isInfoSaved = [dataBaseManager addMessageSettingInformation:self.timeDelay];
    NSLog(@"isInfoSaved isInfoSaved %d", isInfoSaved);
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStatus" object:nil];

}

-(IBAction)doneButtonPressed:(id)sender {
    
    [self.timeDelay setIsSpecificTimeEnabled:self.isSpecificSelected];
    [self.timeDelay setIsdurationEnabled:self.isDurationSelected];
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    BOOL isInfoSaved = [dataBaseManager addMessageSettingInformation:self.timeDelay];
    NSLog(@"isInfoSaved isInfoSaved %d", isInfoSaved);
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStatus" object:nil];
}

-(IBAction)timeSelectedButtonPressed:(id)sender {
    
    TTMTimePicker *timePicker = [[TTMTimePicker alloc] initWithFrame:CGRectMake(0, 100, 300, 237)];
    [self addSubview:timePicker];
    [timePicker callingMethodForGetResponseOfTimeSelected:^(TTMTimeDelayInfo *timeInfo) {
        self.timeDelay = timeInfo;
        UIButton *timeButton = (UIButton *)[self viewWithTag:1232];
        [timeButton setTitle:[NSString stringWithFormat:@"%@ : %@", [NSString stringWithFormat:@"%@",timeInfo.hours], [NSString stringWithFormat:@"%@",timeInfo.minutes]] forState:UIControlStateNormal];
    }];
    [timePicker setBackgroundColor:[UIColor darkGrayColor]];
    
}
-(void)addSeletedTimeButtonOnView {
    
    TTMDataBaseManager *dataBaseManager = [TTMDataBaseManager sharedMySingleton];
    [dataBaseManager initializeTheCoreDataModelClasses];
    NSMutableArray *dataArray = [dataBaseManager fetchDataFromCoreDataOnMessageSettingInfo];
    MessageSetting *delayInfo = nil;
    if([dataArray count] > 0) {
        delayInfo = [dataArray objectAtIndex:0];
        [self.timeDelay setHours:(delayInfo.hours) ? delayInfo.hours : @"00"];
        [self.timeDelay setMinutes:(delayInfo.minutes) ? delayInfo.minutes : @"01"];

    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(timeSelectedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@"%@ : %@", (delayInfo.hours.length) ? delayInfo.hours : @"00", (delayInfo.minutes.length) ? delayInfo.minutes : @"01"] forState:UIControlStateNormal];
    [button setTag:1232];
    button.frame = CGRectMake(100, 115, 60, 40.0);
    [self addSubview:button];
}

-(void)addSeletedDateTimeButtonOnView {
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button addTarget:self action:@selector(timeSelectedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:[NSString stringWithFormat:@"%@ : %@", (delayInfo.hours) ? delayInfo.hours : @"00", (delayInfo.minutes) ? delayInfo.minutes : @"01"] forState:UIControlStateNormal];
//    [button setTag:1233];
//    button.frame = CGRectMake(100, 200, 60, 40.0);
//    [self addSubview:button];
}

-(void)addDoneButtonOnView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.frame.size.width/2 + 30, self.frame.size.height - 50, 60, 40.0);
    [self addSubview:button];
}

-(void)addClearButtonOnView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Clear" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.frame.size.width/2 - 90, self.frame.size.height - 50, 60, 40.0);
    [self addSubview:button];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    UIBezierPath *vertLine = [[UIBezierPath alloc] init];
    [vertLine moveToPoint:CGPointMake(10, 35)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 35)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 65)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 65)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 85)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 85)];
    vertLine.lineWidth = 1.0;
    [[UIColor whiteColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(rect.size.width/2, 35)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width/2, 65)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 175)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 175)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 195)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 195)];
    vertLine.lineWidth = 1.0;
    [[UIColor whiteColor] setStroke];
    [vertLine stroke];
    
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 280)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 280)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
    vertLine = [UIBezierPath bezierPath];
    [vertLine moveToPoint:CGPointMake(10, 65)];
    [vertLine addLineToPoint:CGPointMake(rect.size.width - 20, 65)];
    vertLine.lineWidth = 1.0;
    [[UIColor greenColor] setStroke];
    [vertLine stroke];
}


@end
