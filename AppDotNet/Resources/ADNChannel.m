//
//  ADNChannel.m
//  AppDotNet
//
//  Created by Me on 12/15/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNChannel.h"


#define CHANNEL_KEY_ID                  @"id"
#define CHANNEL_KEY_TYPE                @"type"
#define CHANNEL_KEY_OWNER               @"owner"
#define CHANNEL_KEY_ANNOTATIONS         @"annotations"
#define CHANNEL_KEY_READERS             @"readers"
#define CHANNEL_KEY_WRITERS             @"writers"
#define CHANNEL_KEY_YOU_SUBSCRIBED      @"you_subscribed"
#define CHANNEL_KEY_YOU_CAN_EDIT        @"you_can_edit"
#define CHANNEL_KEY_HAS_UNREAD          @"has_unread"
#define CHANNEL_KEY_RECENT_MESSAGE_ID   @"recent_message_id"


@implementation ADNChannel

#pragma mark Initilaization

- (id)init
{
    self = [super init];
    if (self) {
        self.annotations = [ADNAnnotationCollection new];
    }
    return self;
}

- (NSSet *)conversionKeys
{
    return [NSSet setWithArray:@[CHANNEL_KEY_ANNOTATIONS, CHANNEL_KEY_OWNER, CHANNEL_KEY_READERS, CHANNEL_KEY_WRITERS]];
}

- (NSDictionary *)alteredKeys
{
    return @{CHANNEL_KEY_HAS_UNREAD:@"hasUnread", CHANNEL_KEY_ID:@"channelID", CHANNEL_KEY_YOU_CAN_EDIT:@"youCanEdit", CHANNEL_KEY_YOU_SUBSCRIBED:@"youSubscribed", CHANNEL_KEY_RECENT_MESSAGE_ID:@"recentMessageID"};
}


#pragma mark Export

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.channelID)
        [dictionary setObject:self.channelID       forKey:CHANNEL_KEY_ID];
    if (self.type)
        [dictionary setObject:self.type            forKey:CHANNEL_KEY_TYPE];
    if (self.recentMessageID)
        [dictionary setObject:self.recentMessageID forKey:CHANNEL_KEY_RECENT_MESSAGE_ID];
    
    [dictionary setObject:[NSNumber numberWithBool:self.hasUnread]     forKey:CHANNEL_KEY_HAS_UNREAD];
    [dictionary setObject:[NSNumber numberWithBool:self.youCanEdit]    forKey:CHANNEL_KEY_YOU_CAN_EDIT];
    [dictionary setObject:[NSNumber numberWithBool:self.youSubscribed] forKey:CHANNEL_KEY_YOU_SUBSCRIBED];
    
    if (self.owner)
        [dictionary setObject:self.owner.toDictionary forKey:CHANNEL_KEY_OWNER];
    if (self.readers)
        [dictionary setObject:self.readers.toDictionary forKey:CHANNEL_KEY_READERS];
    if (self.writers)
        [dictionary setObject:self.writers.toDictionary forKey:CHANNEL_KEY_WRITERS];
    if (self.annotations)
        [dictionary setObject:self.annotations.toArray forKey:CHANNEL_KEY_ANNOTATIONS];
    
    return dictionary;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@ #%i: %@, @%@]", self.class, [self.channelID intValue], self.type, self.owner.username];
}

@end
