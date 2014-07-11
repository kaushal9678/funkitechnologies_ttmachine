#import <UIKit/UIKit.h>

@interface UIBezierPath (dqd_arrowhead)

//Method is declared for the drawing arrow with end point and strat point
+ (UIBezierPath *)dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                           toPoint:(CGPoint)endPoint
                                         tailWidth:(CGFloat)tailWidth
                                         headWidth:(CGFloat)headWidth
                                        headLength:(CGFloat)headLength;

@end
