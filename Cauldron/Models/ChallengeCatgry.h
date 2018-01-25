//
//  ChallengeCatgry.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeCatgry : NSObject
@property (nonatomic, assign) int catID;
@property (nonatomic, assign) int TeamID;
@property (nonatomic, copy) NSString *categoryname;
@property (nonatomic, copy) NSString *shortname;
@property (nonatomic, assign) int catOrder;
@end
