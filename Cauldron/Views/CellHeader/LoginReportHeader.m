//
//  LoginReportHeader.m
//  Cauldron
//
//  Created by John Nik on 09/03/2018.
//  Copyright © 2018 Logic express. All rights reserved.
//

#import "LoginReportHeader.h"

@implementation LoginReportHeader
@synthesize playerNameLabel, userNameLabel, passwordLabel;


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
        
    }
    return self;
}

- (void)setupViews {
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = UA_rgba(83, 163, 24, 1);

    self.backgroundView = view;
    
    playerNameLabel = [[UILabel alloc] init];
    userNameLabel = [[UILabel alloc] init];
    passwordLabel = [[UILabel alloc] init];
    
    playerNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textColor = [UIColor whiteColor];
    passwordLabel.textColor = [UIColor whiteColor];
    
    playerNameLabel.font = [UIFont systemFontOfSize:18];
    userNameLabel.font = [UIFont systemFontOfSize:18];
    passwordLabel.font = [UIFont systemFontOfSize:18];
    
    playerNameLabel.text = @"Player Name";
    userNameLabel.text = @"UserName";
    passwordLabel.text = @"Password";
    
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

@end
