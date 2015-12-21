//
//  DMGameView.h
//  chessclock
//
//  Created by Dan on 2015-12-18.
//
//

#import "DMClock.h"

@interface DMGameView : UIView

- (void)updateWithWhiteTime:(DMClockTime)time;
- (void)updateWithBlackTime:(DMClockTime)time;

- (void)enableWhiteButton;
- (void)disableWhiteButton;

- (void)enableBlackButton;
- (void)disableBlackButton;

- (void)showSliders;
- (void)hideSliders;

- (void)enablePlayerButtonInteraction;
- (void)disablePlayerButtonInteraction;

- (void)showResetButton;
- (void)hideResetButton;

- (void)showTimesButton;
- (void)hideTimesButton;

- (void)showPauseButton;
- (void)hidePauseButton;

- (void)showStartGameLabel;
- (void)hideStartGameLabel;

- (void)resetStartGameLabelContent;
- (void)replaceStartGameLabelContent;

- (void)showConfirmResetArea;
- (void)hideConfirmResetArea;

- (void)resetPlayerButtonColors;

- (void)selectPauseButton;
- (void)deselectPauseButton;
- (void)selectTimesButton;
- (void)deselectTimesButton;

@end