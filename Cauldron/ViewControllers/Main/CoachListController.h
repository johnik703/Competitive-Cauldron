//
//  CoachListController.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coach.h"

@interface CoachListController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableDictionary *coachDictionary;
    Coach *coach;
    
}

@end
