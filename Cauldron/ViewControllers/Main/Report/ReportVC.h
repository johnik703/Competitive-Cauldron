//  ReportVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttandanceReportTableViewCell.h"

@interface ReportVC : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *fromDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *toDDTF;
@property (weak, nonatomic) IBOutlet UIView *leftPanelView;
@property (weak, nonatomic) IBOutlet UIView *rightPanelView;

@end
