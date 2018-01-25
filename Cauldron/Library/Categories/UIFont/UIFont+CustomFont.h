//
//  UIFont+CustomFont.h
//  Cauldron
//
//  Created by John Nik on 5/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIFont (CustomFonts)

+ (instancetype) ubuntuRegularFont:(float) size;
+ (instancetype) ubuntuLightFont:(float) size;
+ (instancetype) ubuntuMediumFont:(float) size;

#define     UbuntuFont(f)               [UIFont fontWithName:@"Ubuntu" size:f]
#define     UbuntuFont_Light(f)         [UIFont fontWithName:@"Ubuntu-Light" size:f]
#define     UbuntuFont_Medium(f)        [UIFont fontWithName:@"Ubuntu-Medium" size:f]
@end
