//
//  CardMatchingGame.h
//  Machismo
//
//  Created by Ryan Sullivan on 1/30/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck inGameMode:(int)mode;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (strong, nonatomic, readonly) NSMutableArray *gameLog; //of NSStrings
@property (nonatomic) int gameMode;
@property (nonatomic, readonly, getter = isGameOver) BOOL gameOver;

@end
