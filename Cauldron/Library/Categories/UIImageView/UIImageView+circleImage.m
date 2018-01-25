//
//  UIImageView+circleImage.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIImageView+circleImage.h"

@implementation UIImageView (circleImage)

- (void) circleImage
{
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
