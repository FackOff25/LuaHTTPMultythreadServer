FROM nginx

WORKDIR /etc/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY testing-module/httptest /etc/nginx/static/httptest

EXPOSE 80