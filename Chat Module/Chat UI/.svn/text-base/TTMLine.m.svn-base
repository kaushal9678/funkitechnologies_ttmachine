//
//  TTMLine.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//
#import "Macro.h"
#import "TTMLine.h"

@implementation TTMLine

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
    CGContextSetStrokeColorWithColor(context, (self.senderType == TTMTo) ? ChatLineSenderColor.CGColor : ChatLineRecieverColor.CGColor);
    CGPathMoveToPoint(path, NULL,0, rect.size.height);
    CGPathAddLineToPoint(path, NULL,rect.size.width,0);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
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
