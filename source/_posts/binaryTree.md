title: 二叉树的实现
date: 2018-06-22 13:49:03
tags: [javascript]
---

# 概念

`二叉树`（Binary Tree）是另一种树型结构，它的特点是每个结点至多只有两棵子树（即二叉树中不存在度大于 2 的结点），并且，二叉树的子树有左右之分（其次序不能任意颠倒。）

# 性质

- 二叉树的第 i 层上最多有 2 的(i-1)方个节点。（i>=1）
- 深度为 k 的树最多有 2 的 k 次方-1 个节点。（k>=1）
- 对任何一棵二叉树 T，如果其终端结点数为 n0，度为 2 的结点数为 n2，则 n0 = n2 + 1;
  _ 一棵深度为 k 且有 2 的 k 次方-1 个结点的二叉树称为`满二叉树`。
  _ 深度为 k 的，有 n 个结点的二叉树，当且仅当其每一个结点都与深度为 k 的满二叉树中编号从 1 至 n 的结点一一对应时，称之为`完全二叉树`。

# 初始化二叉树结构

```js
// 创建节点
class Node {
  constructor(key) {
    this.key = key
    this.left = null
    this.right = null
  }
}
```

```js
// 创建二叉树格式
class BinaryTree {
  constructor(...args) {
    this.root = null
    // 初始化依次插入数据
    args.forEach(key => {
      this.insert(key)
    })
  }
  // 实例化
  static create(args) {
    return new BinaryTree(...args)
  }
}
```

# 新增方法

```js
insert(key) {
  const newNode = new Node(key);
  const insertNode = function(node, newNode) {
    if (newNode.key < node.key) {
      // 如果新节点的值小于老节点的值
      if (node.left === null) {
        // 如果老节点没有左孩子
        node.left = newNode;
      } else {
        // 如果老节点有左孩子，那么讲数据插入到老节点的左孩子
        insertNode(node.left, newNode);
      }
    } else {
      // 如果新节点的值大于老节点
      if (node.right === null) {
        node.right = newNode;
      } else {
        insertNode(node.right, newNode);
      }
    }
  };
  if (this.root === null) {
    // 如果root不存在，将newNode设为根节点
    this.root = newNode
  } else {
    insertNode(this.root, newNode)
  }
}
```

调用形式

```js
const nodes = [8, 3, 10, 1, 6, 14, 4, 7, 13]
const binaryTree = BinaryTree.create(nodes)
binaryTree.insert(55)
console.log(binaryTree.root)
```

# 遍历方法

`二叉树`的遍历(traversing binary tree)是指从根结点出发，按照某种次序依次访问二叉树中所有结点，使得每个结点被访问一次且仅被访问一次。

## 前序遍历（DLR）

> 首先访问根结点，然后遍历左子树，最后遍历右子树。简记根-左-右。

- 用途：用于复制一颗二叉树
- 算法思路
  若二叉树为空，则遍历结束；否则 1. 访问根结点 2. 先序遍历左子树(递归调用本算法) 3. 先序遍历右子树(递归调用本算法)

```js
// 前序遍历
preOrderTraverse () {
	const preOrderTraverse = node => {
	  if (node !== null) {
	    console.log(node.key)
	    preOrderTraverse(node.left)
	    preOrderTraverse(node.right)
	  }
	}
	preOrderTraverse(this.root)
}
```

## 中序遍历（LDR）

> 首先遍历左子树，然后访问根结点，最后遍历右子树。简记左-根-右。

- 用途：用于从小到大排序二叉树

- 算法思路
  若二叉树为空，则遍历结束；否则 1. 中序遍历左子树(递归调用本算法) 2. 访问根结点 3. 中序遍历右子树(递归调用本算法)

