import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import checker from 'vite-plugin-checker'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    checker({ typescript: true })
  ],
})
