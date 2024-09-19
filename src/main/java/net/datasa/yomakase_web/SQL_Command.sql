CREATE TABLE `member` (
                          `member_num` int auto_increment primary key,
                          `id` varchar(50) NOT NULL UNIQUE,
                          `pw` varchar(100) NOT NULL,
                          `name` varchar(100) NOT NULL UNIQUE,
                          `gen` char(1) NOT NULL,
                          `birth_date` date NOT NULL,
                          `user_role` varchar(30) DEFAULT 'ROLE_USER' CHECK (`user_role` IN ('ROLE_USER', 'ROLE_SUBSCRIBER', 'ROLE_ADMIN')),
                          `enabled` tinyint(1) DEFAULT 1 CHECK (`enabled` IN (1, 0))
);

select * from `member`;
UPDATE `member` SET user_role ='ROLE_ADMIN' WHERE name ='Admin';

CREATE TABLE `stock` (
                         `ingredient_name` varchar(700) NOT NULL,
                         `member_num` int NOT NULL,
                         `is_having` tinyint(1) DEFAULT 1 CHECK (`is_having` IN (0, 1)), -- 1 : 재고 있음, 0 : 재고 없음
                         `use_by_date` DATE NOT NULL,
                         `update_date` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`ingredient_name`, `member_num`),
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `stock`;

