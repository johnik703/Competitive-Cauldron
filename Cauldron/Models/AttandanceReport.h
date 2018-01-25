//
//  AttandanceReport.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttandanceReport : NSObject
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *totalDays;
@property(nonatomic,retain)NSString *attandDays;
@property(nonatomic,retain)NSString *percentage;
@end
