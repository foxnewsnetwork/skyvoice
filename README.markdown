Skyvoice
==

Where I experiment with and build a karaoke site

## To develop
Start in the skyvoice directory

Turn on front end ember:
```shell
cd fate
ember serve --proxy http://localhost:4201
```

Turn on node live backend:
```shell
cd destiny
lsc app.js
```

Turn on rails
```
rails s
```

## In production
You'll need to build the front end, turn on the nginx, and turn on the rails

Build frontend
```shell
cd fate
ember build --environment production
```

Turn on node and rails
```shell
./bin/start_production
```

Refresh nginx
```shell
sudo nginx -s reload
```