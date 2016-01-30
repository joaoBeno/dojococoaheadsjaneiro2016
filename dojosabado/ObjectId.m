//
//  ObjectId.m
//  mongoclientios
//
//  Created by Jose Lino Neto on 1/2/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import "ObjectId.h"

@implementation ObjectId

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"$oid": @"Id"
                                                       }];
}

@end
