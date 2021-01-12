# 42_ft_server
42課題：ft_server



## 実行例

### イメージのビルド

```
docker build -t ttt .
```

### イメージの実行

```
docker run -p 8080:80 -p 4443:443 -e AUTOINDEX=on -it ttt
```



## 動作確認環境

### ホスト

```
Ubuntu 18.04.4 LTS
Docker version 19.03.6, build 369ce74a3c
```

### コンテナ

```
Debian GNU/Linux 10 (buster) 10.7
nginx/1.14.2
mysql  Ver 8.0.22 for Linux on x86_64 (MySQL Community Server - GPL)
phpMyAdmin-5.0.4
wordpress-5.6-ja
```



