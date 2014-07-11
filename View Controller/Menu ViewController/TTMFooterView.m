//
//  TTMFooterView.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 3/23/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "Macro.h"
#import "TTMFooterView.h"

@implementation TTMFooterView

@synthesize selectedImage = _selectedImage;
@synthesize selectCategoryImage = _selectCategoryImage;
@synthesize suggestionLabel = _suggestionLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addImageViewOnView];
        [self addSuggestionLabel];
    }
    return self;
}

-(void)addImageViewOnView {
    
    UIImage *image = self.selectedImage;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, image.size.width,image.size.height)];
    [self addSubview:imgView];
    [imgView setImage:image];
    self.selectCategoryImage = imgView;
}

-(void)addSuggestionLabel  {
    
    UILabel *suggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + self.selectCategoryImage.frame.size.width, 5, 200,40)];
    [suggestionLabel setText:@"Tap a friend to begin"];
    [suggestionLabel setTextColor:[UIColor whiteColor]];
    [suggestionLabel setFont:[UIFont fontWithName:LotoLight size:14.0f]];
    [self addSubview:suggestionLabel];
    self.suggestionLabel = suggestionLabel;
    
}

-(void)setNeedsLayout {
    
    [super setNeedsLayout];
    [self.selectCategoryImage setFrame:CGRectMake(10, 5, self.selectedImage.size.width/2,self.selectedImage.size.height/2)];
    [self.suggestionLabel setFrame:CGRectMake(20 + self.selectCategoryImage.frame.size.width, 5, 200,40)];

    [self.selectCategoryImage setImage:self.selectedImage];
    [self.suggestionLabel setText:self.suggestionLabel_string];
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
