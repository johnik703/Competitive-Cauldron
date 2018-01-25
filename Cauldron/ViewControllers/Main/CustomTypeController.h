//
//  CustomTypeController.h
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditChaListTabViewController.h"

@interface CustomTypeController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
@public
    Challenge *customChallenge;
    
    @public
    EditChaListTabViewController *editChaListController;
    
    
}


@property (assign, nonatomic) CustomChallengeState navigationCustomStatus;
@property (weak, nonatomic) IBOutlet UIView *rankingFormulaButtonContainer;
@property (weak, nonatomic) IBOutlet UISwitch *averageSwitch;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *orderDropdownField;
@property (weak, nonatomic) IBOutlet UIButton *rankingFormulaButton;


- (void)recieveRankFormulaFromCustomCalcu:(NSString *)rankFormula;
@end
