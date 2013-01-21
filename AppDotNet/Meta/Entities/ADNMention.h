//
//  ADNMention.h
//  AppDotNet
//
//  Created by Me on 12/16/12.
//  Copyright (c) 2012 Matt Rubin. All rights reserved.
//

#import "ADNModel.h"


@interface ADNMention : ADNModel

// The username being mentioned (doesn't include '@').
@property (nonatomic, copy) NSString *username;
// The user id of the mentioned user.
@property (nonatomic, copy) NSString *userId;
// The 0 based index where this entity begins text (include @).
@property (nonatomic, assign) NSUInteger position;
// The length of the substring in text that represents this mention. Since @ is included, len will be the length of the name + 1.
@property (nonatomic, assign) NSUInteger length;

@end
