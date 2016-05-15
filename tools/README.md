## Скрипты помошники актуализации списка

Требования:

* установленный `VSC` с пакетом `ruby`
* собственно сам `ruby` с пакетами `octokit, faraday-http-cache, mechanize, nokogiri`
* зарегистрированный аккаунт на GItHub
* etc ;-)

### Запуск скриптов

* установите переменные окружения на время запуска `GITHUB_USER` и `GITHUB_PASSWORD`
* `Ctrl+Shift+B` - в Visual Studio Code

или напрямую из консоли - например `ruby github-search.rb`

> Gemfile специально не создавался, чтобы враги не догадались как делать 'gem install mechanize`
