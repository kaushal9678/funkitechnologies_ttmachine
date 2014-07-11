//
//  TTMButtonWithSubTitle.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GridButtonAction)(id sender, NSInteger selectedTag);
@interface TTMButtonWithSubTitle : UIView

@property (nonatomic, strong) GridButtonAction buttonAction;
@property (nonatomic, strong) UILabel *selctedLabel;

-(void)addButtonWithTitle:(NSString *)title imageName:(NSString *)image callBack:(GridButtonAction)callback;

@end
