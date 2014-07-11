//
//  TTMContactCustomCellForGroup.m
//  TextTimeMachine
//
//  Created by essadmin on 5/26/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMContactCustomCellForGroup.h"

@implementation TTMContactCustomCellForGroup
@synthesize  deviceIdentifier;
@synthesize  name;
@synthesize subTitle;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        TTMMedallionView *imageView = [[TTMMedallionView alloc] init];
        [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
        [imageView.layer setBorderWidth:1.0f];
        [self addSubview:imageView];
        self.connectionImage = imageView;
        //UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(medallionDidTap:)];
        //[self.connectionImage addGestureRecognizer:tapGestureRecognizer];
        //adding title lable
        UILabel *cellTitleLbl = [[UILabel alloc]init];
        [cellTitleLbl setTextColor:[UIColor colorWithRed:55.0/255.0f green:131.0/255.0f blue:200.0/255.0f alpha:1.0f]];
        [cellTitleLbl setFont:[UIFont fontWithName:LotoLight size:10.0f]];
        [cellTitleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:cellTitleLbl];
        self.deviceIdentifier = cellTitleLbl;
        
        UILabel *subtitleLbl = [[UILabel alloc]init];
        
        [subtitleLbl setTextColor:[UIColor whiteColor]];
        [subtitleLbl setFont:[UIFont fontWithName:LotoLight size:15.0f]];
        [subtitleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:subtitleLbl];
        self.name = subtitleLbl;
        subtitleLbl = [[UILabel alloc]init];
        
        [subtitleLbl setTextColor:[UIColor whiteColor]];
        [subtitleLbl setFont:[UIFont fontWithName:LotoLight size:12.0f]];
        [subtitleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:subtitleLbl];
        self.subTitle = subtitleLbl;
        
        UIImageView *onlineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:onlineImageView];
        self.statusSymbol = onlineImageView;
        
        
        onlineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:onlineImageView];
        self.selectedSymbol = onlineImageView;
        
        
    }
    return self;
}
#pragma mark - Private

- (void)medallionDidTap:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tap" message:@"Medallion has been tapped." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
-(void)setNeedsLayout {
    
    [super setNeedsLayout];
    [self.name setFrame:CGRectMake(60, 5, self.frame.size.width - 60, 20)];
    [self.subTitle setFrame:CGRectMake(60, 20, self.frame.size.width - 60, 30)];
    self.connectionImage.image = [UIImage imageNamed:@"iconcell"];
    [self.connectionImage setFrame:CGRectMake(10, 8, 35, 35)];
    [self.statusSymbol setFrame:CGRectMake(self.frame.size.width - 40, self.frame.size.height/2 - 5, 10, 10)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
