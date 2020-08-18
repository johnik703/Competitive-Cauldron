//
//  SyncFromServer.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "SyncFromServer.h"
#import "WebServicesLinks.h"
#import "JSONHelper.h"
#import "Player.h"
#import "DataFetcherHelper.h"
#import "Reachability.h"
#import "SCSQLite.h"
#import "RKCommon.h"

#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

@implementation SyncFromServer
@synthesize delegate;

-(void)loadDataRecordsWithURL:(NSString*)WebServiceURL serviceType:(NSString*)callServiceFor withTeamID:(int)userTeamID syncCount:(int)cnt playerID:(int)playerID mode:(int)mode
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_async(queue, ^{
       // Get the JSON string from our web serivce
       NSDictionary * dictionary = [JSONHelper loadJSONDataFromURL:WebServiceURL];
       dispatch_async(dispatch_get_main_queue(), ^{
          //This code will run once the JSON-loading section above has completed.
          [self startSyncFromServerWithDataDict:dictionary serviceType:callServiceFor WithTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
          syncCount ++;
      });
   });
}

-(void)startSyncFromServerWithDataDict:(NSDictionary*)recieveDataDict serviceType:(NSString*)callServiceFor WithTeamID:(int)userTeamID syncCount:(int)cnt playerID:(int)playerID mode:(int)mode
{
    
    NSUInteger totalServiceCount = 9.0 * cnt;
    NSMutableDictionary *valuesDictionary = [[NSMutableDictionary alloc] init];
    
    //NSLog(@"Recieved Data Dictionary of WebService : %@",recieveDataDict);
    if([callServiceFor isEqualToString:@"startSync"])
    {
        //check connection
        BOOL activeConn = [RKCommon checkInternetConnection];
        
        if(activeConn)
        {
            syncCount = 0;
            completeSyncCount = 0;
            
            if (cnt == 1) {
                [self removeCurrentTeamDataFromLocalDataBaseBeforeSync:userTeamID];
            } else {
                [self removeAllDataFromLocalDataBaseBeforeSync];
            }
            [self loadDataRecordsWithURL:[NSString stringWithFormat:playerServiceURL,userTeamID, playerID, mode] serviceType:@"playerService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
            [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
            [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
            
            self.SyncStatus = SyncFromServerState_StartService;
        }
        else
        {
            [ProgressHudHelper hideLoadingHud];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"No Active Connection Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if([callServiceFor isEqualToString:@"playerService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_StartService) {
            self.SyncStatus = SyncFromServerState_PlayerService;
        }
        
        NSArray *allPlayers = [DataFetcherHelper getAllPlayerDataFromDict:recieveDataDict];
        if([allPlayers count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:teamServiceURL,userTeamID, playerID, mode] serviceType:@"teamService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_PlayerService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                
            }
            
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"teamService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_PlayerService) {
            self.SyncStatus = SyncFromServerState_TeamService;
        }
        NSArray *allTeams = [DataFetcherHelper getAllTeamDataFromDict:recieveDataDict];
        
//        NSLog(@"testsecondrecievechallengeData, %@", recieveDataDict);
        
        if([allTeams count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:challengeServiceURL,userTeamID, playerID, mode] serviceType:@"challengeService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_TeamService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
               
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"challengeService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_TeamService) {
            self.SyncStatus = SyncFromServerState_ChallengeService;
        }
        NSArray *allChallenges = [DataFetcherHelper getAllChallengeDataFromDict:recieveDataDict];
        
//        NSLog(@"testChallenge, %@", recieveDataDict);
        
        if([allChallenges count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngCategoryServiceURL,userTeamID, playerID, mode] serviceType:@"categoryService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_ChallengeService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"categoryService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_ChallengeService) {
            self.SyncStatus = SyncFromServerState_CategoryService;
        }
         NSArray *allCatagories = [DataFetcherHelper getAllCategoryDataFromDict:recieveDataDict];
        //NSLog(@"Details For Category = %@ And Total : %d",allCatagories,allCatagories.count);
        if([allCatagories count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngStateServiceURL,userTeamID, playerID, mode] serviceType:@"chalStateService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_CategoryService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"chalStateService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_CategoryService) {
            self.SyncStatus = SyncFromServerState_CalStatService;
        }
        NSArray *allStates = [DataFetcherHelper getAllScoreStatesDataFromDict:recieveDataDict];
        
        
        NSLog(@"Details For States = %@ And Total : %lu",allStates, (unsigned long)allStates.count);
        NSLog(@"testchallengestats, %@", recieveDataDict);
        if([allStates count] == [recieveDataDict count])
        {  
            [self loadDataRecordsWithURL:[NSString stringWithFormat:journalEntry ,userTeamID, playerID, mode] serviceType:@"journalEntry" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_CalStatService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }

    else if([callServiceFor isEqualToString:@"journalEntry"])
    {
        
        if (self.SyncStatus == SyncFromServerState_CalStatService) {
            self.SyncStatus = SyncFromServerState_JournalService;
        }
        NSArray *allJournal = [DataFetcherHelper getAllJournalDataFromDict:recieveDataDict];
        //NSLog(@"Details For States = %@ And Total : %d",allStates,allStates.count);
        if([allJournal count] == [recieveDataDict count])
        {
            [self loadDataRecordsWithURL:[NSString stringWithFormat:chalngImageServiceURL,userTeamID, playerID, mode] serviceType:@"chalImageService" withTeamID:userTeamID syncCount:cnt playerID:playerID mode:mode];
            
            if (self.SyncStatus == SyncFromServerState_JournalService) {
                [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
                [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
    else if([callServiceFor isEqualToString:@"chalImageService"])
    {
        
        if (self.SyncStatus == SyncFromServerState_JournalService) {
            self.SyncStatus = SyncFromServerState_ChalImgaeService;
        }
        NSArray *allImages = [DataFetcherHelper getAllChallangeImageDataFromDict:recieveDataDict];
        
//        [valuesDictionary setObject:[NSNumber numberWithInt:syncCount] forKey:PROGRESS_VALUE];
//        [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];

        //NSLog(@"Details For CategoryImages = %@ And Total : %d",allImages,allImages.count);
        //sleep(300);
        if([allImages count] == [recieveDataDict count])
        {
            
            
//            NSLog(@"Everything is Complete call Process Complete Delegate");
            if([delegate respondsToSelector:@selector(syncFromServerProcessCompleted)])
            {
                completeSyncCount++;
                
                
                if (self.SyncStatus == SyncFromServerState_ChalImgaeService) {
                    [valuesDictionary setObject:[NSNumber numberWithInt:syncCount + 2 * cnt + 1] forKey:PROGRESS_VALUE];
                    [valuesDictionary setObject:[NSNumber numberWithInteger:totalServiceCount] forKey:TOTAL_VALUE];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KEYVALUE object:self userInfo:valuesDictionary];
                   
                }

                if (completeSyncCount == cnt) {
                    
                    NSLog(@"startSync9, %d", syncCount);
                    
                    [delegate syncFromServerProcessCompleted];
                }
                
            }
        }
        else
        {
            totalServiceCount = totalServiceCount-1;
        }
    }
}

-(void)removeAllDataFromLocalDataBaseBeforeSync
{
    [self removeAllTableDataAfterLoginWithTableName:@"PlayersInfo"];
    [self removeAllTableDataAfterLoginWithTableName:@"TeamInfo"];
    [self removeAllTableDataAfterLoginWithTableName:@"Challanges"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallengeCategory"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallengeImage"];
    [self removeAllTableDataAfterLoginWithTableName:@"ChallangeStat"];
    [self removeAllTableDataAfterLoginWithTableName:@"JournalData"];
}

-(void)removeCurrentTeamDataFromLocalDataBaseBeforeSync:(int)teamId {
    
    [self deleteInDatabase:@"PlayersInfo" where:teamId];
    [self deleteInDatabase:@"TeamInfo" where:teamId];
    [self deleteInDatabase:@"Challanges" where:teamId];
    [self deleteInDatabase:@"ChallengeCategory" where:teamId];
//    [self removeAllTableDataAfterLoginWithTableName:@"ChallengeImage"];
    [self deleteInDatabase:@"ChallangeStat" where:teamId];
    [self deleteInDatabase:@"JournalData" where:teamId];
    
    [self removeChallengeImage:teamId];
    
}

-(void)removeChallengeImage:(int)teamId {
    NSString *selectQuery;
    selectQuery = [NSString stringWithFormat:@"SELECT ID FROM Challanges WHERE TeamID=%d", teamId];
    
    NSArray *challengeIds = [SCSQLite selectRowSQL:selectQuery];
    
//    NSLog(@"challengesId, %@", challengeIds);
    
}

- (void)deleteInDatabase:(NSString *)table where:(int)teamId {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSDictionary *whereDic = @{@"TeamID": String(teamId)};
    
//    [SCSQLite initWithDatabase:database];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", table, [self whereCaluseString:whereDic]];
    BOOL result = [SCSQLite executeSQL: sql];
    
    if(result)
    {
        NSLog( @"Succsefully Deleted selected Table : %@",table);
    }
    
}

- (NSString *)whereCaluseString:(NSDictionary *)dic {
    NSMutableArray *whereArr = [[NSMutableArray alloc] init];
    
    for (NSString * key in dic.allKeys) {
        [whereArr addObject:[NSString stringWithFormat:@"%@ = '%@'", key, dic[key]]];
    }
    NSString *whereStr = [whereArr componentsJoinedByString:@" AND "];
    
    return whereStr;
}


-(void)removeAllTableDataAfterLoginWithTableName:(NSString*)dbTableName
{
    BOOL success;
 
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *emptyTableQuery = [NSString stringWithFormat:@"DELETE FROM %@",dbTableName];
    success = [SCSQLite executeSQL:emptyTableQuery];
 
    if(success)
    {
//        NSLog( @"Succsefully Deleted Table : %@",dbTableName);
    }
}

@end
