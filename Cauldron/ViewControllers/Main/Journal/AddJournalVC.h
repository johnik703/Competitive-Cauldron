//
//  AddJournalVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddJournalVCDelegate <NSObject>
@optional
- (void)didDisappear;
@end

@interface AddJournalVC : UIViewController

@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, assign) int journalId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *jornalData;
@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, strong) NSMutableArray *allTeamPlayers;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *playerNameDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *dateDDTF;
@property (weak, nonatomic) IBOutlet UITextView *journalTV;

@property (weak, nonatomic) id<AddJournalVCDelegate> delegate;

@end
