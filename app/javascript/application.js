// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const themeKey = "theme"
const textSizeKey = "textSize"
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
      localStorage.setItem(themeKey, next)
      applyTheme(next)
    })
  })
  const stored = localStorage.getItem(themeKey) || "light"
  applyTheme(stored)
}

const updateTextUI = (isLarge) => {
  document.querySelectorAll("[data-text-toggle]").forEach((toggle) => {
    toggle.checked = isLarge
  })
  document.querySelectorAll("[data-text-knob]").forEach((knob) => {
    knob.classList.toggle("translate-x-5", isLarge)
  })
  document.querySelectorAll("[data-text-label]").forEach((label) => {
    label.textContent = isLarge ? "Groß" : "Normal"
  })
}

const applyTextSize = (size) => {
  const isLarge = size === "large"
  if (isLarge) {
    root.setAttribute("data-text-size", "large")
  } else {
    root.removeAttribute("data-text-size")
  }
  updateTextUI(isLarge)
}

const bindTextToggles = () => {
  const toggles = document.querySelectorAll("[data-text-toggle]")
  toggles.forEach((toggle) => {
    if (toggle.dataset.textBound === "true") {
      return
    }
    toggle.dataset.textBound = "true"
    toggle.addEventListener("change", () => {
      const next = toggle.checked ? "large" : "normal"
      localStorage.setItem(textSizeKey, next)
      applyTextSize(next)
    })
  })
  const stored = localStorage.getItem(textSizeKey) || "normal"
  applyTextSize(stored)
}

document.addEventListener("turbo:load", () => {
  bindThemeToggles()
  bindTextToggles()
})
