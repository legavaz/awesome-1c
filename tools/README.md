# Скрипты помошники актуализации списка

## Требования

* установленный `VSC` с пакетом `1C (BSL)`
* `oscript` - http://oscript.io

## Запуск скриптов

* `git submodule update --init --recursive` - обновление подмодулей скриптов
* `search-start.cmd` - запуск поиска

или напрямую из консоли:

`oscript ./tools/github-stats/bsl-github-stats.os generate-markdown --markdown-path data\\README.md`

## Просмотр данных

* смотрите каталог `data/README.md` - результатом работы скрипта является файл Markdown с текущей статистикой
