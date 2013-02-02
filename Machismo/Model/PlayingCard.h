//
//  PlayingCard.h
//  Machismo
//
//  Created by Ryan Sullivan on 1/28/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
