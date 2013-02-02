//
//  CardGameViewController.m
//  Machismo
//
//  Created by Ryan Sullivan on 1/28/13.
//  Copyright (c) 2013 Ryan Sullivan. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastAction;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) UIImage *cardBackImage;
@property (nonatomic) UIEdgeInsets imageInsets;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameStateSegment;

//= UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0);
//button.titleEdgeInsets = titleInsets;


@end

@implementation CardGameViewController
- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    //if (sender.selectedSegmentIndex == 0) NSLog(@"2");
    //else NSLog(@"3");
    NSString *mode = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    NSLog(@"Changed Game Mode to: %@", mode);
    self.game.gameMode = [mode intValue];
}

- (CardMatchingGame *)game
{
    if (!_game) { _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                            usingDeck:[[PlayingCardDeck alloc] init]];}
    return _game;
}

- (UIImage *)cardBackImage
{
    if (!_cardBackImage) {
        _cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
    }
    return _cardBackImage;
}

- (UIEdgeInsets)imageInsets
{
    _imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    return _imageInsets;
}

- (IBAction)dealCards:(UIButton *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]
                                                 inGameMode:[[self.gameStateSegment titleForSegmentAtIndex:self.gameStateSegment.selectedSegmentIndex] intValue]];
    self.flipCount = 0;
    self.gameStateSegment.enabled = YES;
    [self updateUI];
}




- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.5 : 1.0;
        if (!cardButton.selected) {
            [cardButton setImage:self.cardBackImage forState:UIControlStateNormal];
            cardButton.imageEdgeInsets = self.imageInsets;
            //cardButton.backgroundColor = [UIColor darkGrayColor];
        }
            else { [cardButton setImage:nil forState:UIControlStateNormal]; }
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.lastAction.text = [self.game.gameLog lastObject];
    if (self.game.isGameOver) {
        for (UIButton *cardButton in self.cardButtons) { cardButton.enabled = NO; }
    }
    
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameStateSegment.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}


@end
