//
//  TTMActivityIndicator.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 13/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMActivityIndicator.h"

@implementation TTMActivityIndicator

static TTMActivityIndicator * _sharedMySingleton = nil;

+(TTMActivityIndicator*)sharedMySingleton
{
    @synchronized([TTMActivityIndicator class])
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[self alloc] init];
        }
        return _sharedMySingleton;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)addIndicator:(UIView *)view {
    
    self.ind = [[DDIndicator alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - 20, view.frame.size.height/2 - 20, 40, 40)];
    [view addSubview:self.ind];
    [self.ind startAnimating];
    
}
-(void)removeIndicator:(UIView *)view {
    
    [self.ind stopAnimating];
    [self.ind removeFromSuperview];
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
