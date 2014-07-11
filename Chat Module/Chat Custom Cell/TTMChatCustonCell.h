//
//  TTMChatCustonCell.h
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMArrow.h"
#import "TTMLine.h"
#import "TTMUpword.h"
#import "TTMEnumClass.h"

@interface TTMChatCustonCell : UITableViewCell {
    UILabel	*senderAndTimeLabel;
    UITextView *messageContentView;
    UIImageView *bgImageView;
    
}
@property (nonatomic, strong) TTMArrow *myArrow;
@property (nonatomic, strong) TTMArrow *senderArrow;

@property (nonatomic, assign) TTMSenderType senderType;
/********
 ** Label is declared for label which will show the time
 ********/
@property (nonatomic,strong) UILabel *senderAndTimeLabel;
/********
 ** UITextView is declared for showing the message
 ********/
@property (nonatomic,strong) UITextView *messageContentView;
/********
 ** UITextView is declared for background view
 ********/
@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic, strong)TTMLine *straightLine;

@property (nonatomic, strong)TTMLine *upwordLine;

@property (nonatomic, strong)TTMUpword *senderLine;


@end

