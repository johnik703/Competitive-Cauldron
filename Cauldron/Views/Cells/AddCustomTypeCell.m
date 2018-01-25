//
//  AddCustomTypeCell.m
//  Cauldron
//
//  Created by John Nik on 5/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AddCustomTypeCell.h"

@implementation AddCustomTypeCell
@synthesize addCustomTypeField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    addCustomTypeField.placeholder = @"Type field name!";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
