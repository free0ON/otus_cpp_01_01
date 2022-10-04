# Otus C++ Developer 09 2022 ci/cd test farm

# Homework 01

https://otus.ru/lessons/cpp-professional/

https://youtu.be/LZwEtbc9gEA

https://docs.github.com/en/actions/using-workflows

https://cmake.org/cmake/help/latest/guide/tutorial/index.html

https://git-scm.com/book/ru/v2

https://cakeinpanic.medium.com/github-actions-%D0%B1%D0%B0%D0%B7%D0%B0-2501445e7392

# Project properties set by variables in cmake.yml

PRJ_NAME: Project name without spaces

PRJ_VERSION_MAJOR: Project magor version

PRJ_VERSION_MINOR: Project minor version

PRJ_VERSION_PATCH: Project patch version used as ${{ github.run_number }}

PRJ_DESCRIPTION: Peoject description without spaces

PRJ_HOMEPAGE_URL: Progect homepage

PRJ_CMAKE_MIN_VERSION: CMake minimum version required

EMAIL_CONTACT: Email for notification

# Test options ON/OFF
BOOST_TEST: ON 

GOOGLE_TEST: ON

CATCH2_TEST: ON

Задание 1
Создание сборочной фермы
Цель задания – создание сборочной фермы для простого приложения c запуском тестов и генерацией релизов.
Написать программу, выводящую на консоль две строки:

build N
Hello, World!

, где вместо N должен выводится текущий номер сборки. Запустить на этапе сборки тесты,
проверяющие валидность номера версии. Выложить исходные тексты в репозиторий на github.

Настроить Github Actions workflow для автоматической сборки проекта на каждый коммит. Так же
настроить автоматический выпуск релиза либо на каждый коммит, либо по созданию тэга.

В связи с недавними обновлениями политики безопасности для работы с репозиторием из консоли
потребуется создать access token.

Варианты организации исходников по самостоятельным работам:
- отдельный репозиторий под каждую работу
- отдельная ветка в одном и том же репозитории под каждую работу
- отдельная директория в одной и той же ветке одного и того же репозитория

Самоконтроль
- версия пакета увеличивается от сборки к сборке
- актуальная версия выводится в приветственном сообщении
- пакет `helloworld`, содержащий исполняемый файл `helloworld`, опубликован в качестве релиза в репозитории
Проверка

Задание считается выполненным успешно, если после установки скаченного из релиза пакета:

apt update && apt install -y helloworld-0.0.X-Linux.deb

(вместо X – номер билда), запуска бинарного файла:

helloworld_cli

появилось сообщение:
 Version: X
 Hello, World!
(вместо X – опять же, номер билда).

Дополнительное упражнение
Добавить unit-тест, который будет полностью повторяет предложенный в материалах вебинара тест
test_version.cpp, но сделать его с использованием GoogleTest framework. GoogleTest при этом либо
подключить к репозиторию в качестве submodule и собрать вместе с тестом, либо установить на
этапе подготовке к сборке через Github Actions.
