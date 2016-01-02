//
//  DMSettingsState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMSettingsState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([previousState isKindOfClass:[DMLoadingState class]]) {
        [self.game.view showTimesButton];
    }

    [self.game.view selectTimesButton];
    [self.game.view showSliders];
    [self.game.view enableBlackButton];
    [self.game.view hideStartGameLabel];

    [self.game.view disablePlayerButtonInteraction];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [self.game.view enablePlayerButtonInteraction];

    [self.game.view showStartGameLabel];
    [self.game.view disableBlackButton];
    [self.game.view hideSliders];
    [self.game.view deselectTimesButton];
}

@end