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
    'google'
  ],
  ignorePatterns: [
    'lib/**/*',
    '.eslintrc.js' // 忽略自身文件检查
  ],
  rules: {
    'no-undef': 'off',
    'quotes': 'off',
    'object-curly-spacing': 'off',
    'operator-linebreak': 'off',
    'comma-dangle': 'off',
    'padded-blocks': 'off',
    'max-len': 'off'
  }
};