yum update -y
yum install nginx -y
yum install docker-ce docker-ce-cli containerd.io -y
yum install httpd-tools -y
mkdir -p /etc/nginx/db
echo "输入鉴权的密码 用户名为hkzhao"
htpasswd -c /etc/nginx/db/passwd.db hkzhao
systemctl start docker
# 输入密码
echo "输入证书生成的秘钥"
openssl genrsa -des3 -out server.pass.key 2048 
openssl rsa -in server.pass.key -out server.key
# -req 生成证书签名请求
# -new 新生成
# -key 私钥文件
# -out 生成的CSR文件
# -subj 生成CSR证书的参数
openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=Shenzhen/L=Shenzhen/O=cetc/OU=cetc/CN=hkz.cetc.cn"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
# crt csr
rm -rf /etc/nginx/nginx.conf.default
cp server.crt /etc/nginx/server.crt
cp server.csr /etc/nginx/server.csr
cp server.key /etc/nginx/server.key
systemctl start nginx
nginx -t
docker pull hkzhao123/projector-clion #cpp版本
docker pull hkzhao123/projector-idea #java版本
rm -rf /etc/nginx/nginx.conf
echo "worker_processes  1;

events {
    worker_connections  1024;
}


http {
    # include       mime.types;
    # default_type  application/json;

    sendfile        on;
    keepalive_timeout  300;

    gzip  on;

    server {
        listen       443 ssl;
        keepalive_timeout   300;
        server_name  localhost;
    
        location /idea/ {
            auth_basic "secret";
            auth_basic_user_file /etc/nginx/db/passwd.db;
            proxy_pass http://127.0.0.1:8887/;
            client_max_body_size 10m; #表示最大上传10M，需要多大设置多大。
            #设置主机头和客户端真实地址，以便服务器获取客户端真实IP
            proxy_http_version 1.1; 
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "Upgrade";  
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            # proxy_set_header X-Forwarded-Scheme \$scheme;
        }
        location /clion/ {
            auth_basic "secret";
            auth_basic_user_file /etc/nginx/db/passwd.db;
            proxy_pass http://127.0.0.1:8886/;
            client_max_body_size 10m; #表示最大上传10M，需要多大设置多大。
            #设置主机头和客户端真实地址，以便服务器获取客户端真实IP
            proxy_http_version 1.1; 
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "Upgrade";  
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            # proxy_set_header X-Forwarded-Scheme \$scheme;
        }
        ssl_certificate      server.crt;
        ssl_certificate_key  server.key;
        # #减少点击劫持
        add_header          X-Frame-Options DENY;
        #禁止服务器自动解析资源类型
        add_header          X-Content-Type-Options nosniff;
        # 防XSS攻击
        add_header          X-Xss-Protection 1;
        #优先采取服务器算法
        ssl_prefer_server_ciphers on;
        #
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         HIGH:!aNULL:!MD5;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;
    }

}" > /etc/nginx/nginx.conf
nginx -t
nginx -s reload
docker run --rm -p 8887:8887 -it -d hhkzhao123/idea-u:latest
docker run --rm -p 8886:8887 -it -d hkzhao123/projector-clion:1.0.0
