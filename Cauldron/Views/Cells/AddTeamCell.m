//
//  AddTeamCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AddTeamCell.h"

@implementation AddTeamCell

@synthesize lblTeamName, imgTeam;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    imgTeam.layer.cornerRadius = 25.0f;
    imgTeam.layer.zPosition = 100;
    imgTeam.image = [UIImage imageNamed:@"avatar"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