CREATE TABLE `allergy` (
                           `member_num` int NOT NULL,
                           `eggs` tinyint(1) DEFAULT 0 CHECK (`eggs` IN (0, 1)), -- 1 : 알레르기 있음, 0 : 알레르기 없음
                           `milk` tinyint(1) DEFAULT 0 CHECK (`milk` IN (0, 1)),
                           `buckwheat` tinyint(1) DEFAULT 0 CHECK (`buckwheat` IN (0, 1)),
                           `peanut` tinyint(1) DEFAULT 0 CHECK (`peanut` IN (0, 1)),
                           `soybean` tinyint(1) DEFAULT 0 CHECK (`soybean` IN (0, 1)),
                           `wheat` tinyint(1) DEFAULT 0 CHECK (`wheat` IN (0, 1)),
                           `mackerel` tinyint(1) DEFAULT 0 CHECK (`mackerel` IN (0, 1)),
                           `crab` tinyint(1) DEFAULT 0 CHECK (`crab` IN (0, 1)),
                           `shrimp` tinyint(1) DEFAULT 0 CHECK (`shrimp` IN (0, 1)),
                           `pork` tinyint(1) DEFAULT 0 CHECK (`pork` IN (0, 1)),
                           `peach` tinyint(1) DEFAULT 0 CHECK (`peach` IN (0, 1)),
                           `tomato` tinyint(1) DEFAULT 0 CHECK (`tomato` IN (0, 1)),
                           `walnuts` tinyint(1) DEFAULT 0 CHECK (`walnuts` IN (0, 1)),
                           `chicken` tinyint(1) DEFAULT 0 CHECK (`chicken` IN (0, 1)),
                           `beef` tinyint(1) DEFAULT 0 CHECK (`beef` IN (0, 1)),
                           `squid` tinyint(1) DEFAULT 0 CHECK (`squid` IN (0, 1)),
                           `shellfish` tinyint(1) DEFAULT 0 CHECK (`shellfish` IN (0, 1)),
                           `pine_nut` tinyint(1) DEFAULT 0 CHECK (`pine_nut` IN (0, 1)),
                           PRIMARY KEY (`member_num`),
                           FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `allergy`;

CREATE TABLE `user_body_info` (
                                  `member_num` int NOT NULL,
                                  `weight` int NULL,
                                  `height` int NULL,
                                  PRIMARY KEY (`member_num`),
                                  FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `user_body_info`;

CREATE TABLE `board` (
                         `board_num` int NOT NULL AUTO_INCREMENT,
                         `member_num` int NOT NULL,
                         `title` varchar(200) NOT NULL,
                         `category` varchar(10) NOT NULL,
                         `contents` mediumtext NOT NULL,
                         `create_date` timestamp DEFAULT current_timestamp,
                         `update_date` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         `file_name` varchar(100) NULL,
                         `recommended` int DEFAULT 0 NOT NULL,
                         PRIMARY KEY (`board_num`),
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `board`;

CREATE TABLE `reply` (
                         `reply_num` int NOT NULL AUTO_INCREMENT,
                         `board_num` int NOT NULL,
                         `member_num` int NOT NULL,
                         `reply_contents` varchar(1000) NULL,
                         `create_date`	timestamp default current_timestamp,
                         PRIMARY KEY (`reply_num`),
                         FOREIGN KEY (`board_num`) REFERENCES `board`(`board_num`) ON DELETE CASCADE,
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `reply`;

CREATE TABLE `saved_recipe` (
                                `index_num` int NOT NULL AUTO_INCREMENT,
                                `member_num` int NOT NULL,
                                `food_name` varchar(100) NOT NULL,
                                `recipe_url` varchar(700) NOT NULL,
                                `saved_recipe` mediumtext NOT NULL,
                                PRIMARY KEY (`index_num`),
                                FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `saved_recipe`;

CREATE TABLE `cal` (
                       `input_date` date NOT NULL,
                       `member_num` int NOT NULL,
                       `b_name` varchar(100) NULL,
                       `b_kcal` int DEFAULT 0,
                       `l_name` varchar(100) NULL,
                       `l_kcal` int DEFAULT 0,
                       `d_name` varchar(100) NULL,
                       `d_kcal` int DEFAULT 0,
                       `too_much` mediumtext NULL, -- 과하게 먹은 것.
                       `lack` mediumtext NULL, -- 적게 먹은 것.
                       `recom` mediumtext NULL, -- 권장 식재료 이름만
                       `total_kcal` int DEFAULT 0,
                       `score` int DEFAULT 0, -- 점수 → 마우스 오버시, 혹은 날짜 밑에 표시
                       PRIMARY KEY (`input_date`, `member_num`),
                       FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `cal`;

CREATE TABLE `history` (
                           `ingredient_name` varchar(700) NOT NULL,
                           `member_num` int NOT NULL,
                           `date` date NOT NULL, -- 복합키에 포함되는 date 컬럼
                           `type` varchar(10) NOT NULL CHECK (`type` IN ('c', 'b')), -- c : 소비, b : 버림
                           PRIMARY KEY (`ingredient_name`, `member_num`, `date`), -- 복합키에 date 추가
                           FOREIGN KEY (`ingredient_name`, `member_num`) REFERENCES `stock`(`ingredient_name`, `member_num`) ON DELETE CASCADE
);

select * from `history`;

CREATE TABLE `subscription` (
                                `subscription_id` int auto_increment primary key,
                                `member_num` int NOT NULL,
                                `start_date` date NOT NULL,
                                `end_date` date NOT NULL,
                                FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);

drop table  allergy ;
drop table  history  ;
drop table  user_body_info  ;
drop table  board  ;
drop table  reply  ;
drop table  saved_recipe  ;
drop table  cal ;
drop table member;
drop table  `stock`;
drop table  `complaint`;

-- history 테이블에 더미 데이터 추가
INSERT INTO `history` (`ingredient_name`, `member_num`, `date`, `type`) VALUES
                                                                            ('토마토', 8, '2024-09-12', 'c'),  -- 소비
                                                                            ('당근', 8, '2024-09-13', 'b'),    -- 버림
                                                                            ('감자', 8, '2024-09-14', 'c'),    -- 소비
                                                                            ('상추', 8, '2024-09-15', 'b'),    -- 버림
                                                                            ('양파', 8, '2024-09-16', 'c'),    -- 소비
                                                                            ('마늘', 8, '2024-09-17', 'b'),    -- 버림
                                                                            ('오이', 8, '2024-09-18', 'c'),     -- 소비
                                                                            ('피망', 8, '2024-09-19', 'b'),    -- 버림
                                                                            ('시금치', 8, '2024-09-20', 'c'),  -- 소비
                                                                            ('브로콜리', 8, '2024-09-21', 'c'), -- 소비
                                                                            ('콜리플라워', 8, '2024-09-22', 'b'), -- 버림
                                                                            ('애호박', 8, '2024-09-23', 'c'),  -- 소비
                                                                            ('가지', 8, '2024-09-24', 'b'),    -- 버림
                                                                            ('호박', 8, '2024-09-25', 'c'),    -- 소비
                                                                            ('고구마', 8, '2024-09-26', 'b');  -- 버림

-- stock 테이블에 더미 데이터 추가
INSERT INTO `stock` (`ingredient_name`, `member_num`, `is_having`, `use_by_date`, `update_date`) VALUES
                                                                                                     ('토마토', 8, 1, '2024-10-01', CURRENT_TIMESTAMP),  -- 재고 있음
                                                                                                     ('당근', 8, 0, '2024-09-20', CURRENT_TIMESTAMP),    -- 재고 없음
                                                                                                     ('감자', 8, 1, '2024-10-05', CURRENT_TIMESTAMP),    -- 재고 있음
                                                                                                     ('상추', 8, 0, '2024-09-18', CURRENT_TIMESTAMP),    -- 재고 없음
                                                                                                     ('양파', 8, 1, '2024-10-02', CURRENT_TIMESTAMP),    -- 재고 있음
                                                                                                     ('마늘', 8, 0, '2024-09-15', CURRENT_TIMESTAMP),    -- 재고 없음
                                                                                                     ('오이', 8, 1, '2024-10-07', CURRENT_TIMESTAMP),    -- 재고 있음
                                                                                                     ('피망', 8, 0, '2024-09-22', CURRENT_TIMESTAMP),    -- 재고 없음
                                                                                                     ('시금치', 8, 1, '2024-10-09', CURRENT_TIMESTAMP),  -- 재고 있음
                                                                                                     ('브로콜리', 8, 1, '2024-10-11', CURRENT_TIMESTAMP), -- 재고 있음
                                                                                                     ('콜리플라워', 8, 0, '2024-09-25', CURRENT_TIMESTAMP), -- 재고 없음
                                                                                                     ('애호박', 8, 1, '2024-10-12', CURRENT_TIMESTAMP),  -- 재고 있음
                                                                                                     ('가지', 8, 0, '2024-09-19', CURRENT_TIMESTAMP),    -- 재고 없음
                                                                                                     ('호박', 8, 1, '2024-10-15', CURRENT_TIMESTAMP),    -- 재고 있음
                                                                                                     ('고구마', 8, 0, '2024-09-28', CURRENT_TIMESTAMP);  -- 재고 없음
