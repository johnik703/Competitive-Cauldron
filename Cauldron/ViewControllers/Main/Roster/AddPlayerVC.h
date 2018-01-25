//
//  AddPlayerVC.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "Player.h"

@protocol AddPlayerDelegate <NSObject>
@optional
- (void)didDisappear;
@end

@interface AddPlayerVC : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    NSMutableDictionary *playerDictionary;
    Player *player;
    
}


@property (assign, nonatomic) TeamState navigationRosterStatus;

@property (nonatomic,assign) BOOL isUpdate;
@property (nonatomic,assign) int playerID;

@property (nonatomic, strong) NSMutableArray *positionArr;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UITextField *jserseyTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *userlevelTF;
@property (weak, nonatomic) IBOutlet UITextView *noteTV;
@property (weak, nonatomic) IBOutlet UITextField *contactNoTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UITextField *momEmailTF;
@property (weak, nonatomic) IBOutlet UISwitch *momEmailSwitch;
@property (weak, nonatomic) IBOutlet UITextField *dadEmailTF;
@property (weak, nonatomic) IBOutlet UISwitch *dadEmailSwitch;
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *gradeDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *birthdayDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *graduationDateDDTF;

@property (weak, nonatomic) id<AddPlayerDelegate> delegate;

@end
