//
//  LoginUser.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUser : NSObject

@property(nonatomic ,copy) NSString *FirstName;
@property(nonatomic ,copy) NSString *Grade;
@property(nonatomic ,copy) NSString *LastName;
@property(nonatomic ,copy) NSString *PEmail;
@property(nonatomic ,copy) NSString *Password;
@property(nonatomic ,assign) int PlayerID;
@property(nonatomic ,copy) NSString *Position;
@property(nonatomic ,assign) int TeamID;
@property(nonatomic ,assign)int UserLevel;
@property(nonatomic ,copy) NSString *UserName;
@property(nonatomic ,assign)int auth;
@property(nonatomic ,copy) NSString *teams;

@property(nonatomic ,assign) int Mode;
@property(nonatomic ,retain) NSMutableArray *arrTeams;
@property(nonatomic ,copy) NSString *userState;
@property(nonatomic, copy) NSString *Sport;


@end
