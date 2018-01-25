//
//  AttandaceCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AttandanceCell.h"

@implementation AttandanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImgView.layer.cornerRadius = 25.0;
    self.checkBox.onAnimationType = BEMAnimationTypeFill;
    self.checkBox.offAnimationType = BEMAnimationTypeFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
