//
//  MenuCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

@synthesize menuLabel, menuImageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    menuImageView.layer.cornerRadius = 15.0f;
//    menuImageView.layer.masksToBounds = YES;
//    menuImageView.layer.zPosition = 100;
    menuImageView.image = [UIImage imageNamed:@"avatar"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
