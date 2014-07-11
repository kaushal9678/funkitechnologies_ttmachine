//
//  TTMChatCellTableViewCell.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 01/05/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMChatCellTableViewCell.h"

@implementation TTMChatCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *mediaView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:mediaView];
        self.mediaContainerCell = mediaView;
    }
    return self;
}

-(void)setNeedsLayout {
    [super setNeedsLayout];
    //[self.mediaContainerCell setFrame:CGRectMake(0,3,ScreenWidth,100)];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
