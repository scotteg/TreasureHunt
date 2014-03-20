
#import "MapDetailViewController.h"
#import "PhotoViewController.h"
#import "InstructionsViewController.h"
#import "CluesViewController.h"
#import "NewClueViewController.h"
#import "DataModel.h"

@interface MapDetailViewController () <UINavigationBarDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation MapDetailViewController
{
	UIViewController *_viewControllers[3];
	NSUInteger _activeIndex;
	CluesViewController *_cluesViewController;
	NewClueViewController *_newClueViewController;
  BOOL _hideStatusBar;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// The three sub-sections of this screen -- the map, the instructions, and
	// the clues -- all have their own view controllers, which we add as child
	// view controllers here. The user switches between them using the segmented
	// control at the bottom of the screen.

	PhotoViewController *photoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
	photoViewController.photo = [self.map loadPhoto];
	[self addChildViewController:photoViewController atIndex:0];
  
  photoViewController.scrollView.delegate = self;

	InstructionsViewController *instructionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
	instructionsViewController.name = self.map.name;
	instructionsViewController.instructions = self.map.instructions;
	[self addChildViewController:instructionsViewController atIndex:1];

	_cluesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CluesViewController"];
	_cluesViewController.clues = self.map.clues;
	[self addChildViewController:_cluesViewController atIndex:2];

	_activeIndex = NSNotFound;
	[self switchToViewControllerAtIndex:0];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
  [photoViewController.scrollView addGestureRecognizer:tapGestureRecognizer];
}

- (void)addChildViewController:(UIViewController *)childController atIndex:(NSUInteger)index
{
	childController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[self addChildViewController:childController];
	[childController didMoveToParentViewController:self];
	_viewControllers[index] = childController;
}

- (void)switchToViewControllerAtIndex:(NSUInteger)index
{
	if (_activeIndex != NSNotFound) {
		[_viewControllers[_activeIndex].view removeFromSuperview];
	}
	_activeIndex = index;

	_viewControllers[_activeIndex].view.frame = self.contentView.bounds;
	[self.contentView insertSubview:_viewControllers[_activeIndex].view atIndex:0];
}

- (IBAction)segmentTapped:(UISegmentedControl *)sender
{
	[self switchToViewControllerAtIndex:sender.selectedSegmentIndex];
}

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Clues

- (IBAction)addClue:(id)sender
{
	// The "clue sheet" popup is also a child view controller.

	_newClueViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewClueViewController"];

	[self addChildViewController:_newClueViewController];
	_newClueViewController.view.frame = self.view.bounds;
	_newClueViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_newClueViewController.view];
	[_newClueViewController didMoveToParentViewController:self];

	[_newClueViewController.cancelButton addTarget:self action:@selector(cancelClue) forControlEvents:UIControlEventTouchUpInside];
	[_newClueViewController.submitButton addTarget:self action:@selector(submitClue) forControlEvents:UIControlEventTouchUpInside];

	// Fade it in.
	_newClueViewController.view.alpha = 0.0f;
	[UIView animateWithDuration:0.4 animations:^{
		_newClueViewController.view.alpha = 1.0f;
	}];
}

- (void)cancelClue
{
	[self hideCluePopup];
}

- (void)submitClue
{
	// Add the new clue to the treasure map and save the data model.
	Clue *clue = [[Clue alloc] init];
	clue.text = _newClueViewController.textView.text;
	clue.sharedBy = @"You";
	[self.map addClue:clue];
	[self.dataModel save];

	// If the "Clues" screen is active, then reload the table view so that
	// the new clue is immediately visible.
	if (_activeIndex == 2) {
		[_cluesViewController.tableView reloadData];
	}

	[self hideCluePopup];
}

- (void)hideCluePopup
{
	[UIView animateWithDuration:0.2 animations:^{
		_newClueViewController.view.alpha = 0.0f;

	} completion:^(BOOL finished) {
		[_newClueViewController willMoveToParentViewController:nil];
		[_newClueViewController.view removeFromSuperview];
		[_newClueViewController removeFromParentViewController];
		_newClueViewController = nil;
	}];
}

// Could've used setNavigationBarHidden:animated: and setToolbarHiddenAnimated: if the map detail was embedded in a navigation controller

- (void)tapped:(UIGestureRecognizer *)recognizer
{
  if (recognizer.state == UIGestureRecognizerStateEnded && _hideStatusBar) {
  [self showBars];
  }
}

- (void)showBars
{
  _hideStatusBar = NO;
  self.navigationBar.hidden = NO;
  self.toolbar.hidden = NO;
  
  [UIView animateWithDuration:0.25 animations:^{
  self.navigationBar.alpha = 1.0f;
  self.toolbar.alpha = 1.0f;
  [self setNeedsStatusBarAppearanceUpdate];
  }];
}

- (void)hideBars
{
  _hideStatusBar = YES;
  
  [UIView animateWithDuration:0.25 animations:^{
  self.navigationBar.alpha = 0.0f;
  self.toolbar.alpha = 0.0f;
  [self setNeedsStatusBarAppearanceUpdate];
  } completion:^(BOOL finished) {
  self.navigationBar.hidden = YES;
  self.toolbar.hidden = YES;
  }];
}

- (BOOL)prefersStatusBarHidden
{
  return _hideStatusBar;
}

#pragma mark - UINavigationBarDelegate <UIBarPositioningDelegate>

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
  return UIBarPositionTopAttached;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (!_hideStatusBar) {
  [self hideBars];
  }
}

@end
