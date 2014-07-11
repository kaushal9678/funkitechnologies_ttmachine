//
//  TTMChatCustonCell.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/14/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMLine.h"
#import "TTMChatCustonCell.h"

@implementation TTMChatCustonCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView;
/*
 @UIView Life cycle method for memory cleanup
 */
- (void)dealloc {

	senderAndTimeLabel = nil;
    messageContentView = nil;
    bgImageView = nil;
}
/*
 @UITableViewCell Life cycle method
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 20)];
		senderAndTimeLabel.textAlignment = NSTextAlignmentLeft;
		senderAndTimeLabel.font = [UIFont systemFontOfSize:5.0f];
		senderAndTimeLabel.textColor = [TTMCommon colorFromHexString:@"#4f819c"];
		[self.contentView addSubview:senderAndTimeLabel];
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:bgImageView];
		
		messageContentView = [[UITextView alloc] init];
		messageContentView.backgroundColor = [UIColor redColor];
		messageContentView.editable = NO;
		messageContentView.scrollEnabled = NO;
		[messageContentView sizeToFit];
        messageContentView.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0f];
		[self.contentView addSubview:messageContentView];
        self.straightLine = [[TTMLine alloc] initWithFrame:CGRectZero];
        [self.straightLine setBackgroundColor:[UIColor clearColor]];

        [self addSubview:self.straightLine];
        self.upwordLine = [[TTMLine alloc] initWithFrame:CGRectZero];
        [self.upwordLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.upwordLine];
        
        self.senderLine = [[TTMUpword alloc] initWithFrame:CGRectZero];
        [self.senderLine setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.senderLine];
    
        self.myArrow = [[TTMArrow alloc] initWithFrame:CGRectMake(self.frame.size.width - 81, self.frame.size.height - 33, 20, 20)];
        self.myArrow.transform = CGAffineTransformMakeScale(1, -1);
        [self.myArrow setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.myArrow];
        [self.myArrow setNeedsDisplay];
        self.senderArrow = [[TTMArrow alloc] initWithFrame:CGRectMake(self.frame.size.width/2 -113, self.frame.size.height - 20,20, 20)];
        self.senderArrow.transform = CGAffineTransformMakeScale(-1, 1);
        
        [self.senderArrow setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.senderArrow];
        [self.senderArrow setNeedsDisplay];
    }
    return self;
}

-(void)setNeedsLayout {
    
    [super setNeedsLayout];
    
    switch (self.senderType) {
        case TTMTo: {
            [self.straightLine setFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width - 80, 2)];
            //[self.upwordLine setFrame:CGRectMake(self.frame.size.width - 81, self.frame.size.height - 33, 20, 20)];
            self.senderAndTimeLabel.frame = CGRectMake(self.frame.size.width - 72, self.frame.size.height - 25 , 300, 20);
            [self.messageContentView setTextAlignment:NSTextAlignmentLeft];
            self.myArrow.frame = CGRectMake(self.frame.size.width - 81, self.frame.size.height - 33, 20, 20);
            [self.myArrow setSenderType:TTMTo];
            [self.straightLine setSenderType:TTMTo];
            [self.senderArrow setHidden:YES];
            [self.myArrow setHidden:NO];
            [self.straightLine setBackgroundColor:ChatLineSenderColor];
            [self.myArrow setNeedsDisplay];
        }
            break;
        case TTMFrom: {
            [self.straightLine setFrame:CGRectMake(self.frame.size.width/2 -95, self.frame.size.height - 20, 250, 2)];
           // [self.upwordLine setFrame:CGRectMake(self.frame.size.width/2 -113, self.frame.size.height - 20,20, 20)];
            self.senderAndTimeLabel.frame = CGRectMake(2, self.frame.size.height - 29, 300, 20);
            [self.messageContentView setTextAlignment:NSTextAlignmentRight];
            self.senderArrow.frame = CGRectMake(self.frame.size.width/2 -113, self.frame.size.height - 20,20, 20);
            [self.senderArrow setHidden:NO];
            [self.senderArrow setSenderType:TTMFrom];
            [self.straightLine setSenderType:TTMFrom];
            [self.myArrow setHidden:YES];
            [self.straightLine setBackgroundColor:ChatLineRecieverColor];
            [self.senderArrow setNeedsDisplay];

        }
            break;
        default:
            break;
    }
}
@end
