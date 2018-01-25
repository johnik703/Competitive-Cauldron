//
//  SyncFromServerClub.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressHudHelper.h"

@protocol SyncFromServerClubDelegate <NSObject>
- (void) syncFromServerProcessClubCompleted;
@end

@interface SyncFromServerClub : NSObject
{
    id <SyncFromServerClubDelegate> delegate;
    
    int syncCount;

}
@property (nonatomic,strong) id delegate;
-(void)loadDataRecordsWithURL:(NSString*)WebServiceURL serviceType:(NSString*)callServiceFor withTeamID:(int)userTeamID;
-(void)startSyncFromServerWithDataDict:(NSDictionary*)recieveDataDict serviceType:(NSString*)callServiceFor WithTeamID:(int)userTeamID;
-(void)removeAllTableDataAfterLoginWithTableName:(NSString*)dbTableName;

@end
