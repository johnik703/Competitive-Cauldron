//
//  JSONHelper.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "JSONHelper.h"
@import SVProgressHUD;

@implementation JSONHelper

+ (NSDictionary *)loadJSONDataFromURL:(NSString *)urlString {
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"stats url %@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];

//    NSLog(@"statsurl for stats syncDictionary data%@--", data);
    if (!data) {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }



    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }

    return dictionary;
}

+ (NSDictionary *)loadJSONDataFromURLForSync:(NSString *)urlString {
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    __block NSError *errorSync;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    
    __block NSData *dataSync;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dataSync = data;
        errorSync = error;
    }] resume];
    
//    NSLog(@"statsurl for stats syncDictionary data%@--", dataSync);
    if (!dataSync) {
        NSLog(@"Download Error: %@", errorSync.localizedDescription);
        return nil;
    }
    
    
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:dataSync options:kNilOptions error:&errorSync];
    
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", errorSync);
        return nil;
    }
    
    return dictionary;
}


+ (NSArray *)loadJSONDataFromURLArray:(NSString *)urlString {
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    
    
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}
@end
