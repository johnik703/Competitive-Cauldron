//
//  AddPlayerCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AddPlayerCell.h"

@implementation AddPlayerCell
@synthesize lblBirthDate,lblName,lblJourcyNo,imgPlayer;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    imgPlayer.layer.cornerRadius = 22.0f;
    imgPlayer.layer.zPosition = 100;
    imgPlayer.image = [UIImage imageNamed:@"avatar"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
