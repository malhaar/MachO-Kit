//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             MKBitfieldFormatter.m
//|
//|             D.V.
//|             Copyright (c) 2014-2015 D.V. All rights reserved.
//|
//| Permission is hereby granted, free of charge, to any person obtaining a
//| copy of this software and associated documentation files (the "Software"),
//| to deal in the Software without restriction, including without limitation
//| the rights to use, copy, modify, merge, publish, distribute, sublicense,
//| and/or sell copies of the Software, and to permit persons to whom the
//| Software is furnished to do so, subject to the following conditions:
//|
//| The above copyright notice and this permission notice shall be included
//| in all copies or substantial portions of the Software.
//|
//| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//| OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------------//

#import "MKBitfieldFormatter.h"

//----------------------------------------------------------------------------//
@implementation MKBitfieldFormatterMask

@synthesize mask = _mask;
@synthesize formatter = _formatter;
@synthesize shift = _shift;
@synthesize ignoreZero = _ignoreZero;

//|++++++++++++++++++++++++++++++++++++|//
- (void)dealloc
{
    [_formatter release];
    [_mask release];
    
    [super dealloc];
}

//|++++++++++++++++++++++++++++++++++++|//
- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self == nil) return nil;
    
    _mask = [[aDecoder decodeObjectOfClass:NSNumber.class forKey:@"mask"] retain];
    _formatter = [[aDecoder decodeObjectOfClass:NSFormatter.class forKey:@"formatter"] retain];
    _shift = [aDecoder decodeIntForKey:@"shift"];
    _ignoreZero = [aDecoder decodeBoolForKey:@"ignoreZero"];
    
    return self;
}

//|++++++++++++++++++++++++++++++++++++|//
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.mask forKey:@"mask"];
    [aCoder encodeObject:self.formatter forKey:@"formatter"];
    [aCoder encodeInt:self.shift forKey:@"shift"];
    [aCoder encodeBool:self.ignoreZero forKey:@"ignoreZero"];
}

@end



//----------------------------------------------------------------------------//
@implementation MKBitfieldFormatter

//|++++++++++++++++++++++++++++++++++++|//
- (void)dealloc
{
    [_bits release];
    
    [super dealloc];
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSCoding
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self == nil) return nil;
    
    _bits = [[aDecoder decodeObjectOfClass:NSArray.class forKey:@"bits"] mutableCopy];
    
    return self;
}

//|++++++++++++++++++++++++++++++++++++|//
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.bits forKey:@"bits"];
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSCopying
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (id)copyWithZone:(NSZone*)zone
{
    MKBitfieldFormatter *copy = [[MKBitfieldFormatter allocWithZone:zone] init];
    copy.bits = self.bits;
    
    return copy;
}

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  Configuring Formatter Behavior
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

@synthesize bits = _bits;

//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//
#pragma mark -  NSFormatter
//◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦◦//

//|++++++++++++++++++++++++++++++++++++|//
- (NSString*)stringForObjectValue:(NSNumber*)anObject
{
    if ([anObject isKindOfClass:NSNumber.class] == NO)
        return nil;
    
    NSMutableString *retValue = [NSMutableString string];
    
    uint64_t value;
    switch (*[anObject objCType]) {
        case 'c':
        case 'C':
            value = (uint64_t)[anObject unsignedCharValue];
            break;
        case 's':
        case 'S':
            value = (uint64_t)[anObject unsignedShortValue];
            break;
        case 'i':
        case 'I':
            value = (uint64_t)[anObject unsignedIntValue];
            break;
        case 'q':
        case 'Q':
            value = (uint64_t)[anObject unsignedLongLongValue];
            break;
        default:
            return nil;
    }
    
    for (MKBitfieldFormatterMask *group in self.bits) {
        NSNumber *maskValue = group.mask;
        NSFormatter *formatter = group.formatter;
        int shift = group.shift;
        BOOL ignoreZero = group.ignoreZero;
        
        if (maskValue == nil || formatter == nil)
            continue;
        
        uint64_t mask;
        switch (*[maskValue objCType]) {
            case 'c':
            case 'C':
                mask = (uint64_t)[maskValue unsignedCharValue];
                break;
            case 's':
            case 'S':
                mask = (uint64_t)[maskValue unsignedShortValue];
                break;
            case 'i':
            case 'I':
                mask = (uint64_t)[maskValue unsignedIntValue];
                break;
            case 'q':
            case 'Q':
                mask = (uint64_t)[maskValue unsignedLongLongValue];
                break;
            default:
                continue;
        }
        
        uint64_t maskedValue = value & mask;
        
        if (maskedValue == 0 && ignoreZero)
            continue;
        
        if (shift > 0)
            maskedValue = maskedValue << shift;
        else if (shift < 0)
            maskedValue = maskedValue >> -shift;
        
        NSNumber *maskedNumber;
        switch (*[anObject objCType]) {
            case 'c':
            case 'C':
                maskedNumber = (NSNumber*)CFNumberCreate(NULL, kCFNumberSInt8Type, &maskedValue);
                break;
            case 's':
            case 'S':
                maskedNumber = (NSNumber*)CFNumberCreate(NULL, kCFNumberSInt16Type, &maskedValue);
                break;
            case 'i':
            case 'I':
                maskedNumber = (NSNumber*)CFNumberCreate(NULL, kCFNumberSInt32Type, &maskedValue);
                break;
            case 'q':
            case 'Q':
            default:
                maskedNumber = (NSNumber*)CFNumberCreate(NULL, kCFNumberSInt64Type, &maskedValue);
                break;
        }
        
        NSString *formattedValue = [formatter stringForObjectValue:maskedNumber];
        
        if (formattedValue.length > 0) {
            if (retValue.length != 0) [retValue appendString:@" "];
            [retValue appendString:formattedValue];
        }
        
        [maskedNumber release];
    }
    
    return retValue;
}

@end
