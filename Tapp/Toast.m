//
//  Toast.m
//  pruebaToast
//
//  Created by Juancho Pestana on 2/26/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Toast.h"
#import <QuartzCore/QuartzCore.h>

@implementation Toast

#define POPUP_DELAY  0.7

- (id)initWithText: (NSString*) msg
{
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        //        self.backgroundColor = [UIColor clearColor];
        
        self.textColor = [UIColor colorWithWhite:1 alpha: 0.95];
        //        self.textColor = [UIColor blackColor];
        
        self.font = [UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 30];
        self.text = msg;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        
    }
    return self;
}

- (void)didMoveToSuperview {
    
    UIView* parent = self.superview;
    
    if(parent) {
        
        //        CGSize maximumLabelSize = CGSizeMake(300, 200);
        //        CGSize expectedLabelSize = [self.text sizeWithFont: self.font  constrainedToSize:maximumLabelSize lineBreakMode: NSLineBreakByTruncatingTail];
        
        //        CGSize expectedLabelSize = [self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}
        //                                              (constrainedToSize:maximumLabelSize)
        //                                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize expectedLabelSize = [self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
        
        
        
        expectedLabelSize = CGSizeMake(expectedLabelSize.width + 100, expectedLabelSize.height + 80);
        
        //        self.frame = CGRectMake(parent.center.x - expectedLabelSize.width/2,
        //                                parent.bounds.size.height-expectedLabelSize.height - 300,
        //                                expectedLabelSize.width,
        //                                expectedLabelSize.height);
        
        self.frame = CGRectMake(parent.center.x - expectedLabelSize.width/2,
                                parent.bounds.size.height-expectedLabelSize.height - parent.bounds.size.height/2,
                                expectedLabelSize.width,
                                expectedLabelSize.height);
        
        
        
        CALayer *layer = self.layer;
        //        parent.layer.cornerRadius = 8;
        layer.cornerRadius = 8;
        
        
        
        
        
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:POPUP_DELAY];
    }
}

- (void)dismiss:(id)sender {
    // Fade out the message and destroy self
    [UIView animateWithDuration:0.6  delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^  { self.alpha = 0; }
                     completion:^ (BOOL finished) { [self removeFromSuperview]; }];
}


@end
