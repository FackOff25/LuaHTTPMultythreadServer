## General Information
* Language: **Lua** (version 5.3.3)
* Multythread realisation: **thread pool**
* Web api lib: **socket-lanes** (Not modified original socket isn't compatitable multythreading)
* Thread api lin: **effil**

## Configuration
Configuration file: **luaServer.conf** in config folder

### Параметры:
* host - server adress (`"*"` by deafauly, not recomended to modify if is launched in Docker-container)
* port - port. Unexpecting (`80` by default)
* serve_folder - directory statics will be served from (by default will serve from directory it is launched at)
* cpu_limit - max number of threads to serve files at. (`1` by default)

## Usage
Two variations
* Without Docker:
```
lua main.lua
```

* Within Docker


1. Build. The Dockerfile in the root.
 ```
 sudo docker build . -t luaserver
 ``` 
 or use script in *scripts*  folder
 ```
 lua buildDocker.lua
 ```
2. Launch  
```
sudo docker run -v /home/fackoff/code/6_sem_tech/HighloadHW2/config/luaServer.conf:/server/config/luaServer.conf:ro -p 127.0.0.1:80:80 --name luaserver -t luaserver
```
or use script in *scripts*  folder
```
lua startDocker.lua
```
or use script in *scripts*  folder for both steps
```
 lua buildAndStartDocker.lua
 ```
## Testing
* Functional testing on server with [testing script](https://github.com/init/http-test-suite) (If server is listening not 80 port then its needed to change the port in script manually)

* Nginx container build.
```
sudo docker build -t nginxserver -f nginx.Dockerfile .
```
* Launch Nginx container
```
sudo docker run -p 127.0.0.1:80:80 --name nginxserver -t nginxserver
```
* Perfomance testing of server via script in scripts folder
```
lua perfTest.lua
```

## Comparing table
Perfomance testing was implemented with Apache HTTP server benchmarking tool

Таблица сравнения RPS:
|Потоки/воркеры|1 |2      |4      |8      |12     |
|---------|-------|-------|-------|-------|-------|
|Nginx    |1869.00|1985.14|[1997.38](#4-workers)|2120.92|2024.02|
|LuaServer|[201.96](#1-thread) |[386.17](#2-threads) |[1338.07](#4-threads)|[4592.80](#8-threads)|[2650.80](#12-threads)|
|Ratio    |0.1    |0,19   |0,67   |2,1    |1,3    |

12 threads is maximum of the maching the testing was on

### LuaServer
## 1 thread:
[To RPS table](#comparing-table)

```
Server Software:        LuaServer
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   4.951 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      954967000 bytes
HTML transferred:       954824000 bytes
Requests per second:    201.96 [#/sec] (mean)
Time per request:       99.029 [ms] (mean)
Time per request:       4.951 [ms] (mean, across all concurrent requests)
Transfer rate:          188346.32 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:     5   98  11.3     98     123
Waiting:        2   95  11.2     95     118
Total:          6   98  11.3     98     123

Percentage of the requests served within a certain time (ms)
  50%     98
  66%    102
  75%    105
  80%    106
  90%    109
  95%    113
  98%    117
  99%    119
 100%    123 (longest request)
```
## 2 threads:
[To RPS table](#comparing-table)

```
Server Software:        LuaServer
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   2.590 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      954967000 bytes
HTML transferred:       954824000 bytes
Requests per second:    386.17 [#/sec] (mean)
Time per request:       51.790 [ms] (mean)
Time per request:       2.590 [ms] (mean, across all concurrent requests)
Transfer rate:          360138.30 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:    24   51   4.6     51      71
Waiting:        2   48   4.6     47      68
Total:         24   51   4.5     51      71

Percentage of the requests served within a certain time (ms)
  50%     51
  66%     52
  75%     53
  80%     54
  90%     56
  95%     59
  98%     65
  99%     67
 100%     71 (longest request)
```
## 4 threads:
[To RPS table](#comparing-table)

```
Server Software:        LuaServer
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   0.747 seconds
Complete requests:      1000
Failed requests:        1285
   (Connect: 0, Receive: 0, Length: 659, Exceptions: 626)
Total transferred:      338058318 bytes
HTML transferred:       338007696 bytes
Requests per second:    1338.07 [#/sec] (mean)
Time per request:       14.947 [ms] (mean)
Time per request:       0.747 [ms] (mean, across all concurrent requests)
Transfer rate:          441745.06 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.3      0       2
Processing:     0   15  25.0      1     163
Waiting:        0   10  13.8      0      74
Total:          1   15  24.8      1     163

Percentage of the requests served within a certain time (ms)
  50%      1
  66%     27
  75%     29
  80%     29
  90%     32
  95%     46
  98%    140
  99%    150
 100%    163 (longest request)
```

## 8 threads:
[To RPS table](#comparing-table)

```
Server Software:        LuaServer
Server Hostname:        127.0.0.1
Server Port:            80

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   0.218 seconds
Complete requests:      1000
Failed requests:        1939
   (Connect: 0, Receive: 0, Length: 980, Exceptions: 959)
Total transferred:      20940193 bytes
HTML transferred:       20936904 bytes
Requests per second:    4592.80 [#/sec] (mean)
Time per request:       4.355 [ms] (mean)
Time per request:       0.218 [ms] (mean, across all concurrent requests)
Transfer rate:          93920.08 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       2
Processing:     0    4  20.0      0     170
Waiting:        0    1   4.5      0      43
Total:          0    4  19.9      1     170

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      2
  98%    122
  99%    129
 100%    170 (longest request)
```
## 12 threads:
[To RPS table](#comparing-table)

```
Server Software:        LuaServer
Server Hostname:        127.0.0.1
Server Port:            80

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   0.377 seconds
Complete requests:      1000
Failed requests:        1758
   (Connect: 0, Receive: 0, Length: 892, Exceptions: 866)
Total transferred:      110769091 bytes
HTML transferred:       110752360 bytes
Requests per second:    2650.80 [#/sec] (mean)
Time per request:       7.545 [ms] (mean)
Time per request:       0.377 [ms] (mean, across all concurrent requests)
Transfer rate:          286744.53 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       1
Processing:     0    7  22.8      0     148
Waiting:        0    3  11.7      0      89
Total:          1    7  22.7      1     148

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%     17
  95%     45
  98%    127
  99%    137
 100%    148 (longest request)
```
### Nginx
## 4 workers:

[To RPS table](#comparing-table)
```
Server Software:        nginx/1.23.3
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /httptest/wikipedia_russia.html
Document Length:        954824 bytes

Concurrency Level:      20
Time taken for tests:   0.501 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      955062000 bytes
HTML transferred:       954824000 bytes
Requests per second:    1997.38 [#/sec] (mean)
Time per request:       10.013 [ms] (mean)
Time per request:       0.501 [ms] (mean, across all concurrent requests)
Transfer rate:          1862907.61 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:     2   10   4.7      9      52
Waiting:        0    1   4.5      0      50
Total:          2   10   4.7      9      52

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%     10
  80%     10
  90%     10
  95%     11
  98%     33
  99%     35
 100%     52 (longest request)
```