//
//  DMViewController.m
//  chessclock
//
//  Created by Dan McGinnis on 12-02-25.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import "GameViewController.h"

#import "DMClock.h"
#import "DMGame.h"
#import "DMStates.h"

@interface GameViewController ()

@property(nonatomic, strong) DMGame *game;

@end

@implementation GameViewController

#pragma mark Initialization

/**
 * Initialize properties not related to the view
 *
 * Why awakeFromNib and not initWithCoder or another init*?
 *
 * initWithCoder is the designated initializer for UIViewController, so it's the
 * flavour of init* to use. Apparently, though, it may not be safe to use
 * accessors in initWithCoder (see http://stackoverflow.com/a/15508256).
 * 
 * This stuff could also be done in viewDidLoad, but that feels gross.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];

    // Get notified in order to move game to Loading state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishLaunching)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];

    // Get notified to pause game
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    self.game = [[DMGame alloc] initWithView:(DMGameView *)self.view];
}

#pragma mark -
#pragma mark App Lifecycle

- (void)finishLaunching
{
    [self.game enterState:[DMLoadingState class]];
}

- (void)resignActive
{
    if ([[self.game state] isKindOfClass:[DMTurnState class]]) {
        [self.game pushState:[DMPausedState class]];
    }
}

#pragma mark -
#pragma mark <DMGameViewDelegate>

- (void)whiteTimeLimitDidChange:(DMClockTime)time
{
    [self.game setWhiteTimeLimit:time.totalSeconds];
}

- (void)blackTimeLimitDidChange:(DMClockTime)time
{
    [self.game setBlackTimeLimit:time.totalSeconds];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)toggleTimes:(id)sender {
    if (self.game.state == [DMNewGameState class]) {
        [self.game enterState:[DMSettingsState class]];
    } else if (self.game.state == [DMSettingsState class]) {
        [self.game enterState:[DMNewGameState class]];
    }
}

- (IBAction)togglePaused:(id)sender {
    if ([self.game.state isKindOfClass:[DMTurnState class]]) {
        [self.game pushState:[DMPausedState class]];
    } else if (self.game.state == [DMPausedState class]) {
        [self.game popState];
    }
}

- (IBAction)toggleReset:(id)sender
{
    [self.game pushState:[DMConfirmResetState class]];
}

- (IBAction)confirmReset:(id)sender
{
    [self.game enterState:[DMNewGameState class]];
}

- (IBAction)cancelReset:(id)sender
{
    [self.game popState];
}

- (IBAction)endWhiteTurn:(id)sender {
    if ([self.game state] == [DMNewGameState class]) {
        [self.game enterState:[DMWhiteTurnState class]];
    } else if ([self.game state] == [DMWhiteTurnState class]) {
        [self.game enterState:[DMBlackTurnState class]];
    }
}

- (IBAction)endBlackTurn:(id)sender {
    if ([self.game state] == [DMBlackTurnState class]) {
        [self.game enterState:[DMWhiteTurnState class]];
    }
}

@end
