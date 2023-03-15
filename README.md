## Общая информация
* Язык программирования: **Lua** (Версия 5.3.3)
* Реализация многопоточности: **thread pool**
* Сетевое взаимодействие: **socket-lanes** (немодифицированный оригинальный socket несовместим с многопоточной обработкой соединений)
* Потоки: **effil**

## Конфигурация
Конфигурационный файл: **httpd.conf**

### Параметры:
* host - адрес сервера (по умолчанию `"*"`, если запускается в Docker-контейнере, то изменения не рекомендуются)
* port - порт, на котором слуаются соединения (по умолчанию `80`)
* cpu_limit - Максимальное колическтво количество потоков, в котором будут обрабатываться соединения. Рекомендуется устанавливать число, равное числу ядер в системе - 1 (По умолчанию `1`)

## Использование
Два варианта:
* Запуск без контейнера 
```
lua main.lua
```

* Запуск в контейнере
1. Сборка. Dockerfile находится в корне
 ```
 sudo docker build . -t luaserver
 ``` 
 или воспользоваться скриптом в папке *scripts* 
 ```
 lua buildDocker.lua
 ```
2. Запуск - 
```
sudo docker run -v /home/fackoff/code/6_sem_tech/HighloadHW2/httpd.conf:/server/httpd.conf:ro -p 127.0.0.1:80:80 --name luaserver -t luaserver
```
или воспользоваться скриптом в папке *scripts* 
```
lua startDocker.lua
```

## Тестирование
* Запуск функционального тестирования на сервер - c помощью [скрипта тестирования](https://github.com/init/http-test-suite) (Если сервер запущен не на 80 порте, то для тесированя потребуется ручное изменение порта в модуле тестирования)
* Сборка контейнера с Nginx 
```
sudo docker build -t nginxserver -f nginx.Dockerfile .
```
* Запуск контейнера с Nginx 
```
sudo docker run -p 127.0.0.1:80:80 --name nginxserver -t nginxserver
```
* Запуск нагрузочного тестирования на сервер через скрипт в папке scripts
```
lua perfTest.lua
```

## Сравнительная оценка результатов тестирования
Нагрузочное тестирование производилось с помощью Apache HTTP server benchmarking tool с 4 потоками для обоих серверов

* **LuaServerRPS** = 1338.07
* **nginx_RPS** = 1997.38

LuaServerRPS/nginx_RPS ~ **0.67**

### Сервер
1 поток:
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
2 потока:
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
4 потока:
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

### Nginx
4 воркера:
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