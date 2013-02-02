//
//  CardMatchingGame.m
//  Machismo
//
//  Created by Ryan Sullivan on 1/30/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) BOOL gameOver;
@property (strong, nonatomic, readwrite) NSMutableArray *gameLog; //of NSString
@property (strong, nonatomic) NSMutableArray *potentialMatches; //of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) { _cards = [[NSMutableArray alloc] init]; }
    return _cards;
}
- (NSMutableArray *)potentialMatches
{
    if (!_potentialMatches) { _potentialMatches = [[NSMutableArray alloc] init]; }
    return _potentialMatches;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    self.gameLog = [[NSMutableArray alloc] init];
    //[self.gameLog addObject:@"Starting Game..."];
    self.gameOver = NO;
    self.gameMode = 2; //this is overwritten in the convenience init
    return self;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck inGameMode:(int)mode
{
    self = [self initWithCardCount:count usingDeck:deck];
    if (self) {
        self.gameMode = mode;
    }
    return self;
}

- (void)setGameMode:(int)gameMode //defaults to 2
{
    if (gameMode >= 2 && gameMode <= 3) {
        _gameMode = gameMode;
    }
    else {
        _gameMode = 2;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<self.cards.count) ? self.cards[index] : nil;
}

- (NSMutableArray *)gameLog
{
    if (!_gameLog) { _gameLog = [[NSMutableArray alloc] init]; }
    return _gameLog;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable && !self.isGameOver) {
        if (!card.isFaceUp) {
            [self.gameLog addObject:[NSString stringWithFormat:@"Flipped up %@.", card.contents]];
            // matching here
            [self.potentialMatches removeAllObjects]; //reset potentialMatches
            for (Card *otherCard in self.cards) {

                if (self.gameMode == 2) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            [self.gameLog addObject:[NSString stringWithFormat:@"Matched %@ & %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS]];
                            //NSLog(@"Matched %@ & %@ for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS);
                            //NSLog(@"Game Log: %@", self.gameLog);
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            [self.gameLog addObject:[NSString stringWithFormat:@"%@ & %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY]];
                            //NSLog(@"%@ & %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY);
                        }
                        break;
                    }
                } else if (self.gameMode == 3) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        [self.potentialMatches addObject:otherCard];
                    }
                    if ([self.potentialMatches count] == 2) {
                        NSLog(@"Potential Matches");
                        NSLog(@"Flip Card: %@", card);
                        for (Card *logCard in self.potentialMatches) { NSLog(@"Card: %@", logCard); }
                        int matchScore = [card match:self.potentialMatches];
                        if(matchScore) {
                            for (Card *matchCard in self.potentialMatches) { matchCard.unplayable = YES; }
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            [self.gameLog addObject:[NSString stringWithFormat:@"Matched %@, %@, & %@ for %d points!", ((Card *)self.potentialMatches[0]).contents, ((Card *)self.potentialMatches[1]).contents, card.contents, matchScore * MATCH_BONUS]];
                       } else {
                            for (Card *matchCard in self.potentialMatches) { matchCard.faceUp = NO; }
                            self.score -= MISMATCH_PENALTY;
                            [self.gameLog addObject:[NSString stringWithFormat:@"%@, %@, & %@ don't match! %d point penalty!", ((Card *)self.potentialMatches[0]).contents, ((Card *)self.potentialMatches[1]).contents, card.contents, MISMATCH_PENALTY]];
                       }
                        break;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.isFaceUp;
    }
    //NSLog(@"Game Log: %@", self.gameLog);
    self.gameOver = ![self matchesLeft];
    if (self.isGameOver) {
        [self.gameLog addObject:@"Game Over!"];
    }
}

- (BOOL)matchesLeft
{
    BOOL matches = NO;
    int score = 0;
    if (self.gameMode == 2) {
        //
        for (Card *card1 in self.cards) {
            for (Card *card2 in self.cards) {
                if (!card1.isUnplayable && !card2.isUnplayable && card1!=card2) {
                    score += [card1 match:@[card2]];
                }
            }
        }
        if (score) { matches = YES; }
    } else if (self.gameMode == 3){
        // triple-nested for loop! Not the most efficient way I'm sure.  
        for (Card *card1 in self.cards) {
            for (Card *card2 in self.cards) {
                for (Card *card3 in self.cards) {
                    if (!card1.isUnplayable && !card2.isUnplayable && !card3.isUnplayable && card1!=card2 && card1!=card3) {
                    score += [card1 match:@[card2,card3]];
                    }
                }
            }
        }
        if (score) { matches = YES; }
    }
    return matches;
}

@end
