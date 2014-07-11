//
//  TTMHomeGrid.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMButtonWithSubTitle.h"
#import "TTMHomeGrid.h"

static NSString* titles[] =
{   @"2",
    @"math",
    @"3",
    @"4",
    @"5",
    @"6",
};

static NSString* imageName[] =
{   @"PS3triangle",
    @"PS3triangle",
    @"PS3triangle",
    @"PS3triangle",
    @"PS3triangle",
    @"PS3triangle",
};
@implementation TTMHomeGrid
/*
 * Overriding the initWithFrame: method for UIView Parent class.
 * Inside the method defining the background color.
 */
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame])
	{
		//The button defaults to Blue with transparent background
		self.backgroundColor = [UIColor clearColor];
		//self.tintColor = [UIColor blueColor];
        UIImage *logoImage = [UIImage imageNamed:@"PS3triangle.png"];
        NSUInteger yPadding = 20.0;
        NSUInteger xPadding = 30;

        for (int i = 0; i < 6; i++) {
            TTMButtonWithSubTitle *tempView = [[TTMButtonWithSubTitle alloc] initWithFrame:CGRectMake(xPadding,yPadding , logoImage.size.width, logoImage.size.height+50)];
            [tempView setTag:i];
            [tempView addButtonWithTitle:titles[i] imageName:@"PS3triangle.png" callBack:^(id sender, NSInteger selectedTag) {
                NSLog(@"Selected %ld", (long)selectedTag);
            }];
            yPadding = (i == 2) ? yPadding + 80: yPadding ;
            xPadding = (i == 2) ? 30 : xPadding + 105 ;

            [self addSubview:tempView];
        }
    }
	
    return self;
}


@end
