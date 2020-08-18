//
//  AttendanceVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceVC : UIViewController
{
    NSArray *tableData;
    NSArray *playerInfos;
    NSMutableArray *PlayersInfoArray;
    NSMutableArray *selectedRowsArray;
    NSMutableArray *teamPlayers;
}

@property (weak, nonatomic) IBOutlet IQDropDownTextField *dateDDTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (strong, nonatomic) IBOutlet UISwitch *emailReportSwitch;

@end
