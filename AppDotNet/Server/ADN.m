//
//  ADN.m
//  AppDotNet
//
//  Created by Me on 12/15/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADN.h"

#import "ASIHTTPRequest.h"
#import "ADNHelper.h"

#define API_HOST @"alpha-api.app.net"
#define API_BASE @"/stream/0/"


@implementation ADN



+ (void)getUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSString *endpoint = [NSString stringWithFormat:@"users/%@", usernameOrID];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@", API_HOST, API_BASE, endpoint];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request_weak = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request_weak responseString];
        //NSLog(@"%@", responseString);
        
        // Use when fetching binary data
        NSData *responseData = [request_weak responseData];
        
        NSDictionary *responseEnvelope;
        NSDictionary *userDictionary;
        if ((responseEnvelope = [ADNHelper dictionaryFromJSONData:responseData])) {
            if((userDictionary = [ADNHelper responseDataFromEnvelope:responseEnvelope])) {
                ADNUser *user = [ADNUser userFromDictionary:userDictionary];
                
                if (handler) {
                    handler(user, nil);
                }
            
            } else {
                if (handler) {
                    NSError *error = [NSError errorWithDomain:@"ADN" code:0 userInfo:[NSDictionary dictionaryWithObject:@"ADN Error" forKey:NSLocalizedDescriptionKey]];
                    handler(nil, error);
                }
            }
        } else {
            if (handler) {
                NSError *error = [NSError errorWithDomain:@"JSON" code:0 userInfo:[NSDictionary dictionaryWithObject:@"JSON Error" forKey:NSLocalizedDescriptionKey]];
                handler(nil, error);
            }
        }

    }];
    [request setFailedBlock:^{
        NSLog(@"Error: %@", [[request_weak error] localizedDescription]);
        if (handler) {
            handler(nil, [request_weak error]);
        }

    }];
    
    //[request startAsynchronous];
    [request startSynchronous];
}

+ (void)getCurrentUserWithCompletionHandler:(ADNUserCompletionHandler)handler
{
    [self getUser:@"me" withCompletionHandler:handler];
}

+ (void)getUserWithID:(NSUInteger)userID completionHandler:(ADNUserCompletionHandler)handler
{
    [self getUser:[NSString stringWithFormat:@"%u", userID] withCompletionHandler:handler];
}

+ (void)getUserWithUsername:(NSString*)username completionHandler:(ADNUserCompletionHandler)handler
{
    if (![username hasPrefix:@"@"]) {
        username = [@"@" stringByAppendingString:username];
    }
    
    [self getUser:username withCompletionHandler:handler];
}

@end