//
//  ChallengeListViewController.h
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallengeHeader.h"
#import "CommonTableViewCell.h"
@interface ChallengeListViewController : UIViewController
{
    NSString *synDataBy;
    NSArray *chalCatArray;
    NSArray *ChallengesList;
    NSMutableArray *allChallengesArray;
    NSMutableArray *challengesArray;
    NSMutableArray *secIndexArray;
}

@property(nonatomic, assign) int userTeamID;
@property(nonatomic, assign) int soportsID;
@property(nonatomic, assign) NavigationStatus status;
@end
