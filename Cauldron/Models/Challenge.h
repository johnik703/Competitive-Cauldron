//
//  Challenge.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Challenge : NSObject

@property (nonatomic, assign) int TeamID;
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *Challenge_Name;
@property (nonatomic, copy) NSString *Challenge_Menu;
@property (nonatomic, copy) NSString *Challenge_Text1;
@property (nonatomic, copy) NSString *Challenge_Text2;
@property (nonatomic, copy) NSString *Challenge_Text3;
@property (nonatomic, assign) int Challenge_Multiplier;
@property (nonatomic, copy) NSString *Challenge_Type;
@property (nonatomic, assign) int Challenge_Exclude;
@property (nonatomic, assign) int Challenge_Fitness_Include;
@property (nonatomic, assign) int Challenge_Category;
@property (nonatomic, copy) NSString *Challenge_Desc;
@property (nonatomic, copy) NSString *Challenge_Detail;
@property (nonatomic, assign) int WLT;
@property (nonatomic, assign) int Show_Ties;
@property (nonatomic, copy) NSString *Video_Name;
@property (nonatomic, assign) int Enabled;
@property (nonatomic, assign) int isDecimal;
@property (nonatomic, copy) NSString *Challenge_Pic;
@property (nonatomic, assign) int isHome;
@property (nonatomic, assign) int playersCount;
@property (nonatomic, copy) NSString *modified;

@property (nonatomic, assign) int topPerformer;
@property (nonatomic, copy) NSString *standard0;
@property (nonatomic, assign) int isAvg;
@property (nonatomic, assign) int isAdding;
@property (nonatomic, copy) NSString *fields;
@property (nonatomic, assign) int stats_exist;
@property (nonatomic, copy) NSString *Rorder;
@property (nonatomic, copy) NSString *RankFormula;



@end















