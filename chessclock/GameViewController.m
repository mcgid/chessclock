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
#import "DMGameViewAnimator.h"

@interface GameViewController ()

@property (nonatomic) DMGameViewAnimator *gameViewAnimator;
@property(nonatomic, strong) DMGame *game;
@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) DMClockTime whiteDisplayedTime;
@property (nonatomic) DMClockTime blackDisplayedTime;

@end

@implementation GameViewController

#pragma mark Class Lifecycle

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
    self.gameViewAnimator = [[DMGameViewAnimator alloc] initWithView:(DMGameView *)self.view];
    self.game = [[DMGame alloc] initWithInterface:self.gameViewAnimator];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimes:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    ((DMGameView *)self.view).delegate = self;
    [(DMGameView*)self.view setUpSubviews];
}

- (void)dealloc
{
    // CADisplayLink retains its target, which in this case is self. Hello,
    // retain cycle. We need to invalidate it so that it releases its target and
    // the run loop releases the link.
    [_displayLink invalidate];
}

#pragma mark -
#pragma mark App Lifecycle

- (void)finishLaunching
{
    [self.game enterState:[DMLoadingState class]];

    // Future feature: Saving game state
    //
    // The Loading and NewGame states are separate because, when we are able to
    // save games, we will want to load directly into the saved state. We don't
    // want to animate any UI transition from the appearance in NewGame. If we
    // started in NewGame, we would display the UI in that state, and then have
    // to transition out of it. With the Loading state, we will easily be able
    // to transition directly to a different interface state without animation.
    //
    // That's the reason for these weird consecutive enterState: calls.
    // Eventually we'll deal with loading saved state here. It made sense to
    // design this in now, so that later changes to the overall design will be
    // relatively easy.

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
#pragma mark <DMTimeUpdating>

- (void)startUpdatingTime:(DMState *)sender
{
    self.displayLink.paused = NO;
}

- (void)stopUpdatingTime:(DMState *)sender
{
    self.displayLink.paused = YES;
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

- (void)updateTimes:(CADisplayLink *)sender
{

    DMClockTime whiteTime = [self.game.white remainingTime];
    DMClockTime blackTime = [self.game.black remainingTime];

    if (whiteTime.totalSeconds <= 0) {
        [self.game enterState:[DMWhiteLostState class]];
    } else if (whiteTime.minutes != self.whiteDisplayedTime.minutes ||
               whiteTime.seconds != self.whiteDisplayedTime.seconds) {
        [self.gameViewAnimator interfaceShouldUpdateWithWhiteTime:whiteTime];
        self.whiteDisplayedTime = whiteTime;
    }

    if (blackTime.totalSeconds <= 0) {
        [self.game enterState:[DMBlackLostState class]];
    } else if (blackTime.minutes != self.blackDisplayedTime.minutes ||
               blackTime.seconds != self.blackDisplayedTime.seconds) {
        [self.gameViewAnimator interfaceShouldUpdateWithBlackTime:blackTime];
        self.blackDisplayedTime = blackTime;
    }
}

@end
