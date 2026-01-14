// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const storageKey = "theme"
const root = document.documentElement

const updateThemeUI = (isDark) => {
  document.querySelectorAll("[data-theme-toggle]").forEach((toggle) => {
    toggle.checked = isDark
  })
  document.querySelectorAll("[data-theme-knob]").forEach((knob) => {
    knob.classList.toggle("translate-x-5", isDark)
  })
  document.querySelectorAll("[data-theme-label]").forEach((label) => {
    label.textContent = isDark ? "Dark" : "Light"
  })
}

const applyTheme = (theme) => {
  const isDark = theme === "dark"
  if (isDark) {
    root.setAttribute("data-theme", "dark")
  } else {
    root.removeAttribute("data-theme")
  }
  updateThemeUI(isDark)
}

const bindThemeToggles = () => {
  const toggles = document.querySelectorAll("[data-theme-toggle]")
  toggles.forEach((toggle) => {
    if (toggle.dataset.themeBound === "true") {
      return
    }
    toggle.dataset.themeBound = "true"
    toggle.addEventListener("change", () => {
      const next = toggle.checked ? "dark" : "light"
      localStorage.setItem(storageKey, next)
      applyTheme(next)
    })
  })
  const stored = localStorage.getItem(storageKey) || "light"
  applyTheme(stored)
}

document.addEventListener("turbo:load", bindThemeToggles)
