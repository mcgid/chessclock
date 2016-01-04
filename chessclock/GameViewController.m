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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
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
    }

    return self;
}

- (void)viewDidLoad
{
    self.game = [[DMGame alloc] initWithView:(DMGameView *)self.view];
}

#pragma mark -
#pragma mark App Lifecycle

- (void)finishLaunching
{
    [self.game enterState:[DMLoadingState class]];

    // Future feature: Saved game
    // At this point, we can check for a saved game. If we find
    // one, we can then transition to its saved state from Loading.
    // That's the reason for these weird consecutive enterState: calls -- the
    // Loading state exits so that when there is machinery for saving game,
    // there's a logical interface transition path.

    [self.game enterState:[DMNewGameState class]];
}

- (void)resignActive
{
    if ([[self.game state] isSubclassOfClass:[DMTurnState class]]) {
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
    if ([self.game.state isSubclassOfClass:[DMTurnState class]]) {
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
