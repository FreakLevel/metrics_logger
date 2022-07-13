import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import checker from 'vite-plugin-checker'
import FullReload from 'vite-plugin-full-reload'
import WindiCSS from 'vite-plugin-windicss'
import alias from '@rollup/plugin-alias'
import { resolve } from 'path'

export default defineConfig({
  resolve: {
    alias: {
      '@components': resolve(__dirname, './app/frontend/entrypoints/components'),
      '@pages': resolve(__dirname, './app/frontend/entrypoints/pages'),
      '@services': resolve(__dirname, './app/frontend/entrypoints/services'),
      '@utils': resolve(__dirname, './app/frontend/entrypoints/utils')
    }
  },
  plugins: [
    RubyPlugin(),
    checker({ typescript: true }),
    alias(),
    FullReload([
      'config/routes.rb',
      'app/views/**/*'
    ], { delay: 500, always: false }),
    WindiCSS({
      root: __dirname
    })
  ],
})
