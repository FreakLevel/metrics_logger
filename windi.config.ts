import { defineConfig } from 'vite-plugin-windicss'

export default defineConfig({
  attributify: {
    prefix: 'w:'
  },
  extract: {
    include: ['app/frontend/**/*.tsx']
  }
})