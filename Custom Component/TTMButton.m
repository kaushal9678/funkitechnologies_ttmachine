//
//  TTMButton.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 05/03/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMButton.h"
#import "UIColor-Expanded.h"

#define BORDER_WIDTH	1.0f

/**
 This defines the radius of the button's rounded corners
 */

#define CORNER_RADIUS	7.0f

/**
 We set the opacity of the button (not including the text) to 0.9 if the button is enabled or 0.4 if the button is disabled. You can change this if you wish.
 */
#define OPACITY_ENABLED 0.9f
#define OPACITY_DISABLED 0.4F
@implementation TTMButton

@synthesize tintColor = _tintColor;

/*!
 @method  - (void)setupGradient
 @abstract   This is set up the gradient.
 @discussion This is set up the gradient to fill the inside button.
 */
- (void)setupGradient
{
	CGFloat h, s, b, a;
    
	[self.tintColor hue:&h saturation:&s brightness:&b alpha:&a];
	
	//The outer stroke uses the pure color
	gradientLayer.borderColor = tintColor.CGColor;
    
	//We build a gradient to fill the button's inside
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHue:h saturation:0.0f brightness:1.0f alpha:a].CGColor,
							(id)[UIColor colorWithHue:h saturation:(s - MAX(0.0f, (s - 0.1f) * 0.25f)) brightness:(b + MAX(0.0f, (0.9f - b) * 0.25f)) alpha:a].CGColor,
							(id)tintColor.CGColor,
							(id)[UIColor colorWithHue:h saturation:(s - MAX(0.0f, (s - 0.1f) * 0.2f)) brightness:(b + MAX(0.0f, (0.9f - b) * 0.2f)) alpha:a].CGColor,
							nil];
	
	gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
							   [NSNumber numberWithFloat:0.5f],
							   [NSNumber numberWithFloat:0.5f],
							   [NSNumber numberWithFloat:1.0f],
							   nil];
}

/*!
 @method  - (void)addLayers
 @abstract   this is used to mix the layers to obtain the desired effect.
 @discussion this is used to mix the layers to obtain the desired effect as set opacity ,draw shadow etc.
 
 */

- (void)addLayers
{
	//We mix the layers to obtain the desired effect
	gradientLayer = [[CAGradientLayer alloc] init];
	gradientLayer.cornerRadius = CORNER_RADIUS;
	gradientLayer.borderWidth = BORDER_WIDTH;
	
	//If it is supported under this iOS version, we put a shadow under it
	if ([gradientLayer respondsToSelector:@selector(setShadowColor:)])
	{
		gradientLayer.shadowColor = [UIColor blackColor].CGColor;
		gradientLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
		gradientLayer.shadowOpacity = 0.50f;
		gradientLayer.shadowRadius = 1.5f;
	}
	
	//We set the opacity
	gradientLayer.opacity = (self.enabled) ? OPACITY_ENABLED : OPACITY_DISABLED;
	
	//We draw the button taking into account the borders and the shadow
	[gradientLayer setFrame:CGRectMake(4.0f, 2.0f, self.frame.size.width - 8.0f, self.frame.size.height - 7.0f)];
	[self.layer insertSublayer:gradientLayer below:[self.layer.sublayers lastObject]];
	
	//If the button is highlighted (e.g.: pressed) we draw it
	highlightLayer = [[CALayer alloc] init];
	highlightLayer.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f].CGColor;
	highlightLayer.cornerRadius = CORNER_RADIUS;
	//[highlightLayer setFrame:CGRectMake(4.0f, 2.0f, self.frame.size.width - 8.0f, self.frame.size.height - 7.0f)];
	
	if (self.highlighted)
		[self.layer insertSublayer:highlightLayer below:[self.layer.sublayers lastObject]];
}

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
    }
	
    return self;
}
/*
 * Overriding the initWithCoder: method for UIView Parent class.
 * Inside the method defining the background color.
 */

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder])
	{
		//The button defaults to Blue with transparent background
		self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/*!
 @function   - (void)setEnabled:(BOOL)value
 @abstract   This is used set opacity.
 @discussion This is used enable opacity if disabled, otherwisw disable it.
 @param      (BOOL)value
 @result     enables/ disables opacity depending up on the state.
 */

- (void)setEnabled:(BOOL)value {
	[super setEnabled:value];
	gradientLayer.opacity = (value) ? OPACITY_ENABLED : OPACITY_DISABLED;
}

/*!
 @function   - (void)setHighlighted:(BOOL)value
 @abstract   This is used highlight layer.
 @discussion This is used highlight layer if not highlighted, otherwisw removes from super layer.
 @param      (BOOL)value
 @result     change the highlighted state
 */

- (void)setHighlighted:(BOOL)value {
	[super setHighlighted:value];
    
	if (!value)
		[highlightLayer removeFromSuperlayer];
	else if (highlightLayer.superlayer == nil)
		[self.layer insertSublayer:highlightLayer above:gradientLayer];
}

/*!
 @method  - (UIColor *)tintColor
 @abstract   this is used return color.
 @discussion this is used return tint color.
 */

- (UIColor *)tintColor {
	return tintColor;
}

/*!
 @function  - (void)setTintColor:(UIColor *)value
 @abstract   This is used set tint color.
 @discussion This is used return tint color and set tint color.
 @param      (UIColor *)value
 @result     sets tint color.
 */

- (void)setTintColor:(UIColor *)value {
	if (tintColor != value)
	{
        tintColor = value ;
        [self addLayers];
		[self setupGradient];
	}
}
/*!
 @function   - (void)setBounds:(CGRect)rect
 @abstract   This is used set bound.
 @discussion This is used to set bound in gradient layer.
 @param      (CGRect)rect
 @result     Sets bound in gradient layer.
 */

- (void)setBounds:(CGRect)rect {
	[super setBounds:rect];
    
	[gradientLayer setBounds:CGRectMake(4.0f, 2.0f, self.bounds.size.width - 8.0f, self.bounds.size.height - 7.0f)];
	[highlightLayer setBounds:CGRectMake(4.0f, 2.0f, self.bounds.size.width - 8.0f, self.bounds.size.height - 7.0f)];
}

/*!
 @function   - (void)setFrame:(CGRect)rect
 @abstract   This is used set frame.
 @discussion This is used to set bound in gradient layer.
 @param      (CGRect)rect
 @result     Sets bound in gradient layer.
 */
- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
    
	[gradientLayer setFrame:CGRectMake(4.0f, 2.0f, self.frame.size.width - 8.0f, self.frame.size.height - 7.0f)];
	[highlightLayer setFrame:CGRectMake(4.0f, 2.0f, self.frame.size.width - 8.0f, self.frame.size.height - 7.0f)];
}
/*!
 @method   - (void)dealloc
 @abstract   this is used for memory management.
 @discussion this is used to release allocated memory.
 */
- (void)dealloc {
	[gradientLayer removeFromSuperlayer];
	[highlightLayer removeFromSuperlayer];
	self.tintColor = nil;
	
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
