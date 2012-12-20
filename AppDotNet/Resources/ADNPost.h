//
//  ADNPost.h
//  AppDotNet
//
//  Created by Me on 12/14/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNObject.h"

#import "ADNUser.h"


@interface ADNPost : ADNObject

// Primary identifier for a post.
@property NSInteger postID;

// The associated User object. Note: In certain cases (e.g., when a user account has been deleted), this key may be omitted.
@property ADNUser *user;
// The time at which the post was created.
@property NSDate  *createdAt;


// User supplied text of the post.
@property NSString *text;
// Server-generated annotated HTML rendering of post text.
@property NSString *html;


// Description of the API consumer that created this post.
@property NSString *sourceName;
// Link provided by the API consumer that created this post.
@property NSString *sourceLink;


// The id of the post this post is replying to (or null if not a reply).
@property NSInteger replyTo;
// The URL of the post's detail page on Alpha.
@property NSString *canonicalURL;
// The id of the post at the root of the thread that this post is a part of. If thread_id==id than this property does not guarantee that the thread has > 1 post. Please see num_replies.
@property NSInteger threadID;


// The number of posts created in reply to this post.
@property NSUInteger numReplies;
// The number of users who have starred this post.
@property NSUInteger numStars;
// The number of users who have reposted this post.
@property NSUInteger numReposts;


// Metadata about the entire post. See the Annotations documentation.
@property NSDictionary *annotations;
// Rich text information for this post. See the Entities documentation.
@property NSDictionary *entities;


// Has this post been deleted? For non-deleted posts, this key may be omitted instead of being false. If a post has been deleted, the text, html, and entities properties will be empty and may be omitted.
@property BOOL isDeleted;
// Is this Post meant for humans or other apps? See [Machine only Posts] for more information.
@property BOOL machineOnly;


// Have you starred this Post? May be omitted if this is not an authenticated request.
@property BOOL youStarred;
// A partial list of users who have starred this post. This is not comprehensive and is meant to be a sample of users who have starred this post giving preference to users the current user follows. This is only included if `include_starred_by=1` is passed to App.net. May be omitted if this is not an authenticated request.
@property NSArray *starredBy;


// Have you reposted this Post? May be omitted if this is not an authenticated request.
@property BOOL youReposted;
// A partial list of users who have reposted this post. This is not comprehensive and is meant to be a sample of users who have starred this post giving preference to users the current user follows. This is only included if `include_reposters=1` is passed to App.net. May be omitted if this is not an authenticated request.
@property NSArray *reposters;


// If this post is a repost, this key will contain the complete original Post.
@property ADNPost *repostOf;

@end
