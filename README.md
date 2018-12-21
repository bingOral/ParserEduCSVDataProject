# ParserEduCSVDataProject

## 1.多并发解析教育日志文件

perl MutliProcess.pl input threadnum 

引入：
   a.script::ParserEduCSVData;
   
输入：
   a.input : 压缩gz包的列表；
   b.threadnum : 并发线程数；

备注：
   a.其中threadnum不宜设置过大，应根据机器磁盘读写效率设置；

输出：
   a.在res目录下；

## 2.多并发抓取opus/mp3文件

perl MutliProcess.pl input threadnum 

引入：
   a.script::DownloadEduOpusData;

输入：
   a.input : 第一步的输出结果；
   b.threadnum : 并发线程数；

备注：
   a.其中threadnum不宜设置过大，建议设置为100，具体根据网络出口带宽设置；
   b.根据http请求头信息，拉取opus或MP3文件；

输出：
   实时写入elasticSearch；
