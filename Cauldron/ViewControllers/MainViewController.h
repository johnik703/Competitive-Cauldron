//
//  MainViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncFromServer.h"
#import "SyncFromServerClub.h"
#import "SyncToServer.h"
#import "XMLReader.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSString *selectedLeftMenuItem;

@end
