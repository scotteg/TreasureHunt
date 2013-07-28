
#import "DataModel.h"

@implementation DataModel
{
	NSMutableArray *_maps;
}

- (instancetype)init
{
	if ((self = [super init])) {
		// Load the TreasureMap objects from the plist file.

		NSString *path = [self dataFilePath];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {

			// The TreasureMap objects conform to the NSCoding protocol, which
			// means that they can be archived into plist files. Here we use a
			// "keyed unarchiver" to read the objects back out of the plist.

			NSData *data = [[NSData alloc] initWithContentsOfFile:path];
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			_maps = [unarchiver decodeObjectForKey:@"TreasureMaps"];
			[unarchiver finishDecoding];

		} else {  // no data file found

			_maps = [NSMutableArray array];

			// Just for the purposes of this tutorial, fill up the _maps array
			// with a bunch of TreasureMap objects, so we have some "fake" data
			// to play with.
			[self addTestData];
		}
	}
	return self;
}

- (void)save
{
	// The TreasureMap objects conform to the NSCoding protocol, which means
	// that they can be archived into plist files. That's exactly what happens
	// here. The "keyed archiver" stores the data in plist format into a new
	// NSMutableData object that gets saved to disk. (The photos do not go into
	// this plist file.)

	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:_maps forKey:@"TreasureMaps"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)documentsDirectory
{
	// This method returns the path to the app's Documents folder.

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return paths[0];
}
 
- (NSString *)dataFilePath
{
	// This method returns the full path to the plist file that will store
	// our TreasureMap objects.

	return [[self documentsDirectory] stringByAppendingPathComponent:@"TreasureMaps.plist"];
}

- (NSArray *)allMaps
{
	return _maps;
}

- (NSArray *)myMaps
{
	// Note: this isn't very efficient. Every time you call this method, it
	// creates a new array by filtering the _maps array. In a real app, you
	// would cache this list instead of making a new instance each time.

	return [_maps filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"fromLocalUser == YES"]];
}

- (void)addMap:(TreasureMap *)map
{
	[_maps addObject:map];
}

- (void)removeMap:(TreasureMap *)map
{
	[_maps removeObject:map];
}

- (NSArray *)filterMaps:(NSString *)searchText
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
	return [_maps filteredArrayUsingPredicate:predicate];
}

