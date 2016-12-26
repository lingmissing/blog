title: yarn的安装与npm的对比使用
date: 2016-12-26 14:21:14
tags: [yarn]
categories: 包管理工具
---

# 安装yarn

Mac通过 [包管理工具](http://brew.sh/)来安装，若已经安装此工具，执行 
  
```bash
brew update
brew install yarn
```
<!-- more -->
# 命令行对比

## 初始化项目

```bash
// yarn
yarn init

// npm 
npm init
```

## 添加依赖包

```bash
// yarn 
yarn add [package]
yarn add [package]@[version]
yarn add [package]@[tag]

// npm
npm install [package] --save
```

```bash
// yarn 
yarn add [package] --dev

// npm
npm install [package] --save-dev
```

## 更新依赖包

```bash
// yarn
yarn upgrade [package]
yarn upgrade [package]@[version]
yarn upgrade [package]@[tag]

// npm
npm update  [package] --save
```

## 移除依赖包

```bash
// yarn
yarn remove [package]

// npm
npm uninstall [package] --save
```

## 安装所有依赖包

```bash
yarn
// or
yarn install
```

```bash
// npm
npm install
```

# 其他相关命令

```bash
npm link
yarn link
```
```bash
npm outdated
yarn outdated
```
```bash
npm publish
yarn publish
```
```bash
npm run
yarn run
```
```bash
npm cache clean
yarn cache clean
```
```bash
npm login
yarn login (logout 同理)
```
```bash
npm test
yarn test
```

# yarn 独有的命令

```
// 检查为什么安装package
yarn why [package]
```