```js
//使用递归方式实现中序遍历
inOrderTraverse () {
	const inOrderTraverseNode = node => {
	  if (node !== null) {
	    // 如果当前节点非空，则访问左子树
	    inOrderTraverseNode(node.left)
	    // 直到访问到最底部的左子树才进入callback，每个节点都会有callback
	    console.log(node.key)
	    // 此时已经是最底部的左子树
	    inOrderTraverseNode(node.right)
	  }
	  // 解释：首先进入8，发现左边有3，执行左边遍历，遍历完后执行3的回调，在执行3的右边的回调，
	}
	inOrderTraverseNode(this.root)
}
```

## 后序遍历（LRD）

> 首先遍历左子树，然后遍历右子树，最后访问根结点。简记左-右-根。

- 算法思路
  若二叉树为空，则遍历结束；否则 1. 后序遍历左子树(递归调用本算法)； 2. 后序遍历右子树(递归调用本算法) ； 3. 访问根结点 。

```js
postOrderTraverse () {
    const postOrderTraverse = node => {
      if (node !== null) {
        postOrderTraverse(node.left)
        postOrderTraverse(node.right)
        console.log(node.key)
      }
    }
    postOrderTraverse(this.root)
  }
```

# 查找算法

## 查找最大值

思路：传入二叉树，寻找右子树，直到找到不存在右子树的节点。

```js
// 查找最大值
max () {
	const maxNode = node => {
	  if (node !== null) {
	    if (node.right) {
	      return maxNode(node.right)
	    } else {
	      return node.key
	    }
	  }
	}
	return maxNode(this.root)
}
```

## 查找最小值

思路：传入二叉树，寻找左子树，直到找到不存在左子树的节点。

```js
// 查找最小值
min () {
	const minNode = node => {
	  if (node !== null) {
	    if (node.left) {
	      return minNode(node.left)
	    } else {
	      return node.key
	    }
	  }
	}
	return minNode(this.root)
}
```

## 查找任意值

思路：根据传入的 key 与当前节点比较，如果大于当前 key 则去右子树查找，否则去左子树查找。

```js
// 查找指定值
search (key) {
  const searchNode = function(node, key) {
    if (node === null) {
      return false
    }
    if (key < node.key) {
      return searchNode(node.left, key)
    } else if (key > node.key) {
      return searchNode(node.right, key)
    } else {
      return true
    }
  }
  return searchNode(this.root, key)
}
```

# 删除算法
思路：如果删除的key小于当前节点，去左子树种查找，否则去右子树查找。找到节点后，判断是否存在子节点，若不存在，直接删除，若只存在左节点或者右节点，将当前节点替换为它的子节点。若左右节点都存在，将右节点中的最小值（左子树）移除并替换为删除的节点位置（为了满足二叉树的左子树小于右子树）

```js
remove (key) {
  // 用于查找最小节点
  const findMinNode = node => {
    if (node) {
      // 如果node的左孩子存在
      while (node && node.left !== null) {
        // 将node设为node的左孩子再次进入循环
        node = node.left
      }
      // 直到返回没有左孩子的node
      return node
    }
  }
  const removeNode = (node, key) => {
    if (node === null) {
      return false
    }
    if (key < node.key) {
      // 当前node大于删除key，去左孩子中查找
      node.left = removeNode(node.left, key)
      return node
    } else if (key > node.key) {
      // 当前node小于删除key，去右孩子中查找
      node.right = removeNode(node.right, key)
    } else {
      // key和当前node相等
      if (node.left === null && node.right === null) {
        node = null
        return node
      }
      // 任意一边没有值，取另一边
      if (node.left === null) {
        node = node.right
        return node
      } else if (node.right === null) {
        node = node.left
        return node
      }
      // 同时存在左孩子和右孩子
      // 找出右边的最小值
      const aux = findMinNode(node.right)
      // 将最小值替换为删除的key
      node.key = aux.key
      // 在右孩子中删除最小值
      node.right = removeNode(node.right, aux.key)
      return node
    }
  }
  const result = removeNode(this.root, key)
  console.log(result)
}
```
