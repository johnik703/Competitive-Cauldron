//
//  UIFont+CustomFont.m
//  Cauldron
//
//  Created by John Nik on 5/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFonts)

+ (instancetype) ubuntuRegularFont:(float) size {
    return [UIFont fontWithName:@"Ubuntu" size:size];
}

+ (instancetype) ubuntuLightFont:(float) size {
    return [UIFont fontWithName:@"Ubuntu-Light" size:size];
}

+ (instancetype) ubuntuMediumFont:(float) size {
    return [UIFont fontWithName:@"Ubuntu-Medium" size:size];
}

@end
