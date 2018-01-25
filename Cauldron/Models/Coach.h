//
//  Coach.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coach : NSObject

@property (nonatomic, copy) NSString *playerID;
@property (nonatomic, assign)int coachID;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *contactCity;
@property (nonatomic, copy) NSString *contactState;
@property (nonatomic, copy) NSString *contactZip;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *coachLoginName;
@property (nonatomic, copy) NSString *coachPassword;
@property (nonatomic, copy) NSString *coachEmail;
@property (nonatomic, copy) NSString *admin_email;
@property (nonatomic, copy) NSString *teams;
@property (nonatomic, assign)int emailCoachRanking;


@end
