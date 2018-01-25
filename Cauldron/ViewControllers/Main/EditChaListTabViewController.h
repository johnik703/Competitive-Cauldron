//
//  EditChaListTabViewController.h
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "Challenge.h"
#import "ChallengeListViewController.h"

@protocol AddChallengeVCDelegate <NSObject>
@optional
- (void)didDisappear;
@end

@interface EditChaListTabViewController : UITableViewController {
    
    int fitnessHeight;
    int showTiesHeight;
    int addFieldHeight;
    
    NSMutableDictionary *ChallengeSubcategoryDictionary;
    @public
    Challenge *challengeSubcategory;
    
}

@property (assign, nonatomic) ChallengeListState navigationChallengeStatus;
@property (assign, nonatomic) ChallengeFitnessState navigationFitnessStatus;

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UITextField *txt_challengeMenu;
@property (weak, nonatomic) IBOutlet UITextField *txt_challengeText1;
@property (weak, nonatomic) IBOutlet UITextField *txt_challengeText2;
@property (weak, nonatomic) IBOutlet UITextField *txt_challengeText3;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *list_challengeMultiplier;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *list_challengeType;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *list_challengeCategory;

@property (weak, nonatomic) IBOutlet UITextField *list_FitnessStandard;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *list_RankCount;

@property (weak, nonatomic) IBOutlet UISwitch *switch_excludeFromFinalRpt;
@property (weak, nonatomic) IBOutlet UISwitch *switch_includeFitnessRpt;
@property (weak, nonatomic) IBOutlet UISwitch *switch_enabledChallenge;
@property (weak, nonatomic) IBOutlet UISwitch *switch_includeTopPerformerReport;
@property (weak, nonatomic) IBOutlet UISwitch *switch_continueAdding;
@property (weak, nonatomic) IBOutlet UILabel *showTiesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *showTiesSwitch;

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *addCustomTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *addCustomTypeButton;

@property (nonatomic, retain) NSString *selectedCategory;



@property (weak, nonatomic) id<AddChallengeVCDelegate> delegate;

- (BOOL) checkValidation;
- (void)recieveCustomDataFromCustomTypeController:(int)isAvg castOrder:(NSString *)rOrder fieldsName:(NSString *)fields rankFormula:(NSString *)rankFormula;

@end
