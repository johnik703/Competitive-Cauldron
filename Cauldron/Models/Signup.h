//
//  Signup.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Signup : NSObject

@property(nonatomic, retain) NSString *sports;
@property(nonatomic, retain) NSString *statsYear;
@property(nonatomic, retain) NSString *teamName;
@property(nonatomic, retain) NSString *base64Pic;
@property(nonatomic, retain) NSString *subscriptionEnds;
@property(nonatomic, retain) NSString *adminLoginName;
@property(nonatomic, retain) NSString *adminPassword;
@property(nonatomic, retain) NSString *adminEmail;
@property(nonatomic, retain) NSString *mgrLoginName;
@property(nonatomic, retain) NSString *mgrPassword;
@property(nonatomic, retain) NSString *mgrEmail;
@property(nonatomic, retain) NSString *sessionStarts;
@property(nonatomic, retain) NSString *sessionEnds;
@property(nonatomic, retain) NSString *bdayBefor;
@property(nonatomic, retain) NSString *position;
@property(nonatomic, retain) NSString *contactName;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *zip;
@property(nonatomic, retain) NSString *contactEmail;
@property(nonatomic, retain) NSString *contactPhone;
@property(nonatomic, retain) NSString *notes;
@property(nonatomic, retain) NSString *timeInterval;
@property(nonatomic, retain) NSString *timeOfDay;
@property(nonatomic, retain) NSString *dayOfWeek;
@property(nonatomic, retain) NSString *signupAs;
@property(nonatomic, retain) NSString *userlevel;
@property(nonatomic, retain) NSString *schedualEmail;

//CheckBoxes value
@property(nonatomic, assign) int sportsID;
@property(nonatomic, assign) BOOL isDisplayPic;
@property(nonatomic, assign) BOOL isActivate;
@property(nonatomic, assign) BOOL isIncludeFitness;
@property(nonatomic, assign) BOOL isBulckReport;
@property(nonatomic, assign) BOOL isRunSchedual;
@property(nonatomic, assign) BOOL isEnable;
@property(nonatomic, assign) BOOL isBdayBefore;
@property(nonatomic, assign) BOOL isHighlightBest;
@property(nonatomic, assign) BOOL isHighlightDrop;
@property(nonatomic, assign) BOOL isDisplayLegend;
@property(nonatomic, assign) BOOL isEmailPlayer;
@property(nonatomic, assign) BOOL isEmailJournal;
@property(nonatomic, assign) BOOL isUpdate;

@end