- (void)addTestData
{
	// Because the app doesn't actually use a network connection to load the
	// treasure map objects from a server, this method adds some treasure maps
	// for you to play with.

	{
		TreasureMap *map = [[TreasureMap alloc] init];
		map.name = @"Capt Kidd's Buried Treasure";
		map.instructions = @"The story goes that Captain Kidd plundered the ship Quedah Merchant, which was loaded with satins, muslins, gold, silver, an incredible variety of East Indian merchandise, as well as extremely valuable silks.\n\n"
			@"He buried the treasure on Gardiner's Island, near Long Island, New York, before he was arrested and returned to England, where he was put through a very public trial and executed.\n\n"
			@"Over the years many people have tried to find the supposed remnants of Kidd's treasure on Gardiner's Island and elsewhere, but none has ever been found.\n\n"
			@"Source: Wikipedia";
		map.awardType = @"Gold and Silver";
		map.date = [NSDate dateWithTimeIntervalSince1970:-60*60*24*365*269.0];
		map.photoFilename = [[NSBundle mainBundle] pathForResource:@"Treasure-Island-map" ofType:@"jpg"];
		map.sharedBy = @"You";
		map.fromLocalUser = YES;
		[_maps addObject:map];
		
		Clue *clue = [[Clue alloc] init];
		clue.text = @"The wreckage of the Quedagh Merchant was found in December 2007 by divers in shallow waters off the Dominican Republic.";
		clue.sharedBy = @"JohnnyAppleseed1967";
		[map addClue:clue];

		clue = [[Clue alloc] init];
		clue.text = @"So, like, I heard there was only a little bit of gold buried and that, like, all of it was found already. Bummer, dude. Don't believe it... the real treasure is still out there!";
		clue.sharedBy = @"Random Duder";
		[map addClue:clue];

		clue = [[Clue alloc] init];
		clue.text = @"Are you sure this is the correct map?";
		clue.sharedBy = @"Robert Lewis Stevenson";
		[map addClue:clue];
	}

	{
		TreasureMap *map = [[TreasureMap alloc] init];
		map.name = @"The Copper Scroll";
		map.instructions = @"One of the earliest known instances of a document listing buried treasure, the Copper Scroll is believed to have been written between 50 and 100 AD, and contains a list of 63 locations with detailed directions pointing to hidden treasures of gold and silver.\n\n"
			@"The following is an English translation of the opening lines of the Copper Scroll:\n\n"
			@"1. In the ruin which is in the valley of Acor, under\n"
			@"2. the steps leading to the East,\n"
			@"3. forty long cubits: a chest of silver and its vessels\n"
			@"4. with a weight of seventeen talents.\n\n"
			@"Source: Wikipedia";
		map.awardType = @"Gold and Silver";
		map.date = [NSDate dateWithTimeIntervalSince1970:-60*60*24*365*1850.0];
		map.photoFilename = [[NSBundle mainBundle] pathForResource:@"Part_of_Qumran_Copper_Scroll" ofType:@"jpg"];
		map.sharedBy = @"GoldDigger24";
		map.fromLocalUser = NO;
		[_maps addObject:map];

		Clue *clue = [[Clue alloc] init];
		clue.text = @"I'm pretty sure this is a hoax.";
		clue.sharedBy = @"Gaster";
		[map addClue:clue];
		
		clue = [[Clue alloc] init];
		clue.text = @"I heard that a duplicate copy of the scroll was discovered by the Knights Templar during the First Crusade, who then dug up all the treasure and used it to fund their order. Is this true?";
		clue.sharedBy = @"A_Concerned_Reader";
		[map addClue:clue];
	}

	{
		TreasureMap *map = [[TreasureMap alloc] init];
		map.name = @"Jimmy’s birthday present";
		map.instructions = @"Happy birthday, Jim! \U0001F382\n\nWe wanted to do something special this year so we have hidden your presents and made a treasure map. Have fun finding your presents with your friends!\n\nHint: Try to find out what each building represents.";
		map.awardType = @"Surprise";
		map.date = [NSDate date];
		map.photoFilename = [[NSBundle mainBundle] pathForResource:@"Jimmys Birthday" ofType:@"jpg"];
		map.sharedBy = @"Jimmy's Mom and Dad";
		map.fromLocalUser = NO;
		[_maps addObject:map];
		
		Clue *clue = [[Clue alloc] init];
		clue.text = @"Maybe the building in the top-left corner is the Eiffel tower";
		clue.sharedBy = @"Eliza";
		[map addClue:clue];

		clue = [[Clue alloc] init];
		clue.text = @"Sorry Eliza, but we didn't go all the way to Paris to hide these presents. :-)";
		clue.sharedBy = @"Jimmy's Dad";
		[map addClue:clue];
	}

	{
		TreasureMap *map = [[TreasureMap alloc] init];
		map.name = @"El Dorado";
		map.instructions = @"El Dorado is the name of a legendary 'Lost City of Gold', that has fascinated explorers since the days of the Spanish Conquistadors.\n\nSource: Wikipedia";
		map.awardType = @"Ancient City";
		map.date = [NSDate dateWithTimeIntervalSince1970:-60*60*24*365*369.0];
		map.photoFilename = [[NSBundle mainBundle] pathForResource:@"El Dorado" ofType:@"jpg"];
		map.sharedBy = @"You";
		map.fromLocalUser = YES;
		[_maps addObject:map];
		
		Clue *clue = [[Clue alloc] init];
		clue.text = @"I have looked for it twice, but never found it. Yet I remain convinced that there is a fantastic city whose riches can be discovered. Finding gold on the riverbanks and in villages has only strengthened my resolve. (BTW, I've also seen a tribe of headless people. Weird!)";
		clue.sharedBy = @"W. Raleigh";
		[map addClue:clue];
	}

	{
		TreasureMap *map = [[TreasureMap alloc] init];
		map.name = @"Springfield Easter Egg Hunt";
		map.instructions = @"Hey kids of Springfield, it's egg hunting time again. The eggs have been hidden near places you all know. Have fun!\n\nP.S. Eat my shorts!";
		map.awardType = @"Candy";
		map.date = [NSDate date];
		map.photoFilename = [[NSBundle mainBundle] pathForResource:@"Springfield" ofType:@"jpg"];
		map.sharedBy = @"B. Simpson";
		map.fromLocalUser = NO;
		[_maps addObject:map];
		
		Clue *clue = [[Clue alloc] init];
		clue.text = @"D'oh!";
		clue.sharedBy = @"Homer";
		[map addClue:clue];
	}
}

@end
