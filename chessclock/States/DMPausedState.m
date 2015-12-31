//
//  DMPausedState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMPausedState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([previousState isKindOfClass:[DMLoadingState class]]) {
        // Show the player times, disabled
        [self.game.view disableWhiteButton];
        [self.game.view disableBlackButton];

        // Show the reset and resume buttons
        [self.game.view showPauseButton];
        [self.game.view showResetButton];
    } else if ([previousState isKindOfClass:[DMConfirmResetState class]]) {
        [self.game.view showPauseButton];
        [self.game.view showResetButton];
    }

    // Change the label of the pause button to 'resume'
    [self.game.view selectPauseButton];

    [self.game.view enableResetButton];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMConfirmResetState class]]) {
        [self.game.view hidePauseButton];
        [self.game.view hideResetButton];
    } else if ([nextState isKindOfClass:[DMTurnState class]]) {
        // Change the label of the pause button back to 'pause'
        [self.game.view deselectPauseButton];

        [self.game.view disableResetButton];
    }
}

@end