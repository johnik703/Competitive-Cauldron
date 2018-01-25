//
//  UIApplication+AppVersion.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppVersion)

+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;

@end
