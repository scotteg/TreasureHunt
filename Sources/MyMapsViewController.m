
#import "MyMapsViewController.h"
#import "DataModel.h"
#import "NewMapViewController.h"
#import "MapDetailViewController.h"

@interface MyMapsViewController () <UIActionSheetDelegate>

@end

@implementation MyMapsViewController
{
	NSIndexPath *_indexPathToDelete;
	NSIndexPath *_indexPathToEdit;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		#if CUSTOM_APPEARANCE
		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"MyMapsBarIcon-Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"MyMapsBarIcon-Unselected"]];
		#endif
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Crown"]];

	// Display an Edit button in the navigation bar.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	#if CUSTOM_APPEARANCE
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppTitle"]];

	UIImageView *tableImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBackground"]];
	tableImageView.contentMode = UIViewContentModeBottom;
	self.tableView.backgroundView = tableImageView;
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	#endif
  
  self.tabBarItem.selectedImage = [UIImage imageNamed:@"MyMapsBarIcon-Selected"];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	#if CUSTOM_APPEARANCE
	return [self.dataModel.myMaps count] + 1;
	#else
	return [self.dataModel.myMaps count];
	#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	#if CUSTOM_APPEARANCE
	// Add a torn piece of paper to the bottom of the table. This is a new cell
	// that just shows an image; it does nothing else.

	if (indexPath.row == (NSInteger)[_dataModel.myMaps count]) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FooterCell"];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FooterCell"];
			
			UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableFooter"]];
			[cell.contentView addSubview:imageView];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return cell;
	}
	#endif

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];

	TreasureMap *map = _dataModel.myMaps[indexPath.row];
	cell.textLabel.text = map.name;
	cell.imageView.image = map.thumbnail;

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Remember which row the user wanted to delete.
		_indexPathToDelete = indexPath;

		// Present an action sheet to ask for confirmation first.
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:nil
            delegate:self
            cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:@"Delete"
            otherButtonTitles:nil];

        [actionSheet showFromTabBar:self.tabBarController.tabBar];
	}
}

#if CUSTOM_APPEARANCE
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == (NSInteger)[_dataModel.myMaps count]) {
		return nil;
	} else {
		return indexPath;
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == (NSInteger)[_dataModel.myMaps count]) {
		return;
	}

	if (indexPath.row % 2 == 0) {
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellBackground-Even"]];
	} else {
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellBackground-Odd"]];
	}

	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellSelection"]];
	cell.backgroundColor = [UIColor clearColor];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setBackgroundImage:[UIImage imageNamed:@"DisclosureButton"] forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:@selector(disclosureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView = button;
}

- (void)disclosureButtonTapped:(UIButton *)button
{
	// This method is necessary only because we've replaced the standard
	// disclosure button (which has a segue) with a custom button.

	UITableViewCell *cell = (UITableViewCell *)button.superview;
	[self performSegueWithIdentifier:@"EditMap" sender:cell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return indexPath.row != (NSInteger)[_dataModel.myMaps count];
}
#endif

#pragma mark - Action Sheet

- (void)actionSheet:(UIActionSheet *)theActionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		TreasureMap *map = _dataModel.myMaps[_indexPathToDelete.row];
		[self.dataModel removeMap:map];
		[self.dataModel save];

		[self.tableView deleteRowsAtIndexPaths:@[_indexPathToDelete] withRowAnimation:UITableViewRowAnimationFade];
		_indexPathToDelete = nil;
	}
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EditMap"]) {

		UINavigationController *navigationController = segue.destinationViewController;
		NewMapViewController *controller = navigationController.viewControllers[0];
		controller.title = @"Edit Map";

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		_indexPathToEdit = indexPath;

		TreasureMap *map = self.dataModel.myMaps[indexPath.row];
		controller.name = map.name;
		controller.instructions = map.instructions;
		controller.awardType = map.awardType;
		controller.date = map.date;
		controller.photo = [map loadPhoto];

	} else if ([segue.identifier isEqualToString:@"ShowMap"]) {
		MapDetailViewController *controller = segue.destinationViewController;
		controller.dataModel = self.dataModel;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		TreasureMap *map = self.dataModel.myMaps[indexPath.row];
		controller.map = map;
	}
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
	// No need to do anything here...
}

- (IBAction)save:(UIStoryboardSegue *)segue
{
	// This method is called during the unwind segue from the New/Edit Map
	// screen. This is where we create a new TreasureMap object, or update
	// an existing one, with the data that the user just entered.

	TreasureMap *map;

	NewMapViewController *controller = segue.sourceViewController;
	if (_indexPathToEdit != nil) {
		map = _dataModel.myMaps[_indexPathToEdit.row];

	} else {
		map = [[TreasureMap alloc] init];
		map.sharedBy = @"You";
		map.fromLocalUser = YES;

		[self.dataModel addMap:map];
	}

	if (controller.photo != nil) {
		// Generate a unique filename inside the app's Documents folder.
		if (map.photoFilename == nil) {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *filename = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".jpg"];
			map.photoFilename = [paths[0] stringByAppendingPathComponent:filename];
		}

		// Save the photo into a separate file. We don't want to put this into
		// the plist file with all the treasure maps, as that is horribly slow.
		NSData *data = UIImageJPEGRepresentation(controller.photo, 1.0f);
		[data writeToFile:map.photoFilename atomically:NO];
	}

	map.name = controller.name;
	map.instructions = controller.instructions;
	map.awardType = controller.awardType;
	map.date = controller.date;
	[map refreshThumbnail];

	[self.dataModel save];

	if (_indexPathToEdit != nil) {
		[self.tableView reloadRowsAtIndexPaths:@[_indexPathToEdit] withRowAnimation:UITableViewRowAnimationAutomatic];
		_indexPathToEdit = nil;
	} else {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataModel.myMaps count] - 1 inSection:0];
		[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

@end
