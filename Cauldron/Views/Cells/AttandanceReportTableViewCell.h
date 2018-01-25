//
//  AttandanceReportTableViewCell.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttandanceReportTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *lblPlayerNmae;
@property(nonatomic,retain)IBOutlet UILabel *lblTrainingDays;
@property(nonatomic,retain)IBOutlet UILabel *lblTotalDays;
@property(nonatomic,retain)IBOutlet UILabel *lblPercentage;

@end
