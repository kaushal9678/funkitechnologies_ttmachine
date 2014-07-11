//
//  TTMUpword.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 25/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMUpword.h"

@implementation TTMUpword
@synthesize senderType = _senderType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, (self.senderType == TTMTo) ? [UIColor redColor].CGColor : [UIColor greenColor].CGColor);
    CGPathMoveToPoint(path, NULL,0, 0);
    CGPathAddLineToPoint(path, NULL,0,rect.size.height);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
