//
//  JournalVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKCommon.h"
#import "Journal.h"
#import "AddJournalVC.h"
#import "JournalCell.h"
#import "CommonTableViewCell.h"

@interface JournalVC : UIViewController
{
    NSArray *tableData;
    NSMutableArray *selectedRowsArray;
    NSMutableArray *arrNotes;
    NSMutableArray *arrid;
    NSMutableArray *arrDate;
    
    NSMutableArray *PlayersInfoArray;
    NSMutableArray *teamPlayers;
    
    NSMutableArray *allTeamPlayers;
    UIView *actionSheet;
    NSMutableArray *arrJournalData;
    NSString *playerID;
}

@property (nonatomic, assign) int usetTeamID;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *fromDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *toDDTF;
@property (weak, nonatomic) IBOutlet UIView *leftPanelView;
@property (weak, nonatomic) IBOutlet UIView *rightPanelView;

@end
