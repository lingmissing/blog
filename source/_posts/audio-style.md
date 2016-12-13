---
title: 基于react的audio组件
date: 2016-12-12 11:30:32
tags: [react,html5]
categories: 代码如诗，前端如画
---

> 由于mac和window的样式不一致导致~~

```html
// 组件调用
<Audio src={src地址} id={srcID}/>
```

# audio属性

- `src` 歌曲的路径
- `preload` 是否在页面加载后立即加载（设置autoplay后无效）
- `controls`  显示audio自带的播放控件
- `loop` 音频循环
- `autoplay` 音频加载后自动播放
- `currentTime` 音频当前播放时间
- `duration` 音频总长度
- `ended` 音频是否结束
- `muted` 音频静音为true
- `volume` 当前音频音量
- `readyState`	音频当前的就绪状态

<!-- more -->

# audio事件

- `abort`	当音频/视频的加载已放弃时
- `canplay`	当浏览器可以播放音频/视频时
- `canplaythrough`	当浏览器可在不因缓冲而停顿的情况下进行播放时
- `durationchange`	当音频/视频的时长已更改时
- `emptied`	当目前的播放列表为空时
- `ended`	当目前的播放列表已结束时
- `error`	当在音频/视频加载期间发生错误时
- `loadeddata`	当浏览器已加载音频/视频的当前帧时
- `loadedmetadata`	当浏览器已加载音频/视频的元数据时
- `loadstart`	当浏览器开始查找音频/视频时
- `pause`	当音频/视频已暂停时
- `play`	当音频/视频已开始或不再暂停时
- `playing`	当音频/视频在已因缓冲而暂停或停止后已就绪时
- `progress`	当浏览器正在下载音频/视频时
- `ratechange`	当音频/视频的播放速度已更改时
- `seeked`	当用户已移动/跳跃到音频/视频中的新位置时
- `seeking`	当用户开始移动/跳跃到音频/视频中的新位置时
- `stalled`	当浏览器尝试获取媒体数据，但数据不可用时
- `suspend`	当浏览器刻意不获取媒体数据时
- `timeupdate`	当目前的播放位置已更改时
- `volumechange`	当音量已更改时
- `waiting`	当视频由于需要缓冲下一帧而停止


# 组件结构

```html
 <div className="audioBox">
  <audio 
    id={`audio${id}`}
    src={src}
    preload={true}
    onCanPlay={() => this.controlAudio('allTime')}
    onTimeUpdate={(e) => this.controlAudio('getCurrentTime')}
  >
    您的浏览器不支持 audio 标签。
  </audio>  
  <i 
    className={isPlay ? 'pause' : 'play'} 
    onClick={() => this.controlAudio(isPlay ? 'pause' : 'play')}
  />
  <span className="current">
    {this.millisecondToDate(currentTime)+'/'+this.millisecondToDate(allTime)}
  </span>
  <input 
    type="range" 
    className="time" 
    step="0.01" 
    max={allTime}     
    value={currentTime}  
    onChange={(value) => this.controlAudio('changeCurrentTime',value)} 
  />
  <i 
    className={isMuted ? 'mute' : 'nomute'} 
    onClick={() => this.controlAudio('muted')}
  />
  <input 
    type="range" 
    className="volume"
    onChange={(value) => this.controlAudio('changeVolume',value)} 
    value={isMuted ? 0 : volume} 
  />
</div>
```

# 组件javascript

```javascript
  constructor(props) {
    super(props)
    this.state = {
      isPlay: false,
      isMuted: false,
      volume: 100,
      allTime: 0,
      currentTime: 0
    }
  }
  
  millisecondToDate(time) {
    const second = Math.floor(time % 60)
    let minite = Math.floor(time / 60)
    // let hour
    // if(minite > 60) {
    //   hour = minite / 60
    //   minite = minite % 60
    //   return `${Math.floor(hour)}:${Math.floor(minite)}:${Math.floor(second)}`
    // }
    return `${minite}:${second >= 10 ? second : `0${second}`}`
  }

  controlAudio(type,value) {
    const { id,src } = this.props
    const audio = document.getElementById(`audio${id}`)
    switch(type) {
      case 'allTime':
        this.setState({
          allTime: audio.duration
        })
        break
      case 'play':
        audio.play()
        this.setState({
          isPlay: true
        })
        break
      case 'pause':
        audio.pause()
        this.setState({
          isPlay: false
        })
        break
      case 'muted':
        this.setState({
          isMuted: !audio.muted
        })
        audio.muted = !audio.muted
        break
      case 'changeCurrentTime':
        this.setState({
          currentTime: value
        })
        audio.currentTime = value
        if(value == audio.duration) {
          this.setState({
            isPlay: false
          })
        }
        break
      case 'getCurrentTime':
        this.setState({
          currentTime: audio.currentTime
        })
        if(audio.currentTime == audio.duration) {
          this.setState({
            isPlay: false
          })
        }
        break
      case 'changeVolume':
        audio.volume = value / 100
        this.setState({
          volume: value,
          isMuted: !value
        })
        break  
    }
  }
```


