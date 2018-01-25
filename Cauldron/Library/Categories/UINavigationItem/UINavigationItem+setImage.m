//
//  UINavigationItem+setImage.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UINavigationItem+setImage.h"

@implementation UINavigationItem (setImage)

- (void) setImage:(UIImage *)image
{
    if (image) {
        [self setTitle:@""];
        self.titleView = [[UIImageView alloc] initWithImage:image];
    }
}

@end
