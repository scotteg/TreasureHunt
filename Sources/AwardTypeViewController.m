
#import "AwardTypeViewController.h"

@implementation AwardTypeViewController
{
	NSArray *_types;
	NSIndexPath *_selectedIndexPath;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_types = @[
		@"Alien Artifact",
		@"Ancient City",
		@"Candy",
		@"Cash",
		@"Free Hug",
		@"Gold and Silver",
		@"Gold-Pressed Latinum",
		@"Surprise",
		@"Three Wishes",
		@"Toys",
		@"Wisdom",
		@"Youth"
		];

	#if CUSTOM_APPEARANCE
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableBackground"]];
	self.tableView.separatorColor = SeparatorColor;
	#endif
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.awardType = _types[indexPath.row];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	NSString *awardType = _types[indexPath.row];
	cell.textLabel.text = awardType;

	if ([self.awardType isEqualToString:awardType]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		_selectedIndexPath = indexPath;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _selectedIndexPath.row) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;

        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;

        _selectedIndexPath = indexPath;
    }
}

#if CUSTOM_APPEARANCE
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = TableColor;
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCellSelection"]];
	cell.textLabel.textColor = DarkTextColor;
}
#endif

@end
