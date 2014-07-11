//
//  TTMLogo.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/9/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMLogo.h"

@implementation TTMLogo
/*
 * Overriding the initWithFrame: method for UIView Parent class.
 * Inside the method defining the background color.
 */
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame])
	{
		//The button defaults to Blue with transparent background
		self.backgroundColor = [UIColor clearColor];
        [self setImage:[UIImage imageNamed:@"logo"]];
		//self.tintColor = [UIColor blueColor];
    }
	
    return self;
}


@end
