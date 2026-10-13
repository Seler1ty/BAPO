# Rails Monolith API (RealWorld-style)

Учебное монолитное API-приложение — «блог-платформа»: пользователи, статьи с тегами,
комментарии.

## Технологический стек

- **Ruby 3.3.8**, **Rails 7.2+** (API-only mode)
- **SQLite** — база данных
- **Devise** — аутентификация на уровне модели (`valid_password?`)
- **JWT** (`jwt`) — stateless-токены для авторизации запросов
- **rack-cors** — CORS для внешнего фронтенда
- Тесты: **RSpec**, **FactoryBot**, **shoulda-matchers**

Точные версии зависимостей — в `Gemfile.lock`.

## Возможности

- Регистрация и вход с выдачей JWT-токена
- Профили: просмотр чужого профиля, изменение своего
- CRUD статей с тегами и фильтрами (по автору, по тегу, по дате)
- Комментарии к статьям с проверкой прав владельца
- Список используемых тегов

## API

Авторизация — заголовок `Authorization: Bearer <token>`.

| Method | Path                              | Описание                          | Auth        |
|--------|-----------------------------------|-----------------------------------|-------------|
| POST   | `/users`                          | Регистрация                       | —           |
| POST   | `/users/login`                    | Вход, возвращает JWT              | —           |
| GET    | `/profiles/:username`             | Профиль пользователя              | —           |
| PUT    | `/user`                           | Обновить свой профиль             | JWT         |
| GET    | `/articles`                       | Список статей (`author`, `tag`)   | —           |
| GET    | `/articles/:slug`                 | Статья                            | —           |
| POST   | `/articles`                       | Создать статью (+ теги)           | JWT         |
| PATCH  | `/articles/:slug`                 | Обновить статью                   | JWT (автор) |
| DELETE | `/articles/:slug`                 | Удалить статью                    | JWT (автор) |
| GET    | `/articles/:slug/comments`        | Список комментариев               | —           |
| POST   | `/articles/:slug/comments`        | Добавить комментарий              | JWT         |
| DELETE | `/articles/:slug/comments/:id`    | Удалить комментарий               | JWT (автор) |
| GET    | `/tags`                           | Список используемых тегов         | —           |

Пример:

```bash
curl -X POST http://localhost:3000/users/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"alice@example.com","password":"password123"}'
```

## Cтруктура проекта

app/
├── controllers/          # HTTP-слой: тонкие контроллеры, JSON-сериализация
│   └── concerns/         # Authenticatable — выпуск и проверка JWT
├── models/               # Домен: ActiveRecord-модели, валидации, scopes, связи
config/
├── routes.rb             # Маршруты API
db/
├── migrate/              # Миграции схемы
├── seeds.rb              # Демо-данные
spec/
├── factories/            # FactoryBot-фабрики
├── models/               # Unit-спеки моделей
├── requests/             # Request-спеки всех эндпоинтов
└── support/              # Хелперы (JWT-заголовки для тестов)

## Запуск
Требуется Ruby 3.3.8 (rbenv/rvm) и Bundler.

```bash
bundle install
rails db:prepare     # создать БД и применить миграции
rails db:seed        # демо-данные (alice / bob, password123)
rails s              # http://localhost:3000
```

## Тесты

```bash
rails db:test:prepare
bundle exec rspec
```

