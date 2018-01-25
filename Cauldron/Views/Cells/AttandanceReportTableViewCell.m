//
//  AttandanceReportTableViewCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AttandanceReportTableViewCell.h"

@implementation AttandanceReportTableViewCell
@synthesize lblPercentage,lblPlayerNmae,lblTotalDays,lblTrainingDays;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
