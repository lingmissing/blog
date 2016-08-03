---
title: Git+Hexo搭建静态博客网站
date: 2016-03-24 14:28:09
tags: [Git,hexo]
---
# 安装环境 #
### 安装Git ###
下载地址：[https://git-scm.com/download/](https://git-scm.com/download/)
### 安装node.js ###
下载地址： [http://nodejs.org/download/](http://nodejs.org/download/)
# 配置Github #
### 建立github仓库 ###

仓库命名规范：

- 【your_user_name.github.com】

访问域名：your_user_name.github.io

- 【your_user_name】

访问域名：username.github.com/your_user_name

- 注意：github账户必须已经邮箱验证过（github---setting---email）

- 注意：此处假设仓库名为hexo.github.com，此仓库存在两个分支，master作为自动发布的分支，gh-pages作为本地修改并发布的分支，首先将两个分支内容清空

<!--more-->

### 设置全局 ###

    $ git config --global user.name "name" 配置username
    $ git config --global user.email "邮箱" 配置邮箱

### 设置ssh ###
设置rsa的数字指纹，一个是公钥，一个是私钥。公钥要提交到github上，私钥需要自己保存

	ssh-keygen -t rsa -C "邮箱"
如何提交到github？

找到github---setting---SSH keys，添加本地rsa公钥（C:\Users\Administrator\.ssh\id_rsa.pub）

### 验证ssh key ###
用本地的私钥和github的公钥进行匹配

    ssh -T git@github.com
### 生成github页面 ###

找到仓库的setting，到GitHub Pages，点击 Launch automatic page generator，点击continue to layout生成基本页面。
  

# hexo配置 #
### 安装hexo ###

    npm install -g hexo

说明地址：[https://hexo.io/zh-cn/](https://hexo.io/zh-cn/)

### 初始化设置 ###

将hexo.github.io拉到本地

    $ git clone 地址
创建并切换到gh-pages分支

    $ git checkout -b gh-pages
删除该分支的所有数据并提交

    $ git add .
	$ git commit -m "删除数据"
	$ git push origin gh-pages
配置博客

    $ hexo init
当输出

	[info] Copying data
	[info] You are almost done! Don’t forget to run npm install before >you start blogging with Hexo!

需要安装 hexo-deployer-git（新版的博客默认不支持github上传方式）

    npm install hexo-deployer-git —save

安装node_modules，运行

    npm install

### 开启hexo服务 ###

	$ hexo server
    [info] Hexo is running at http://localhost:4000/. Press Ctrl+C to stop.

表明Hexo Server已经启动了，在浏览器中打开 localhost:4000/，这时可以看到Hexo已为你生成了一篇blog。你可以按Ctrl+C 停止Server。本地修改后可刷新访问。


### 创建博文 ###

运行命令创建文章，生成My New Post.md文件，编辑此文件发布内容。
 
   	$ hexo new "My New Post"

### 生成静态的网站文件 ###

执行下面的命令，将markdown文件生成静态网页。

	$ hexo generate

该命令执行完后，会在 D:\Hexo\public\ 目录下生成一系列html，css等文件


### 部署到Github ###

部署到Github前需要配置根目录下的_config.yml文件，首先找到下面的内容

    # Deployment

	## Docs: http://hexo.io/docs/deployment.html
	
	deploy:
	    type:
然后将它们修改为
	
	# Deployment	
	
	## Docs: http://hexo.io/docs/deployment.html
	
	deploy:
	    type: git
	    repository: git@github.com:githubname/githubname.github.io.git
	    branch: master

- 注意:Repository：必须是SSH形式的url（git@github.com:zhchnchn/zhchnchn.github.io.git），而不能是HTTPS形式（//github.com/zhchnchn/zhchnchn.github.io.git），否则会出现错误。

其他属性配置说明

    
	# 站点基本信息
		title: 网站标题
		subtitle:  网站子标题（通常跟在作者下面）
		description: 网站描述（页面上看不到）
		author: 作者名称
		language: 语言（zh-CN）
		timezone:
	
	# 链接
	## 如果有自己的域名可做修改，否则不需要
		url: http://yoursite.com
		root: /
	#permalink表示下一层的格式	
	#permalink: :year/:month/:day/:title/
		permalink: :title/
		permalink_defaults:
	
	# 目录描述
		source_dir: source
		public_dir: public
		tag_dir: tags
		archive_dir: archives
		category_dir: categories
		code_dir: downloads/code
		i18n_dir: :lang
		skip_render:
	
	# Writing
		new_post_name: :title.md # File name of new posts
		default_layout: post
		titlecase: false # Transform title into titlecase
		external_link: true # Open external links in new tab
		filename_case: 0
		render_drafts: false
		post_asset_folder: false
		relative_link: false
		future: true
		highlight:
		  enable: true
		  line_number: true
		  auto_detect: false
		  tab_replace:
	
	# 类型/标签
		default_category: uncategorized
		category_map:
		tag_map:
	
	# 首页的日期格式
		date_format: YYYY/MM/DD
		time_format: HH:mm:ss
	
	# 默认一页的文章数目
		per_page: 10
	#是否分页	
		pagination_dir: page
	
	#主题名称
		theme: yilia
	
	# Deployment
	## Docs: https://hexo.io/docs/deployment.html
	deploy:
	  type: git
	  repository: git@github.com:yourname/yourname.github.com.git
	  branch: master

### 测试部署到github的网站 ###

当部署完成后，在浏览器中打开http://githubname.github.io ，正常显示网页，表明部署成功。

### 后期部署步骤 ###

每次部署的步骤，可按以下三步来进行。

	$ hexo clean
	$ hexo generate
	$ hexo deploy

### 编辑文章 ###

使用一个支持markdown语法的编辑器，推荐MarkdownPad

下载地址：[MarkdownPad下载地址](http://share.weiyun.com/e8e47ea8d746ddebd4528138998c157f)

破解方式：[MarkdownPad破解方式](http://jingyan.baidu.com/article/ca41422fe209271eaf99ed7c.html)
# 安装主题 #
### 安装主题 ###
将Git Shell 切到themes目录下，然后执行下面的命令，将yilia下载到 themes/yilia 目录下。

	$ git clone https://github.com/litten/hexo-theme-yilia.git

修改博客根目录的config.yml配置文件中的theme属性，将其设置为yilia。
### 配置主题 ###
- 在yilia的config.yml中配置主题的属性

主题配置说明
	# 菜单导航目录
	menu:
	  主页: /
	  所有文章: /archives
	
	# 展示自己的相关其他网站
	subnav:
	  github: "#"
	  weibo: "#"
	  zhihu: "#"
	  douban: "#"
	  mail: "#"
	
	# 内容
		excerpt_link: more
		fancybox: true
		mathjax: true
	
	# 是否开启动画效果
		animate: true
	
	# 是否在新窗口打开链接
		open_in_new: false
	
	# 谷歌分析
		google_analytics: ''
	# 网站顶部小图标
		favicon: /img/header.jpg
	
	#你的头像url
		avatar: /img/header.jpg
	#是否开启分享
		share_jia: false
		share_addthis: false
	#是否开启多说评论，填写你在多说申请的项目名称 duoshuo: duoshuo-key
	#若使用disqus，请在博客config文件中填写disqus_shortname，并关闭多说评论
		duoshuo: true
	#是否开启云标签
		tagcloud: true
	
	#是否开启友情链接
	#不开启——
		friends: false
	#开启——
		friends:
	 	 web翎云阁: http://www.orzhtml.com/
	  	 jQuery插件兜: http://www.orzhtml.com/demo/
	  	 orz翎云阁: http://orzhtml.github.io
	
	#是否开启“关于我”。
	#不开启——
		aboutme: false
	#开启——
		aboutme: 本想把日子过成诗，时而简单，时而精致。不料日子却过成了我的歌，时而不靠谱，时而不着调。  
