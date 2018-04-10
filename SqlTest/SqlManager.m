//
//  SqlManager.m
//  SqlTest
//
//  Created by mac on 2018/4/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SqlManager.h"


#define sqlite @"Student.sqlite"
@interface SqlManager ()

@property(nonatomic,assign) sqlite3 *db;

@property(nonatomic,copy)NSString *nmae;

@end



@implementation SqlManager

static SqlManager *instance;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
     NSLog(@"%d",[instance openDB]);
    });
    return instance;
}

#pragma mark - 打开/创建数据库
-(BOOL)openDB{
    //app内数据库文件存放路径-一般存放在沙盒中
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *DBPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",sqlite]];
    //创建(指定路径不存在数据库文件)/打开(已存在数据库文件) 数据库文件
    //sqlite3_open(<#const char *filename#>, <#sqlite3 **ppDb#>)  filename:数据库路径  ppDb:数据库对象
    if (sqlite3_open(DBPath.UTF8String, &_db) != SQLITE_OK)
    {
        NSLog(@"打开失败");
        return NO;
    }
    else
    {
         NSLog(@"打开成功创建表");
        return [self creatTable];
    }
}

 #pragma mark ————————— 创建表 —————————————
-(BOOL)creatTable{
    //创建表的SQL语句
    //用户 表
    NSString *creatUserTable = @"CREATE TABLE IF NOT EXISTS 't_User' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'age' INTEGER,'icon' TEXT);";
    //车 表
    NSString *creatCarTable = @"CREATE TABLE IF NOT EXISTS 't_Car' ('ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'type' TEXT,'output' REAL,'master' TEXT)";
    //项目中一般不会只有一个表
    NSArray *SQL_ARR = [NSArray arrayWithObjects:creatUserTable,creatCarTable, nil];
    return [self creatTableExecSQL:SQL_ARR];
}

 #pragma mark ————————— 便利数组并创建 —————————————
-(BOOL)creatTableExecSQL:(NSArray *)SQL_ARR{
    for (NSString *SQL in SQL_ARR) {
        //参数一:数据库对象  参数二:需要执行的SQL语句  其余参数不需要处理
        if (![self execSQL:SQL]) {
            
            NSLog(@"创建表失败");
            return NO;
        }
    }
     NSLog(@"创建表成功");
    return YES;
}

 #pragma mark ————————— 执行SQL语句 —————————————
-(BOOL)execSQL:(NSString *)SQL {
    return sqlite3_exec(self.db, SQL.UTF8String, nil, nil, nil) == SQLITE_OK;
}

-(void)fetch{
    NSString *sql = @"SELECT * FROM t_User";
    sqlite3_stmt *stemt = NULL;
    /*
     第一个参数:需要执行SQL语句的数据库
     第二个参数:需要执行的SQL语句
     第三个参数: 告诉系统SQL语句的长度, 如果传入一个小于0的数, 系统会自动计算
     第四个参数:结果集, 里面存放所有查询到的数据(不严谨)
     */
    sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stemt, NULL);
    // 判断有没有查询结果
    while (sqlite3_step(stemt) == SQLITE_ROW) {
        // 取出第一个字段的查询得结果
        const unsigned char *name = sqlite3_column_text(stemt, 1);
        // 取出第一个字段的查询得结果
        int age = sqlite3_column_int(stemt, 2);
        // 取出第一个字段的查询得结果
        double score = sqlite3_column_double(stemt, 3);
        NSLog(@"%s %d %f", name, age, score);
    }
}


#pragma mark - 查询数据库中数据
-(NSArray *)querySQL:(NSString *)SQL{
    //准备查询
    // 1> 参数一:数据库对象
    // 2> 参数二:查询语句
    // 3> 参数三:查询语句的长度:-1
    // 4> 参数四:句柄(游标对象)
    //    sqlite3_prepare_v2(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(self.db, SQL.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"准备查询失败!");
        return NULL;
    }
    //准备成功,开始查询数据
    //定义一个存放数据字典的可变数组
    NSMutableArray *dictArrM = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        //一共获取表中所有列数(字段数)
        int columnCount = sqlite3_column_count(stmt);
        //定义存放字段数据的字典
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < columnCount; i++) {
            // 取出i位置列的字段名,作为字典的键key
            const char *cKey = sqlite3_column_name(stmt, i);
            NSString *key = [NSString stringWithUTF8String:cKey];
            
            //取出i位置存储的值,作为字典的值value
            const char *cValue = (const char *)sqlite3_column_text(stmt, i);
            NSString *value = [NSString stringWithUTF8String:cValue];
            
            //将此行数据 中此字段中key和value包装成 字典
            [dict setObject:value forKey:key];
        }
        [dictArrM addObject:dict];
    }
    return dictArrM;
}






@end
