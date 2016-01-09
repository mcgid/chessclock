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

#pragma mark -
#pragma mark Internal animation methods

- (void)animateAnimations:(void (^)(void))animations
{
    // Force pending layout operations before any frame changes in the animations
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:DMGameViewAnimatorAnimationDuration
                     animations:animations];
}

#pragma mark -
#pragma mark <DMInterfaceTransitioning>

#pragma mark From Loading state

// None of these methods use -animateAnimations: because all changes should
// happen before the interface appears on screen when loading.


- (void)interfaceShouldTransitionFromLoadingToNewGame:(id)sender
{
    [self.view showTimesButton];
    [self.view enableWhiteButton];
    [self.view disableBlackButton];
    [self.view showStartGameLabel];
}

- (void)interfaceShouldTransitionFromLoadingToSettings:(id)sender
{
    [self.view showTimesButton];
    [self.view selectTimesButton];
    [self.view showSliders];
    [self.view enableBlackButton];
    [self.view disablePlayerButtonInteraction];
}

- (void)interfaceShouldTransitionFromLoadingToPaused:(id)sender
{
    [self.view disableWhiteButton];
    [self.view disableBlackButton];
    [self.view showPauseButton];
    [self.view selectTimesButton];
    [self.view showResetButton];
    [self.view enableBlackButton];
}

- (void)interfaceShouldTransitionFromLoadingToConfirmReset:(id)sender
{
    [self.view showConfirmResetArea];
}

- (void)interfaceShouldTransitionFromLoadingToWhiteLost:(id)sender
{
    [self.view showPauseButton];
    [self.view disablePauseButton];
    [self.view showResetButton];
    [self.view enableResetButton];
    [self.view makeWhiteButtonWinner];
}

- (void)interfaceShouldTransitionFromLoadingToBlackLost:(id)sender
{
    [self.view showPauseButton];
    [self.view disablePauseButton];
    [self.view showResetButton];
    [self.view enableResetButton];
    [self.view makeBlackButtonWinner];
}


#pragma mark From NewGame state

- (void)interfaceShouldTransitionFromNewGameToSettings:(id)sender
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

- (void)interfaceShouldTransitionFromNewGameToWhiteTurn:(id)sender
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
        [self.view hideStartGameLabel];
    }];

    [self.view replaceStartGameLabelContent];

    [self animateAnimations:^{
        [self.view showStartGameLabel];
    }];
}


#pragma mark From Settings state

- (void)interfaceShouldTransitionFromSettingsToNewGame:(id)sender
{
    [self.view deselectTimesButton];

    [self.view enablePlayerButtonInteraction];

    [self animateAnimations:^{
        [self.view showStartGameLabel];
        [self.view hideSliders];
        [self.view disableBlackButton];
    }];
}


#pragma mark From Paused state
// TODO: Deal with the isFirstTurn label situation
- (void)interfaceShouldTransitionFromPausedToWhiteTurn:(id)sender
{
    [self.view deselectPauseButton];
    [self.view disableResetButton];

    [self animateAnimations:^{
        [self.view enableWhiteButton];
    }];
}

- (void)interfaceShouldTransitionFromPausedToBlackTurn:(id)sender
{
    [self.view deselectPauseButton];
    [self.view disableResetButton];

    [self animateAnimations:^{
        [self.view enableBlackButton];
    }];
}

- (void)interfaceShouldTransitionFromPausedToConfirmReset:(id)sender
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view hidePauseButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark From ConfirmReset state

- (void)interfaceShouldTransitionFromConfirmResetToWhiteLost:(id)sender
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
    }];
}

- (void)interfaceShouldTransitionFromConfirmResetToBlackLost:(id)sender
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
    }];
}

- (void)interfaceShouldTransitionFromConfirmResetToPaused:(id)sender
{
    [self animateAnimations:^{
        [self.view hideConfirmResetArea];
        [self.view showResetButton];
        [self.view showPauseButton];
    }];
}

- (void)interfaceShouldTransitionFromConfirmResetToNewGame:(id)sender
{
    [self.view resetStartGameLabelContent];

    [self animateAnimations:^{
        [self.view deselectPauseButton];
        [self.view hideConfirmResetArea];
        [self.view showTimesButton];
        [self.view resetPlayerButtonColors];
        [self.view enableWhiteButton];
        [self.view disableBlackButton];
        [self.view showStartGameLabel];
    }];
}


#pragma mark From WhiteTurn state

- (void)interfaceShouldTransitionFromWhiteTurnToWhiteLost:(id)sender
{
    [self animateAnimations:^{
        [self.view hidePauseButton];
        [self.view enableResetButton];
        [self.view enableWhiteButton];
        [self.view enableBlackButton];
        [self.view makeBlackButtonWinner];
    }];
}

- (void)interfaceShouldTransitionFromWhiteTurnToPaused:(id)sender
{
    [self.view selectPauseButton];

    [self animateAnimations:^{
        [self.view disableWhiteButton];
        [self.view enableResetButton];
    }];
}

- (void)interfaceShouldTransitionFromWhiteTurnToBlackTurn:(id)sender
{
    [self animateAnimations:^{
        [self.view disableWhiteButton];
        [self.view enableBlackButton];
    }];
}


#pragma mark From BlackTurn state

- (void)interfaceShouldTransitionFromBlackTurnToBlackLost:(id)sender
{
    [self animateAnimations:^{
        [self.view hidePauseButton];
        [self.view enableResetButton];
        [self.view enableWhiteButton];
        [self.view enableBlackButton];
        [self.view makeWhiteButtonWinner];
    }];
}

- (void)interfaceShouldTransitionFromBlackTurnToPaused:(id)sender
{
    [self.view selectPauseButton];

    [self animateAnimations:^{
        [self.view disableBlackButton];
        [self.view enableResetButton];
    }];
}

- (void)interfaceShouldTransitionFromBlackTurnToWhiteTurn:(id)sender
{
    [self animateAnimations:^{
        [self.view disableBlackButton];
        [self.view enableWhiteButton];
    }];
}


#pragma mark From WhiteLost state

- (void)interfaceShouldTransitionFromWhiteLostToConfirmReset:(id)sender
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark From BlackLost state

- (void)interfaceShouldTransitionFromBlackLostToConfirmReset:(id)sender
{
    [self animateAnimations:^{
        [self.view hideResetButton];
        [self.view showConfirmResetArea];
    }];
}


#pragma mark Updating clock times

- (void)interfaceShouldUpdateWithWhiteTime:(DMClockTime)remainingTime
{
    [self.view updateWithWhiteTime:remainingTime];

}

- (void)interfaceShouldUpdateWithBlackTime:(DMClockTime)remainingTime
{
    [self.view updateWithBlackTime:remainingTime];
}


@end
