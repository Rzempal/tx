# 🎨 DESIGN - Standardy Wizualne i UX

> **Powiązane:** [Standardy Kodu](conventions.md) | [Architektura](_00_NEWPLUS/Templates/docs/architecture.md)

---

## 🏛️ Filozofia Projektowa

Działamy w myśl zasady **"Good Design is Good Business"** oraz **"Pragmatyzmu Linusa"**. Eliminujemy zbędne dekoracje na rzecz czytelności i użyteczności.

- **KISS (Keep It Simple, Stupid):** Jeśli element nie pełni funkcji, usuń go.
- **Consistency:** Spójność buduje zaufanie i zmniejsza obciążenie poznawcze.
- **Accessibility First:** Design, który nie jest dostępny, jest popsuty.

---

## 🎨 Design Tokens (Fundamenty)

### Kolorystyka

Stosujemy system zmiennych (CSS Variables) oparty na skali HSL/RGB.

| Kategoria | Opis | Przykładowy Token |
| --- | --- | --- |
| **Primary** | Główny kolor marki (CTA) | `--color-primary` |
| **Secondary** | Akcenty, tła sekcji | `--color-secondary` |
| **Neutral** | Tekst, tła, krawędzie | `--color-text`, `--color-bg` |
| **Semantic** | Informacja (Success, Error, Warning) | `--color-error` |

### Typografia

- **Font-family:** Systemowe stosy fontów (inter, sans-serif) dla wydajności.
- **Skala:** Modular scale (np. 1.250) dla zachowania rytmu pionowego.

---

## 📐 Layout i Siatka

Stosujemy **8px Grid System**. Wszystkie marginesy, paddingi i rozmiary komponentów powinny być wielokrotnością 8px (lub 4px dla mikroskali).

- **Mobile First:** Zawsze zaczynaj projekt od najmniejszego ekranu.
- **Container Strategy:** Standardowe szerokości kontenerów dla spójności.

---

## 🧩 Komponenty (Atomic Design)

Komponenty budujemy od najprostszych elementów (Atomy) do złożonych organizmów.

1. **Atomy:** Button, Input, Label, Icon.
2. **Molekuły:** SearchBar (Input + Button), CardHeader.
3. **Organizmy:** Navbar, Sidebar, ProductGrid.

---

## ♿ Dostępność (WCAG 2.1)

- **Kontrast:** Tekst musi spełniać wymóg minimum 4.5:1.
- **Interakcja:** Wszystkie elementy muszą być obsługiwane klawiaturą (Focus states!).
- **Semantyka:** Używamy poprawnych tagów HTML (`<nav>`, `<main>`, `<button>` zamiast `<div>`).

---

## 🚀 UX Principles

- **Optimistic UI:** Natychmiastowa reakcja na akcję użytkownika (feedback).
- **Loading States:** Zawsze pokazuj szkielety (Skeletons) podczas ładowania danych.
- **Empty States:** Puste stany powinny prowadzić dewelopera/użytkownika do akcji.

---

> 🔗 **Figma:** [Wklej tutaj link do projektu w Figmie]
> 📅 **Ostatnia aktualizacja:** 2026-01-14
