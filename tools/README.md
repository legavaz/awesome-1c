## Скрипты помошники актуализации списка

### Требования:

* установленный `VSC` с пакетом `1C (BSL)`
* `oscript` - http://oscript.io 

### Запуск скриптов

* `git submodule update --init --recursive`
* `Ctrl+Shift+B` - в Visual Studio Code

или напрямую из консоли - например:
`oscript ./tools/github-stats/bsl-github-stats.os generate-markdown --markdown-path data\\README.md`

### Просмотр данных

* смотрите каталог `data/README.md` - результатом работы скрипта является файл Markdown с текущей статистикой
