//
//  ADNClient.m
//  AppDotNet
//
//  Created by Me on 1/17/13.
//  Copyright (c) 2013 Matt Rubin. All rights reserved.
//

#import "ADNClient.h"
#import "ADNJSONRequestOperation.h"
#import "ADNImageRequestOperation.h"

@implementation ADNClient

+ (instancetype)sharedClient
{
    static ADNClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ADNClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://alpha-api.app.net/stream/0/"]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[ADNImageRequestOperation class]];
    [self registerHTTPOperationClass:[ADNJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (void)setAccessToken:(NSString *)accessToken
{
    _accessToken = [accessToken copy];
    
    if (_accessToken) {
        [self setDefaultHeader:@"Authorization"
                         value:[@"Bearer " stringByAppendingString:_accessToken]];
    } else {
        [self setDefaultHeader:@"Authorization"
                         value:nil];
    }
}

- (void)getEndpoint:(NSString *)path parameters:(NSDictionary *)parameters handler:(GenericCompletionHandler)handler
{
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (handler) {
            handler(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

- (ADNUser *)userFromResponse:(id)responseObject
{
    ADNUser *user = nil;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userFromResponse = [responseObject valueForKeyPath:@"data"];
        if ([userFromResponse isKindOfClass:[NSDictionary class]]) {
            user = [ADNUser instanceFromDictionary:userFromResponse];
        }
    }
    
    return user;
}


#pragma mark - Users

/*
 * Retrieve a User
 * GET /stream/0/users/[user_id]
 * http://developers.app.net/docs/resources/user/lookup/#retrieve-a-user
 */
- (void)getUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSString *endpoint = [NSString stringWithFormat:@"users/%@", usernameOrID];
    [self getPath:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        ADNUser *user = nil;
        NSDictionary *userFromResponse = [JSON valueForKeyPath:@"data"];
        
        if ([userFromResponse isKindOfClass:[NSDictionary class]]) {
            user = [ADNUser instanceFromDictionary:userFromResponse];
        }
        
        if (handler) {
            handler(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

- (void)getCurrentUserWithCompletionHandler:(ADNUserCompletionHandler)handler
{
    [self getUser:@"me" withCompletionHandler:handler];
}

- (void)getUserWithID:(NSUInteger)userID completionHandler:(ADNUserCompletionHandler)handler
{
    [self getUser:[NSString stringWithFormat:@"%u", userID] withCompletionHandler:handler];
}

- (void)getUserWithUsername:(NSString*)username completionHandler:(ADNUserCompletionHandler)handler
{
    if (![username hasPrefix:@"@"]) {
        username = [@"@" stringByAppendingString:username];
    }
    
    [self getUser:username withCompletionHandler:handler];
}


/*
 * Update a User
 * PUT /stream/0/users/me
 * http://developers.app.net/docs/resources/user/profile/#update-a-user
 */
- (void)updateUser:(ADNUser *)user withCompletionHandler:(ADNUserCompletionHandler)handler
{
    
}

/*
 * Retrieve a User's avatar image
 * GET /stream/0/users/[user_id]/avatar
 * http://developers.app.net/docs/resources/user/profile/#retrieve-a-users-avatar-image
 */
- (void)getAvatarImageForUser:(NSString*)usernameOrID withCompletionHandler:(UIImageCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/avatar", usernameOrID];
    [self getEndpoint:endpoint parameters:nil handler:handler];
}

/*
 * Update a User's avatar image
 * POST /stream/0/users/me/avatar
 * http://developers.app.net/docs/resources/user/profile/#update-a-users-avatar-image
 */
- (void)updateAvatarImage:(id)image withCompletionHandler:(GenericCompletionHandler)handler
{
    
}

/*
 * Retrieve a User's cover image
 * GET /stream/0/users/[user_id]/cover
 * http://developers.app.net/docs/resources/user/profile/#retrieve-a-users-cover-image
 */
- (void)getCoverImageForUser:(NSString*)usernameOrID withCompletionHandler:(UIImageCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/cover", usernameOrID];
    [self getEndpoint:endpoint parameters:nil handler:handler];
}

/*
 * Update a User's cover image
 * POST /stream/0/users/me/cover
 * http://developers.app.net/docs/resources/user/profile/#update-a-users-cover-image
 */
- (void)updateCoverImage:(id)image withCompletionHandler:(GenericCompletionHandler)handler
{
    
}

/*
 * Follow a User
 * POST /stream/0/users/[user_id]/follow
 * http://developers.app.net/docs/resources/user/following/#follow-a-user
 */
- (void)followUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/follow", usernameOrID];

    [self postPath:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ADNUser *user = [self userFromResponse:responseObject];
        
        if (handler) {
            handler(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

/*
 * Unfollow a User
 * DELETE /stream/0/users/[user_id]/follow
 * http://developers.app.net/docs/resources/user/following/#unfollow-a-user
 */
- (void)unfollowUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/follow", usernameOrID];
    
    [self deletePath:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ADNUser *user = [self userFromResponse:responseObject];
        
        if (handler) {
            handler(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

/*
 * Mute a User
 * POST /stream/0/users/[user_id]/mute
 * http://developers.app.net/docs/resources/user/muting/#mute-a-user
 */
- (void)muteUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/mute", usernameOrID];
    
    [self postPath:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ADNUser *user = [self userFromResponse:responseObject];
        
        if (handler) {
            handler(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}

/*
 * Unmute a User
 * DELETE /stream/0/users/[user_id]/mute
 * http://developers.app.net/docs/resources/user/muting/#unmute-a-user
 */
- (void)unmuteUser:(NSString*)usernameOrID withCompletionHandler:(ADNUserCompletionHandler)handler
{
    NSAssert(usernameOrID, @"You must specify a username or ID.");
    NSString *endpoint = [NSString stringWithFormat:@"users/%@/mute", usernameOrID];
    
    [self deletePath:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ADNUser *user = [self userFromResponse:responseObject];
        
        if (handler) {
            handler(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (handler) {
            handler(nil, error);
        }
    }];
}


@end
