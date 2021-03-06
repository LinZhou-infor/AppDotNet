//
//  ADNAuthenticationRequest.h
//  AppDotNet
//
//  Created by Matt Rubin on 12/17/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    ADNAuthenticationResponseTypeCode,
    ADNAuthenticationResponseTypeToken
} ADNAuthenticationResponseType;


// http://developers.app.net/docs/authentication/#scopes
typedef enum {
    ADNScopeNone            = 0,
    ADNScopeBasic           = (1 << 0), // see basic information about this user
    ADNScopeStream          = (1 << 1), // read this user’s stream
    ADNScopeEmail           = (1 << 2), // access this user’s email address
    ADNScopeWritePost       = (1 << 3), // create a new post as this user
    ADNScopeFollow          = (1 << 4), // add or remove follows (or mutes) for this user
    ADNScopePublicMessages  = (1 << 5), // send and receive public messages as this user
    ADNScopeMessages        = (1 << 6), // send and receive public and private messages as this user
    ADNScopeUpdateProfile   = (1 << 7), // update a user’s name, images, and other profile information
    ADNScopeFiles           = (1 << 8), // manage a user’s files. This is not needed for uploading files.
    ADNScopeExport          = (1 << 9), // bulk export all of this user’s App.net data
} ADNScopes;


/**
 * This is a helper class for generating the authentication URL used in the client authentication flow.
 * http://developers.app.net/docs/authentication/flows/web/#client-side-flow
 *
 * To make use of this class, create an ADNAuthenticationRequest and set the required properties.
 * Then present the user with a web view which loads the NSURL provided by the ADNAuthenticationRequest -URL method.
 */
@interface ADNAuthenticationRequest : NSObject

@property NSString *clientId;
@property ADNAuthenticationResponseType responseType;
@property NSString *redirectURI;
@property ADNScopes scopes;
@property NSString *state;
@property BOOL appStoreCompliant;

/// The authentication URL for the client-side flow
- (NSURL*)URL;

/// Returns a comma-separated string containing the scopes included in the ADNScopes bitmask
+ (NSString*)stringForScopes:(ADNScopes)scopes;
+ (NSString*)stringForResponseType:(ADNAuthenticationResponseType)responseType;

@end
