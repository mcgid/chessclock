//
//  DMGameViewAnimator.m
//  chessclock
//
//  Created by Dan on 2016-01-05.
//
//

#import "DMGameViewAnimator.h"

static const NSTimeInterval DMGameViewAnimatorAnimationDuration = 0.25;

@interface DMGameViewAnimator ()

- (void)animateAnimations:(void (^)(void))animations;

@end


@implementation DMGameViewAnimator

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithView:nil];
}

- (instancetype)initWithView:(DMGameView *)view
{
    self = [super init];

    if (self) {
        _view = view;
    }

    return self;
}

#pragma mark Internal animation methods

- (void)animateAnimations:(void (^)(void))animations
{
    [UIView animateWithDuration:DMGameViewAnimatorAnimationDuration
                     animations:animations];
}

#pragma mark From Loading state

// None of these methods use -animateAnimations: because all changes should
// happen before the interface appears on screen when loading.


- (void)transitionFromLoadingToNewGame
{
    [self.view showTimesButton];
    [self.view enableWhiteButton];
    [self.view disableBlackButton];
    [self.view showStartGameLabel];
}

- (void)transitionFromLoadingToSettings
{
    [self.view showTimesButton];
    [self.view selectTimesButton];
    [self.view showSliders];
    [self.view enableBlackButton];
    [self.view disablePlayerButtonInteraction];
}

- (void)transitionFromLoadingToPaused
{
    [self.view disableWhiteButton];
    [self.view disableBlackButton];
    [self.view showPauseButton];
    [self.view selectTimesButton];
    [self.view showResetButton];
    [self.view enableBlackButton];
}

- (void)transitionFromLoadingToConfirmReset
{
    [self.view showConfirmResetArea];
}

- (void)transitionFromLoadingToWhiteLost
{
    [self.view showPauseButton];
    [self.view disablePauseButton];
    [self.view showResetButton];
    [self.view enableResetButton];
    [self.view makeWhiteButtonWinner];
}

- (void)transitionFromLoadingToBlackLost
{
    [self.view showPauseButton];
    [self.view disablePauseButton];
    [self.view showResetButton];
    [self.view enableResetButton];
    [self.view makeBlackButtonWinner];
}


#pragma mark From NewGame state

- (void)transitionFromNewGameToSettings
{
    // May need to add layoutIfNeeded inside -selectTimesButton (and others)
    [self.view selectTimesButton];

    [self.view disablePlayerButtonInteraction];

    [self animateAnimations:^{
        [self.view hideStartGameLabel];
        [self.view showSliders];
        [self.view enableBlackButton];
    }];
}

- (void)transitionFromNewGameToWhiteTurn
{
    // TODO: Is this animatable or not? Should it go in the block?
    // If not, should '-enableBlackButton' in the above method be in that block
    // or not? I always put the enable/disable calls in the blocks in the old
    // version, but that's no guarantee of anything.
    [self.view disableResetButton];

    [self animateAnimations:^{
        [self.view hideTimesButton];
        [self.view showPauseButton];
        [self.view showResetButton];
        [self.view enableWhiteButton];
    }];
}


#pragma mark From Settings state

- (void)transitionFromSettingsToNewGame
{
    [self.view deselectTimesButton];

    [self.view disablePlayerButtonInteraction];

    [self animateAnimations:^{
        [self.view showStartGameLabel];
        [self.view hideSliders];
        [self.view disableBlackButton];
    }];
}


#pragma mark From WhiteTurn state

- (void)transitionFromWhiteTurnToWhiteLost
{
    [self animateAnimations:^{
        [self.view hidePauseButton];
        [self.view enableResetButton];
        [self.view enableWhiteButton];
        [self.view enableBlackButton];
        [self.view makeWhiteButtonWinner];
    }];
}

- (void)transitionFromWhiteTurnToPaused
{
    [self.view selectPauseButton];

    [self animateAnimations:^{
        [self.view disableWhiteButton];
        [self.view enableResetButton];
    }];
}

- (void)transitionFromWhiteTurnToBlackTurn
{
    [self animateAnimations:^{
        [self.view disableWhiteButton];
        [self.view enableBlackButton];
    }];
}


#pragma mark From BlackTurn state

- (void)transitionFromBlackTurnToBlackLost
{
    [self animateAnimations:^{
        [self.view hidePauseButton];
        [self.view enableResetButton];
        [self.view enableWhiteButton];
        [self.view enableBlackButton];
        [self.view makeBlackButtonWinner];
    }];
}

- (void)transitionFromBlackTurnToPaused
{
    [self.view selectPauseButton];

    [self animateAnimations:^{
        [self.view disableBlackButton];
        [self.view enableWhiteButton];
    }];
}

- (void)transitionFromBlackTurnToWhiteTurn
{
    [self animateAnimations:^{
        [self.view disableBlackButton];
        [self.view enableWhiteButton];
    }];
}


#pragma mark From Paused state
// TODO: Deal with the isFirstTurn label situation
- (void)transitionFromPausedToWhiteTurn
{
    [self.view deselectPauseButton];
    [self.view disableResetButton];

    [self animateAnimations:^{
        [self.view enableWhiteButton];
    }];
}

- (void)transitionFromPausedToBlackTurn
{
    [self.view deselectPauseButton];
    [self.view disableResetButton];

    [self animateAnimations:^{
        [self.view enableBlackButton];
    }];
}

- (void)transitionFromPausedToConfirmReset
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view hidePauseButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark From WhiteLost state

- (void)transitionFromWhiteLostToConfirmReset
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark From WhiteLost state

- (void)transitionFromBlackLostToConfirmReset
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark From ConfirmReset state

- (void)transitionFromConfirmResetToWhiteLost
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
    }];
}

- (void)transitionFromConfirmResetToBlackLost
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
    }];
}

- (void)transitionFromConfirmResetToPaused
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
        [self.view showPauseButton];
    }];
}

- (void)transitionFromConfirmResetToNewGame
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showTimesButton];
        [self.view resetPlayerButtonColors];
        [self.view enableWhiteButton];
        [self.view disableBlackButton];
        [self.view showStartGameLabel];
    }];
}


@end
