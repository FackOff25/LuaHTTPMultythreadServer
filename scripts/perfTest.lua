-- Script for perfomance testing of server with 1000 requests, 20 parallel requests and maximum 1 second for response
os.execute("ab -n 1000 -c 20 -s 1 127.0.0.1:80/httptest/wikipedia_russia.html");
