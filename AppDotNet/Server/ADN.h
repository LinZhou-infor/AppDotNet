//
//  ADN.h
//  AppDotNet
//
//  Created by Me on 12/15/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADNUser.h"


typedef void (^ADNUserCompletionHandler)(ADNUser *user, NSError *error);


@interface ADN : NSObject

+ (void)getCurrentUserWithCompletionHandler:(ADNUserCompletionHandler)handler;
+ (void)getUser:(NSString*)usernameOrID     withCompletionHandler:(ADNUserCompletionHandler)handler;
+ (void)getUserWithID:(NSUInteger)userID        completionHandler:(ADNUserCompletionHandler)handler;
+ (void)getUserWithUsername:(NSString*)username completionHandler:(ADNUserCompletionHandler)handler;

@end