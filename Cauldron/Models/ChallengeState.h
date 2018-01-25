//
//  ChallengeState.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeState : NSObject

@property(nonatomic,assign)int StatID;
@property(nonatomic,assign)int chStTeamID;
@property(nonatomic,assign)int chalStID;
@property(nonatomic,assign)int chalStPlayerID;
@property(nonatomic,copy)NSString *chalStColName;
@property(nonatomic,copy)NSString *chalStColVal;
@property(nonatomic,copy)NSString *chalModDate;
@property (nonatomic, assign) int email_reportAdded;
@end
