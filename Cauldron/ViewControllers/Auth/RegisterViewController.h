
//  RegisterViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Utils.h"
#import "Enums.h"

@interface RegisterViewController : BaseViewController {
    NSMutableDictionary *teamDictionary;
}
@property (weak, nonatomic) IBOutlet UIStackView *menuStackView;

@property (assign, nonatomic) RegisterState navigationStatus;
@property (strong, nonatomic) NSMutableArray *sportArr;

@property (weak, nonatomic) IBOutlet UISegmentedControl *teamSC;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *sportDDTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *nameFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *passwordFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *emailFLTF;

@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *contactNameFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *contactPhone;

@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *addressFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *cityFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *stateFLTF;
@property (weak, nonatomic) IBOutlet SkyFloatingLabelTextField *zipFLTF;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *emailCoachRankingView;
@property (weak, nonatomic) IBOutlet UISwitch *emailCoachRankingSwich;

@end
