module.exports = {
  root: true,
  env: {
    node: true,
    commonjs: true
  },
  parser: '@typescript-eslint/parser',
  parserOptions: {
    tsconfigRootDir: __dirname,
    project: ['./tsconfig.json'],
    ecmaVersion: 2020
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'google',
    'prettier'
  ],
  ignorePatterns: [
    'lib/**/*',
    '.eslintrc.js' // 忽略自身文件检查
  ],
  rules: {
    'valid-jsdoc': ['off'] // 完全禁用 JSDoc 检查
  }
};