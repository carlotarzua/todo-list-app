# ✅ ToDo List App

![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby_3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Devise](https://img.shields.io/badge/Devise-Auth-blue?style=for-the-badge)
![Mailjet](https://img.shields.io/badge/Mailjet-Email-orange?style=for-the-badge)
![CI](https://img.shields.io/badge/CI-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

A full-featured **collaborative task management web app** built with Ruby on Rails. Users can manage personal to-dos with priorities, deadlines, categories, progress tracking, and time logging — and collaborate with teammates via shared team lists. Features automated email reminders, team invitations, and a full CI/CD pipeline with security scanning.

---

## ✨ Features

### 📝 Task Management
- **Full CRUD** — create, view, edit, and delete tasks
- **Priority levels** — High, Medium, Low with custom SQL sort order
- **Due date & time** — timezone-aware scheduling (Central Time)
- **Progress tracking** — 0–100% progress field with validation
- **Categories** — organize tasks with reusable, uniquely-named categories
- **Search** — filter tasks by title or description keyword
- **Archive** — soft-archive completed tasks with a dedicated archived view

### ⏱️ Built-in Time Tracker
- **Start/stop timer** on any task — tracks `start_time`, `end_time`, and accumulates `total_time`
- Displays formatted time as `Xh Ym Zs`

### 🔔 Automated Email Reminders
- Set a reminder per task: **1 hour**, **1 day**, or **1 week** before due
- Uses **ActiveJob** (`ReminderJob`) to schedule the reminder email asynchronously at precisely the right moment
- Emails delivered via the **Mailjet** transactional email API

### 👥 Teams & Collaboration
- Create and manage teams — owners control membership and deletion
- **Invite teammates by email** — sends a styled invitation via `UserMailer`
- **Join teams** via invite link
- Team members share a **team task view** and can be assigned to individual tasks
- **Shared Lists** — teams can create named shared to-do lists scoped to the team

### 🔐 Authentication & Security
- Full auth with **Devise** — register, login, logout, password reset
- **Email confirmation** required to activate new accounts (`:confirmable`)
- **Session timeout** for inactive users (`:timeoutable`)
- Custom `sessions` and `registrations` controllers for extended control
- Passwords hashed with **bcrypt**

### 🤖 CI/CD Pipeline (GitHub Actions)
4 automated jobs run on every push and pull request to `main`:
- `scan_ruby` — Brakeman static security analysis
- `scan_js` — importmap JavaScript dependency audit
- `lint` — RuboCop style enforcement
- `test` — full Rails test suite with a PostgreSQL service container

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Ruby on Rails 7.2 |
| **Language** | Ruby 3.2 |
| **Database** | PostgreSQL |
| **Authentication** | Devise (confirmable, timeoutable, recoverable) |
| **Email** | Mailjet API + ActionMailer |
| **Background Jobs** | ActiveJob (`ReminderJob`) |
| **Frontend** | ERB, Hotwire (Turbo + Stimulus) |
| **Security** | Brakeman, importmap audit |
| **Linting** | RuboCop Rails Omakase |
| **Testing** | Rails test suite, Capybara, Selenium |
| **CI/CD** | GitHub Actions |
| **Deployment** | Puma, Docker-ready |

---

## 🗄️ Data Model

```
User ──────────────── Devise auth (email confirmed, timeoutable)
  ├── has_many :teams (as owner)
  ├── has_and_belongs_to_many :teams
  └── has_many :shared_lists (through :teams)

Team ──────────────── belongs_to :owner (User)
  ├── has_and_belongs_to_many :users
  ├── has_many :to_dos
  └── has_many :shared_lists

SharedList ────────── belongs_to :team
  └── has_many :to_dos

Category ──────────── has_many :to_dos (nullify on destroy)

ToDo ──────────────── Core model
  ├── title, description
  ├── due_datetime (timezone-aware)
  ├── priority (high / medium / low)
  ├── progress (0–100, validated)
  ├── reminder (None / 1 hour / 1 day / 1 week)
  ├── completed (boolean)
  ├── archived (boolean, default: false)
  ├── start_time, end_time, total_time  ← time tracker
  ├── email (task owner)
  ├── assigned_user_id
  ├── belongs_to :category (optional)
  ├── belongs_to :team (optional)
  └── belongs_to :shared_list (optional)
```

---

## 🔁 Key Workflows

**Reminder scheduling — `after_save` callback triggers a background job:**
```
ToDo saved with reminder set
  └── after_save :reminder_sender
        └── ReminderJob.set(wait_until: due_datetime - reminder_time).perform_later(todo)
              └── ReminderMailer.reminder(todo).deliver_now  ← fires at the right moment
```

**Team invitation flow:**
```
Owner submits email → TeamsController#invite
  ├── Find user by email
  ├── Check membership
  └── UserMailer.invite_user(user, team).deliver_later → join link email
```

**Time tracking:**
```
Start → ToDo#start_timer → saves start_time: Time.now
Stop  → ToDo#stop_timer  → total_time += (Time.now - start_time), clears start_time
Display → formatted_total_time → "Xh Ym Zs"
```

---

## 📂 Project Structure

```
todo-list-app/
├── app/
│   ├── controllers/
│   │   ├── todos_controller.rb           # CRUD, timer, archive, search, sort
│   │   ├── teams_controller.rb           # Team CRUD, invite, join
│   │   ├── shared_lists_controller.rb    # Shared lists nested under teams
│   │   └── users/sessions + registrations
│   ├── models/
│   │   ├── to_do.rb         # Reminders, timer methods, archive scopes
│   │   ├── user.rb          # Devise + team associations
│   │   ├── team.rb          # Owner, members, shared lists
│   │   ├── category.rb      # Task categorization
│   │   └── shared_list.rb   # Team-scoped shared task lists
│   ├── jobs/
│   │   └── reminder_job.rb              # Scheduled reminder delivery
│   ├── mailers/
│   │   ├── reminder_mailer.rb           # Due date reminders
│   │   └── user_mailer.rb               # Team invitations
│   └── views/
│       ├── todos/      # index, new, edit, archived, team_todos
│       ├── teams/      # index, show, new, edit
│       ├── shared_lists/
│       └── devise/     # Custom auth views
├── db/
│   ├── schema.rb
│   └── migrate/        # 20+ migrations showing iterative feature development
├── .github/workflows/
│   └── ci.yml          # 4-job CI pipeline
├── Dockerfile
├── docker-compose.yml.example
└── .env.example
```

---

## ⚙️ Getting Started

### Prerequisites

- Ruby 3.2.0
- Rails 7.2
- PostgreSQL
- A [Mailjet](https://www.mailjet.com/) account (free tier works for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/carlotarzua/todo-list-app.git
   cd todo-list-app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Configure environment variables** — copy `.env.example` to `.env`:
   ```env
   DATABASE_USERNAME=your_postgres_username
   DATABASE_PASSWORD=your_postgres_password
   MAILJET_API_KEY=your_mailjet_api_key
   MAILJET_SECRET_KEY=your_mailjet_secret_key
   ```

4. **Set up the database**
   ```bash
   rails db:create db:migrate
   ```

5. **Start the server**
   ```bash
   rails server
   ```

6. Go to `http://localhost:3000` — register and confirm your email to begin.

### 🐳 Docker

```bash
cp docker-compose.yml.example docker-compose.yml
docker-compose up --build
```

---

## 🧪 Running Tests

```bash
rails test            # Unit + integration tests
rails test:system     # Capybara system tests
bin/brakeman          # Security vulnerability scan
bin/rubocop           # Code style check
```

CI runs all of the above automatically on every push via GitHub Actions.

---

## 🌱 Future Improvements

- [ ] Real-time updates with Action Cable (WebSockets)
- [ ] Drag-and-drop task reordering
- [ ] Calendar view for due dates
- [ ] File attachments via Active Storage
- [ ] Redis + Sidekiq for production-grade background job queuing
- [ ] Mobile-responsive redesign

---

## 👩‍💻 About Me

Built by **Carlota Arzúa** — a full-stack developer who enjoys building practical, well-structured Rails applications with real-world features like background jobs, email automation, and team collaboration.

- 💼 [LinkedIn](https://www.linkedin.com/in/carlota-a-53a75b206/)
- 🌐 [Portfolio]()
- 📧 carlotaarzua@gmail.com

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
