//
//  RosterVC.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlayerVC.h"
#import "AddPlayerCell.h"

@interface RosterVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *arrPlayerDetail;
}

@end
