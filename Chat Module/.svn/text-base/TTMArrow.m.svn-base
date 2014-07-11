//
//  TTMArrow.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/29/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "Macro.h"
#import "TTMArrow.h"
#import "UIBezierPath+dqd_arrowhead.h"

@implementation TTMArrow
{
    CGPoint startPoint;
    CGPoint endPoint;
    CGFloat tailWidth;
    CGFloat headWidth;
    CGFloat headLength;
    UIBezierPath *path;
    
}
@synthesize textPath = _textPath;
@synthesize senderType = _senderType;
@synthesize initialeFrame = _initialeFrame;

/*
 @ //UIView with initialization of the initial frame and actual frame
 */
- (id)initWithFrame:(CGRect)frame {
    
    //Calling super life cycle method
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"Frame of arrow %@", NSStringFromCGRect(frame));
        //startPoint = cgpo
        //CPPointsValue *x_yPadding2 = [self.objectInfo.dataArray objectAtIndex:1];
        
        startPoint = CGPointMake((frame.size.height > frame.size.width) ? 4 : 0 , (frame.size.height < frame.size.width) ? frame.size.height/2 : 0);
        endPoint = CGPointMake(frame.size.width - 3, frame.size.height - 3);
//        if(self.frameType == CPNegativeArrowFrame) {
//            endPoint = CGPointMake(frame.size.width - 3, frame.size.height - 3);
//            
//        }
        [self setBackgroundColor:[UIColor whiteColor]];
        // Initialization code
    }
    return self;
}

-(IBAction)buttonpressed:(id)sender {
    NSLog(@"buttonpressed ");
}
/*
 @ UIView Life cycle method
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}
#pragma mark - Drawing
//For performing the drawing
- (void)drawRect:(CGRect)rect {
    
    tailWidth = 1;
    headWidth = 4;
    headLength = 4;
    path = [UIBezierPath dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                                  toPoint:(CGPoint)endPoint
                                                tailWidth:(CGFloat)tailWidth
                                                headWidth:(CGFloat)headWidth
                                               headLength:(CGFloat)headLength];
    [path setLineWidth:1.0];
    (self.senderType == TTMTo) ? [ChatLineSenderColor setStroke] : [ChatLineRecieverColor setStroke];
    (self.senderType == TTMTo) ? [ChatLineSenderColor setFill] : [ChatLineRecieverColor setStroke];
    [path stroke];
    //[path fill];
    self.textPath = path;
    
}
/*
 @//Define method for check that touch point is lie inside the touch point or not
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    if (strokedPathContainsPoint(self.textPath.CGPath, NULL, 10.0f, kCGLineCapRound,
                                 kCGLineJoinRound, 0, point, self.textPath.usesEvenOddFillRule))  {   return YES;
    }
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

/*
 @//Define method for check that touch point is lie inside the touch path
 */
static BOOL strokedPathContainsPoint(CGPathRef unstrokedPath,
                                     const CGAffineTransform *transform, CGFloat lineWidth,
                                     CGLineCap lineCap, CGLineJoin lineJoin, CGFloat miterLimit,
                                     CGPoint point, bool eoFill)
{
    CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(unstrokedPath,
                                                           transform, lineWidth, lineCap, lineJoin, miterLimit);
    BOOL doesContain = CGPathContainsPoint(strokedPath, NULL, point, eoFill);
    CGPathRelease(strokedPath);
    return doesContain;
}


//- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    UITouch* touchPoint = [touches anyObject];
//    startPoint = [touchPoint locationInView:self];
//    endPoint = [touchPoint locationInView:self];
//
//    NSLog(@"startPoint %@", NSStringFromCGPoint(startPoint));
//    [self setNeedsDisplay];
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [touches anyObject];
//    endPoint=[touch locationInView:self];
//    [self setNeedsDisplay];
//    NSLog(@"endpoint %@", NSStringFromCGPoint(startPoint));
//
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch* touch = [touches anyObject];
//    endPoint = [touch locationInView:self];
//    [self setNeedsDisplay];
//}


@end
