//
//  EditCategoryViewController.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"
#import "ChallengeCatgry.h"



@protocol AddCategoryVCDelegate <NSObject>
@optional
- (void)didDisappear;
@end

@interface EditCategoryViewController : UIViewController{
    @public
    NSString *str_categoryName;
    NSString *str_shortName;
    int str_order;
    int catId;
    NSMutableDictionary *categoryDictionary;
    ChallengeCatgry *category;
}

@property (assign, nonatomic) CategoryState navigationCategoryStatus;

//@property (nonatomic, assign) BOOL isUpdate;
//@property (nonatomic, assign) int journalId;
//@property (nonatomic, strong) NSString *date;
//@property (nonatomic, strong) NSString *jornalData;
//@property (nonatomic, strong) NSString *playerName;
//@property (nonatomic, strong) NSMutableArray *allTeamPlayers;

@property (weak, nonatomic) IBOutlet UITextField *categoryNameTF;
@property (weak, nonatomic) IBOutlet UITextField *shortNameTF;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;


@property (weak, nonatomic) id<AddCategoryVCDelegate> delegate;

@end
