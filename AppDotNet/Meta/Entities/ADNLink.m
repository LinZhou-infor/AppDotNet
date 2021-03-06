//
//  ADNLink.m
//  AppDotNet
//
//  Created by Matt Rubin on 12/16/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNLink.h"


@implementation ADNLink

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"length": ADNFieldLength,
            @"amendedLength": ADNFieldAmendedLength,
            @"position": ADNFieldPosition,
            }];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[%@: %@ (%u @ %u) <%@>]", self.class, self.text, (unsigned)self.length, (unsigned)self.position, self.url];
}

+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
