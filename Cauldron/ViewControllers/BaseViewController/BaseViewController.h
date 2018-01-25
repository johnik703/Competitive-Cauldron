//
//  BaseViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)addMenuLeftBarButtomItem;
- (void)showHTTPErrorAlert:(nonnull UIViewController *)viewController;

@end


@interface BaseTableViewController : UITableViewController

- (void)addMenuLeftBarButtomItem;

@end
