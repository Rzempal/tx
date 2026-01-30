# 🚀 tx

> **Tecnomatix plugins**

---

## 📋 Spis Treści

- [Szybki Start](#-szybki-start)
- [Stack Technologiczny](#-stack-technologiczny)
- [Dokumentacja](#-dokumentacja)
- [Rozwój i Standardy](#-rozwój-i-standardy)

---

## ⚡ Szybki Start

### Wymagania

- Node.js (v20+)
- Python (v3.12+)
- Docker & Docker Compose

### Instalacja

```bash
# Klonowanie repozytorium
git clone <repo-url>
cd <project-dir>

# Instalacja zależności
npm install
pip install -r requirements.txt
```

### Uruchomienie (Dev)

```bash
npm run dev
# lub
docker-compose up
```

---

## 🛠 Stack Technologiczny

| Warstwa          | Technologia                       |
| ---------------- | --------------------------------- |
| **Frontend**     | Next.js, TypeScript, Tailwind CSS |
| **Backend**      | Django REST Framework, Python     |
| **Database**     | PostgreSQL                        |
| **Cache/Search** | Redis, Elasticsearch              |
| **DevOps**       | Docker, GitHub Actions            |

---

## 📚 Dokumentacja

Pełna dokumentacja znajduje się w katalogu `docs/`:

| Dokument                                                | Opis                              |
| ------------------------------------------------------- | --------------------------------- |
| 🏛️ **[Architektura](docs/architecture.md)**             | Przegląd systemu, warstwy, stack. |
| 📊 **[Model Danych](docs/database.md)**                 | ERD, encje, migracje.             |
| 🧪 **[Testowanie](docs/standards/testing.md)**          | Strategia TDD, standardy testów.  |
| 🚀 **[Deployment](docs/deployment.md)**                 | Instrukcja wdrożenia i CI/CD.     |
| 🔐 **[Bezpieczeństwo](docs/security.md)**               | Polityka bezpieczeństwa.          |
| 📏 **[Standardy](docs/standards/conventions.md)**       | Konwencje kodu, nazewnictwo.      |
| 🧠 **[Lessons Learned](docs/lessons-learned.md)**       | Dziennik doświadczeń i wniosków.  |
| 📝 **[Logging](docs/logging.md)**                       | System logowania i monitoring.    |
| 🎨 **[Design](docs/design.md)**                         | Standardy wizualne i UX.          |
| 👁️ **[Design Review](docs/standards/design-review.md)** | Checklist Visual QA.              |

---

## 🤝 Rozwój i Standardy

Pracujemy zgodnie z zasadami "Clean Code" i filozofią Linusa Torvaldsa. Przed rozpoczęciem pracy
zapoznaj się z:

- [Przewodnik Dokumentacji](contributing.md)
- [Standardy Kodowania](conventions.md)
- [Zasady Code Review](code-review.md)

---

> 📅 **Ostatnia aktualizacja:** 2026-01-14
