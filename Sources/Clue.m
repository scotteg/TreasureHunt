
#import "Clue.h"

@implementation Clue

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init])) {
		self.text = [aDecoder decodeObjectForKey:@"Text"];
		self.sharedBy = [aDecoder decodeObjectForKey:@"SharedBy"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.text forKey:@"Text"];
	[aCoder encodeObject:self.sharedBy forKey:@"SharedBy"];
}

@end
