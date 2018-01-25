//
//  SyncToServer.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//


@protocol SyncToServerDelegate<NSObject>
- (void) SyncToServerProcessCompleted;
@end

#import <Foundation/Foundation.h>
#import "ProgressHudHelper.h"
#import "Attandance.h"
#import "Journal.h"
#import "Player.h"
@interface SyncToServer : NSObject <NSURLConnectionDelegate>
{
    id <SyncToServerDelegate> delegate;
    NSMutableData *responseDataFromChallange;
    NSMutableData *responseDataFromAttandance;
    NSMutableData *responseDataFromJournal;
    NSMutableData *responseDataFromPlayer;

    
    int syncCount;

    int totalDataToSyncChal;
    int totalDataToSyncAtd;
    int totalDataToSyncJournal;
    int totalDataToSyncPlayer;

    NSMutableArray *allStatesJsonStringArray;
    NSMutableArray *allStatesJsonStringArrayForSync;
    NSMutableArray *allStatesJsonStringArrayAtd;
    NSMutableArray *allStatesJsonStringArrayAtdForSync;
    NSMutableArray *allStatesJsonStringArrayJornal;
    NSMutableArray *allStatesJsonStringArrayPlayer;
    NSUInteger totalItemsCount;
}



@property (nonatomic,strong) id delegate;

- (NSUInteger)getTotalItemsSyncToServerCount;
-(void)startSyncDataToServer;
-(NSArray*)createJsonStringsArray;
-(void)startSyncStatsDataToServer;
-(void)startSyncJournalDataToServer;

@end

