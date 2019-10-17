//
//  DBUtils.m
//  DoronTrainee
//
//  Created by DoronXC on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

static DBManager * instance = nil;

@implementation DBManager {
    FMDatabaseQueue * _queue;
//    FMDatabase *db;
}

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance setupDB];
    });
    return instance;
}

//打开数据库,创建表
- (void)setupDB {
    _queue = [FMDatabaseQueue databaseQueueWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"testQuest.db"]];
    [_queue inDatabase:^(FMDatabase* db) {
        //创表
        BOOL isSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS quest (id integer PRIMARY KEY NOT NULL AUTO_INCREMENT, questContent TEXT, tempPicturePath TEXT, videoPath TEXT, questType TEXT, note TEXT, status TEXT, isCollect TEXT, quest_answer TEXT);"];
        if (isSuccess) {
            NSLog(@"t_db --- 创表成功");
        }

        BOOL isSuccess1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS answer (id integer PRIMARY KEY NOT NULL AUTO_INCREMENT, answerContent TEXT, isRightAnswer TEXT, status TEXT, questId TEXT);"];
        if (isSuccess1) {
            NSLog(@"t_db1 --- 创表成功");
        }
    }];

    
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [NSString stringWithFormat:@"%@/%@",doc,@"/testQuest.db"];
//    db = [[FMDatabase alloc]initWithPath:path];
//
//    BOOL isSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS quest (id integer PRIMARY KEY, questContent TEXT, tempPicturePath TEXT, videoPath TEXT, questType TEXT, note TEXT, status TEXT, isCollect TEXT, quest_answer TEXT);"];
//    if (isSuccess) {
//        NSLog(@"quest --- 创表成功");
//    }
//
//    BOOL isSuccess1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS answer (id integer PRIMARY KEY, answerContent TEXT, isRightAnswer TEXT, status TEXT, questId TEXT);"];
//    if (isSuccess1) {
//        NSLog(@"answer --- 创表成功");
//    }
  
}

////读取数据
//- (void)dbSuccess:(void (^)(NSMutableArray * results))successBlock {
//
//    [_queue inDatabase:^(FMDatabase* db) {
//
//        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM t_db"];// WHERE LIMIT 30
//        FMResultSet * set = [db executeQuery:sql];
//        NSMutableArray * statuses = [NSMutableArray array];
//        while (set.next) {
//
////            HGNewsLayout *layout = [[HGNewsLayout alloc] init];
////            HGNewsModel *hgModel = [[HGNewsModel alloc] init];
////
////            hgModel.hgid = [set stringForColumn:@"news_id"];
////            hgModel.comment_count = [set stringForColumn:@"comment_count"];
////            hgModel.like_count = [set stringForColumn:@"like_count"];
////            hgModel.org_url = [set stringForColumn:@"org_url"];
////            hgModel.title = [set stringForColumn:@"title"];
////            hgModel.news_title = [set stringForColumn:@"news_title"];
////            hgModel.news_source = [set stringForColumn:@"news_source"];
////            hgModel.click_count = [set stringForColumn:@"click_count"];
////            hgModel.duration = [set stringForColumn:@"duration"];
////            hgModel.list_images = [set stringForColumn:@"list_images"];
////            hgModel.create_time = [set stringForColumn:@"create_time"];
////            hgModel.es_type_name = [set stringForColumn:@"es_type_name"];
////
////            layout.hgModel = hgModel;
////            [statuses addObject:layout];
//        }
//
//        if (successBlock) {
//            successBlock(statuses);
//        }
//    }];
//}

//存入数据
- (void)insertData:(NSArray *)array useTransaction:(BOOL)useTransaction
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db open];
        if (useTransaction) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (NSDictionary *dic in array) {
                    
                    BOOL isSuccess = [db executeUpdateWithFormat:@"INSERT INTO quest(questContent, tempPicturePath, videoPath, questType, note, status, isCollect, quest_answer) VALUES (%@,%@,%@,%@,%@,%@,%@,%@)",dic[@"questContent"],dic[@"tempPicturePath"],dic[@"videoPath"],dic[@"questType"],dic[@"note"],dic[@"status"],dic[@"isCollect"],dic[@"quest_answer"]];
                    if (isSuccess) {
                        NSLog(@"quest1 === 插入成功");
                    }
                    
                    if ([dic objectForKey:@"testAnswerList"]) {
                        for (NSDictionary *asDic in [dic objectForKey:@"testAnswerList"]) {
                            BOOL isSuccess1 = [db executeUpdateWithFormat:@"INSERT INTO answer(questId, answerContent, isRightAnswer, status) VALUES (%@,%@,%@,%@)",dic[@"id"],asDic[@"answerContent"],asDic[@"isRightAnswer"],asDic[@"status"]];
                            if (isSuccess1) {
                                NSLog(@"answer1 === 插入成功");
                            }
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
        }else{
            for (NSDictionary *dic in array) {
                
                BOOL isSuccess = [db executeUpdateWithFormat:@"INSERT INTO quest(questContent, tempPicturePath, videoPath, questType, note, status, isCollect, quest_answer) VALUES (%@,%@,%@,%@,%@,%@,%@,%@)",dic[@"questContent"],dic[@"tempPicturePath"],dic[@"videoPath"],dic[@"questType"],dic[@"note"],dic[@"status"],dic[@"isCollect"],dic[@"quest_answer"]];
                if (isSuccess) {
                    NSLog(@"quest2 === 插入成功");
                }
                
                if ([dic objectForKey:@"testAnswerList"]) {
                    for (NSDictionary *asDic in [dic objectForKey:@"testAnswerList"]) {
                        BOOL isSuccess1 = [db executeUpdateWithFormat:@"INSERT INTO answer(questId, answerContent, isRightAnswer, status) VALUES (%@,%@,%@,%@)",dic[@"id"],asDic[@"answerContent"],asDic[@"isRightAnswer"],asDic[@"status"]];
                        if (isSuccess1) {
                            NSLog(@"answer2 === 插入成功");
                        }
                    }
                }
            }
        }
        [db close];
    }];
}










//- (void)delStatuses:(HGNewsModel *)newsModel {
//
//    [_queue inDatabase:^(FMDatabase* db) {
//
        //     BOOL isSuccess = [db executeUpdateWithFormat:@"DELETE FROM t_db WHERE news_id = '%@';",newsModel.hgid];
//        BOOL isSuccess = [db executeUpdateWithFormat:@"DELETE FROM t_db WHERE id not IN (SELECT id FROM t_db ORDER BY id DESC LIMIT 20)"];
//        if (isSuccess) {
//            NSLog(@"删除成功");
//        }
//    }];
//}

//- (void)del {
//
//    [_queue inDatabase:^(FMDatabase* db) {
//
//        //     BOOL isSuccess = [db executeUpdateWithFormat:@"DELETE FROM t_db WHERE news_id = '%@';",newsModel.hgid];
//        BOOL isSuccess = [db executeUpdateWithFormat:@"DELETE FROM t_db WHERE id not IN (SELECT id FROM t_db ORDER BY id ASC LIMIT 20)"];
//        if (isSuccess) {
//            NSLog(@"删除成功");
//        }
//    }];
//}


@end
