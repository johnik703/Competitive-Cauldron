//
//  SyncFromServer.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//


@protocol SyncFromServerDelegate <NSObject>
- (void) syncFromServerProcessCompleted;
@end

#import <Foundation/Foundation.h>
#import "ProgressHudHelper.h"

@interface SyncFromServer : NSObject
{
    id <SyncFromServerDelegate> delegate;
    
    int syncCount;
    int completeSyncCount;
}

@property (nonatomic,strong) id delegate;

@property (assign, nonatomic) SyncFromServerState SyncStatus;

-(void)loadDataRecordsWithURL:(NSString*)WebServiceURL serviceType:(NSString*)callServiceFor withTeamID:(int)userTeamID syncCount:(int)cnt playerID:(int)playerID mode:(int)mode;
-(void)startSyncFromServerWithDataDict:(NSDictionary*)recieveDataDict serviceType:(NSString*)callServiceFor WithTeamID:(int)userTeamID syncCount:(int)cnt playerID:(int)playerID mode:(int)mode;
-(void)removeAllTableDataAfterLoginWithTableName:(NSString*)dbTableName;
@end
