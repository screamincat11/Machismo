//
//  PlayingCard.m
//  Machismo
//
//  Created by Ryan Sullivan on 1/28/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// This method only works for 1 or 2 cards in the otherCards NSArray
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        PlayingCard *otherCard = otherCards[0];
        PlayingCard *anotherCard = otherCards[1];
        if ([otherCard.suit isEqualToString:self.suit] && [anotherCard.suit isEqualToString:self.suit]) {
            return 3; //3 suits match
        } else if (otherCard.rank == self.rank && anotherCard.rank == self.rank) {
            return 4;  //3 rank match -- hard to do!
        } else if ((otherCard.rank == self.rank) | (anotherCard.rank == self.rank | otherCard.rank == anotherCard.rank)) {
            return 2; // 2 rank match - medium difficulty
        } else if ([otherCard.suit isEqualToString:self.suit] | [anotherCard.suit isEqualToString:self.suit] | [anotherCard.suit isEqualToString:otherCard.suit]) {
            return 1; //2 suits match -- super easy
        }
   }
            
    return  score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
