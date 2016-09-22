//
//  UserDefault.m
//  BaseProject
//
//

#import "UserDefault.h"

@implementation UserDefault

#pragma mark - Public Function

+ (id)objectFromUserDefaultsForKey:(NSString *)key {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

+ (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setObject:(id)obj forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearAllUserDefault {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //if(![key isEqualToString:FirstTimeLaunchKey])
            [defs removeObjectForKey:key];
    }];
    [defs synchronize];
}

@end

