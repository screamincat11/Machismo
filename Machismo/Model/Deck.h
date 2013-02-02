//
//  Deck.h
//  Machismo
//
//  Created by Ryan Sullivan on 1/28/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
