# ParserEduCSVDataProject
***处理OralEdu压缩包数据，用于识别训练***

### 一.多并发解析OralEdu日志文件

### 1.用法：perl MutliProcess.pl input threadnum 

#### 2.引入：
- a.script::ParserEduCSVData;

#### 3.输入：
- a.input : 压缩gz包的列表；
- b.threadnum : 并发线程数；

#### 4.说明：
- a.其中threadnum不宜设置过大，应根据机器磁盘读写效率设置；

#### 5.输出：
- a.在res目录下；

### 二.多并发抓取opus/mp3文件

#### 用法：perl MutliProcess.pl input threadnum 

#### 1.引入：
- a.script::DownloadEduOpusData;

#### 2.输入：
- a.input : 待处理文件；
- b.threadnum : 并发线程数；

#### 3.说明：
- a.其中threadnum不宜设置过大，建议设置为100，具体根据网络出口带宽设置；

#### 4.输出：
- 实时写入elasticSearch；
