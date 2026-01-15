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
  document.querySelectorAll("[data-theme-switch]").forEach((switchEl) => {
    switchEl.classList.toggle("is-on", isDark)
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
  document.querySelectorAll("[data-text-switch]").forEach((switchEl) => {
    switchEl.classList.toggle("is-on", isLarge)
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

const bindRetroToggles = () => {
  const toggles = document.querySelectorAll("[data-retro-toggle]")
  toggles.forEach((toggle) => {
    if (toggle.dataset.retroBound === "true") {
      return
    }
    toggle.dataset.retroBound = "true"
    const container = toggle.closest("form")
    const field = container?.querySelector("[data-retro-field]")
    const knob = toggle.closest("label")?.querySelector("[data-retro-knob]")
    const label = toggle.closest("label")?.querySelector("[data-retro-label]")
    const switchEl = toggle.closest("label")?.querySelector("[data-retro-switch]")
    const dateInput = field?.querySelector("input[type='date']")

    const sync = () => {
      const isOn = toggle.checked
      if (field) {
        field.classList.toggle("hidden", !isOn)
      }
      if (knob) {
        knob.classList.toggle("translate-x-5", isOn)
      }
      if (switchEl) {
        switchEl.classList.toggle("is-on", isOn)
      }
      if (label) {
        label.textContent = isOn ? "An" : "Aus"
      }
      if (dateInput) {
        dateInput.disabled = !isOn
      }
    }

    toggle.addEventListener("change", sync)
    sync()
  })
}

document.addEventListener("turbo:load", () => {
  bindThemeToggles()
  bindTextToggles()
  bindRetroToggles()
})
