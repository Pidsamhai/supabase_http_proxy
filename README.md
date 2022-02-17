<h1 align="center">Proxy Api</h1>

<p align="center">
    <a href="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/build.yml">
    <img src="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/build.yml/badge.svg"/>
    </a>
    <a href="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/deploy.yml">
    <img src="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/deploy.yml/badge.svg"/>
    </a>
    <a href="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/snapshot.yml">
    <img src="https://github.com/Pidsamhai/supabase_http_proxy/actions/workflows/snapshot.yml/badge.svg"/>
    </a>
</p>

* Stable Link https://pidsamhai.github.io/supabase_http_proxy/
* Snapshot Link https://supabase-proxy-api-gui.vercel.app/

### Build flutter app

* install dependencies

```bash
$ cd proxy_api_gui
$ flutter pub get
```

* run

```bash
$ flutter run -d chrome
```

* build

```bash
$ flutter build web --release
```

### Build node app (backend)

* install dependencies

```bash
$ cd functions
$ npm i
```

* run

```bash
$ npm run start
```

* build

```bash
$ npm run build
```