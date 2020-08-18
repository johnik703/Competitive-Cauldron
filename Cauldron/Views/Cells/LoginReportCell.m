//
//  LoginReportCell.m
//  Cauldron
//
//  Created by John Nik on 09/03/2018.
//  Copyright © 2018 Logic express. All rights reserved.
//

#import "LoginReportCell.h"

@implementation LoginReportCell
@synthesize playerNameLabel, userNameLabel, passwordLabel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}


- (void)setupViews {
    
    playerNameLabel = [[UILabel alloc] init];
    userNameLabel = [[UILabel alloc] init];
    passwordLabel = [[UILabel alloc] init];
    
    playerNameLabel.textColor = [UIColor darkGrayColor];
    userNameLabel.textColor = [UIColor darkGrayColor];
    passwordLabel.textColor = [UIColor darkGrayColor];
    
    playerNameLabel.font = [UIFont systemFontOfSize:16];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    
    [playerNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [userNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [passwordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
     
    [self addSubview:playerNameLabel];
    [self addSubview:userNameLabel];
    [self addSubview:passwordLabel];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    [[playerNameLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10] setActive:YES];
    [[playerNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[playerNameLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    [[playerNameLabel.widthAnchor constraintEqualToConstant:width * 2 / 5] setActive:YES];
    
    [[userNameLabel.leftAnchor constraintEqualToAnchor:playerNameLabel.rightAnchor] setActive:YES];
    [[userNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[userNameLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    [[userNameLabel.widthAnchor constraintEqualToConstant:width * 1 / 3] setActive:YES];
    
    [[passwordLabel.leftAnchor constraintEqualToAnchor:userNameLabel.rightAnchor] setActive:YES];
    [[passwordLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
    [[passwordLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[passwordLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
