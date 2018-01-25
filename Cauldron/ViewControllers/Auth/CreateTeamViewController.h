//
//  CreateTeamViewController.h
//  Cauldron
//
//  Created by John Nik on 4/10/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTeamCell.h"
#import "ChallengeCatgry.h"

@interface CreateTeamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
@public
    NSMutableArray *arrTeamsDetail;
    
}

@property (weak, nonatomic) IBOutlet UINavigationItem *addTeam;
@property (assign, nonatomic) CreateControllerState navigationCreateControllerStatus;

@end
