
#import "TreasureMap.h"
#import "UIImage+Resize.h"

@implementation TreasureMap
{
	UIImage *_thumbnail;
	NSMutableArray *_clues;
}

- (instancetype)init
{
	if ((self = [super init])) {
		_clues = [NSMutableArray array];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init])) {
		self.name = [aDecoder decodeObjectForKey:@"Name"];
		self.instructions = [aDecoder decodeObjectForKey:@"Instructions"];
		self.awardType = [aDecoder decodeObjectForKey:@"AwardType"];
		self.date = [aDecoder decodeObjectForKey:@"Date"];
		self.photoFilename = [aDecoder decodeObjectForKey:@"PhotoFilename"];
		self.sharedBy = [aDecoder decodeObjectForKey:@"SharedBy"];
		self.fromLocalUser = [aDecoder decodeBoolForKey:@"FromLocalUser"];
		_clues = [aDecoder decodeObjectForKey:@"Clues"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.instructions forKey:@"Instructions"];
	[aCoder encodeObject:self.awardType forKey:@"AwardType"];
	[aCoder encodeObject:self.date forKey:@"Date"];
	[aCoder encodeObject:self.photoFilename forKey:@"PhotoFilename"];
	[aCoder encodeObject:self.sharedBy forKey:@"SharedBy"];
	[aCoder encodeBool:self.fromLocalUser forKey:@"FromLocalUser"];
	[aCoder encodeObject:_clues forKey:@"Clues"];
}

- (UIImage *)thumbnail
{
	if (self.photoFilename == nil) {
		return [UIImage imageNamed:@"UnknownThumb"];
	}

	if (_thumbnail != nil) {
		return _thumbnail;
	}

	[self refreshThumbnail];
	return _thumbnail;
}

- (void)refreshThumbnail
{
	if (self.photoFilename != nil) {
		_thumbnail = [[self loadPhoto] resizedImageWithSize:CGSizeMake(60.0f, 60.0f)];
	} else {
		_thumbnail = nil;
	}
}

- (void)addClue:(Clue *)clue
{
	[_clues addObject:clue];
}

- (UIImage *)loadPhoto
{
	return [UIImage imageWithContentsOfFile:self.photoFilename];
}

@end
