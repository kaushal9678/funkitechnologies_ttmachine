//
//  TTMTimePicker.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 6/7/14.
//  Copyright (c) 2014 Komal Verma. All rights reserved.
//

#import "TTMTimePicker.h"

@implementation TTMTimePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSDate *date = [NSDate date];
        
        // Get Current Year
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        // Get Current  Hour
        [formatter setDateFormat:@"hh"];
        NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        // Get Current  Minutes
        [formatter setDateFormat:@"mm"];
        NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        // PickerView -  Hours data
        
        
        hoursArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        
        
        // PickerView -  Hours data
        
        minutesArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < 60; i++)
        {
            
            [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
            
        }
        self.customPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        self.customPicker.showsSelectionIndicator = YES;
        [self addSubview:self.customPicker];
        // PickerView - Default Selection as per current Date
        
        [self.customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:0 animated:YES];
        
        [self.customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:1 animated:YES];
        [self addDoneButtonOnView];
        [self addCancelButtonOnView];

    }
    return self;
}
#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        [self.customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        [self.customPicker reloadAllComponents];
    }
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor whiteColor];
        
    }
    if (component == 0)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row];  // Month
    }
    return pickerLabel;
    
}
-(void)addCancelButtonOnView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, self.frame.size.width - 130, 60, 30);
    [self addSubview:button];
}
-(void)addDoneButtonOnView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(actionDone:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(180, self.frame.size.width - 130, 60, 30);
    [self addSubview:button];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [hoursArray count];
        
    }
    else if (component == 1)
    {
        return [minutesArray count];
    }
    return 2;
}

- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         [self removeFromSuperview];

                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

-(void)callingMethodForGetResponseOfTimeSelected:(TimeSelcted)timeBlock {
    self.timeBlock = timeBlock;
}

- (IBAction)actionDone:(id)sender
{
    TTMTimeDelayInfo *timeInfo = [[TTMTimeDelayInfo alloc] init];
    [timeInfo setHours:[NSString stringWithFormat:@"%@", [hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:0]]]];
    [timeInfo setMinutes:[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:1]]];
    self.timeBlock(timeInfo);
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         [self removeFromSuperview];
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
