//
//  Card.m
//  Machismo
//
//  Created by Ryan Sullivan on 1/28/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)description
{
    return self.contents;
}

/*

@synthesize faceUp = _faceUp;
@synthesize unplayable = _unplayable;
- (BOOL)isFaceUp
{
    return _faceUp;
}
- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
}

-(BOOL)isUnplayable
{
    return _unplayable;
}
- (void)setUnplayable:(BOOL)unplayable
{
    _unplayable = unplayable;
}
*/

@end
