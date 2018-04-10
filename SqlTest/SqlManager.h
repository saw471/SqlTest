//
//  SqlManager.h
//  SqlTest
//
//  Created by mac on 2018/4/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqlManager : NSObject
//类方法生成单例对象
+(instancetype)shareInstance;

-(BOOL)execSQL:(NSString *)SQL;

-(NSArray *)querySQL:(NSString *)SQL;

//-(NSArray *)fetch;
-(void)fetch;
@end
