# `transbook` 文档类介绍

## 概述

一种用于翻译作品的 LaTeX 文档类，也可以在一定程度上应用于中文原创性作品。文档类主要基于 `ctexbook` 类采用 LaTeX3 进行设计，请使用 TeXLive 2022 以上的 TeX 发行版进行编译。文档类设计了特定的封面、扉页、封底样式，这些样式没有提供用户接口用于修改。对于这些排版内容的元数据，文档类提供了命令 `\Booksetup` 可以 `<key>=<value>` 的键值对进行修改。文档类主要基于 `ctexbook` 类进行设计，因此，章节版式可以由 `ctex` 提供的接口进行修改。



### 主要使用的宏包：

主要使用的宏包罗列如下，由这些宏包或者 LaTeX3 内核自动引入的包不再罗列其中：
+ `ctex` — 中文支持宏包
+ `xtemplate` — 实际上没有应用，我还不太会用这个包，但是将其引入了
+ `amsmath`、`amssymb`、`amsfonts` — `ams` 系列数学类宏包，注意没有 `amsthm`，需要时请自行加载
+ `geometry` — 页面尺寸设置
+ `fancyhdr` — 页眉页脚设计
+ `hyperref`、`cleveref` — 交叉引用的设置
+ `caption`、`subcaption` — 图标标题的设置
+ `ninecolors` — 颜色风格使用
+ `tikz` — 绘图宏包，`graphicx` 被其自动调用
+ `tcolorbox` — 彩色文本框设计
+ `siunitx` — 国际单位制的使用
+ `tabularray` — 表格、长表格的使用
+ `csvsimple-l3` — 支持读取 `csv` 文件批量操作
+ `xpatch` — 用于局部修改部分宏命令定义
+ `listings` — 用于编程语言排版风格设定
+ `varwidth` — 用于生成不超过指定宽度的文本块
+ 带特定选项加载的宏包：
  - `enumitem` — 带 `[shortlabels,inline]` 选项，兼容短标签，支持行内直接排印列表
  - `footmisc` — 带 `[perpage]` 选项，脚注样式设定按页编号
  - `zref` — 带 `[user,abspage,lastpage]` 选项，获取页面绝对数量
+ 其他杂项：
  - `xfrac` — 分数形式的扩展，可以使用一行内的小分数
  - `printlen` — 文本形式排印 LaTeX 中的长度参数
  - `ean13isbn` — EAN13 条形码或 ISBN 条形码
  - `qrcode` — 二维码支持
  - `fontawesome5` — fontawesome 图标支持

### 主要使用的字体：

#### 西文字体

+ 衬线字体 —— LaTeX 默认字体
+ 无衬线字体 —— LaTeX 默认字体
+ 等宽字体 —— LaTeX 默认字体
+ 数学字体 —— LaTeX 默认字体
+ 封面书名字体 —— RobotoCondensed-*.otf （TeXLive 自带）

#### 中文字体
+ 正文字体 —— 由谷歌发布的思源宋体 NotoSerifCJKsc-*.otf （Light、SemiBold）
+ 无衬线字体 —— 由谷歌发布的思源黑体 NotoSerifCJKsc-*.otf （Regular、Medium）
+ 等宽字体 —— 开源的等距更纱字体 sarasa-MonoT-sc-*.ttf（regular、italic、bold、bolditalic）
+ 封面书名字体 —— 由谷歌发布的思源宋体 NotoSerifCJKsc-Bold.otf
+ 封面出版社等字体 —— 开源的霞鹜文楷 LXGWWenKai-*.ttf（Regular、Bold）

## 主要功能

### 文档类选项

+ `[oneside]`、`[twoside]` — 继承的标准文档类选项
+ `[colortheme]` — `<key>=<value>` 选项，`<value>` 支持 `ninecolors` 宏包提供的基本色彩名，包括 `red`、`brown`、`yellow`、`olive`、`green`、`teal`、`cyan`、`azure`、`blue`、`violet`、`magenta` 和 `purple`，为文档色彩指定基调。
+ `[config]` — `<key>=<value>` 选项，指定额外需要读入的使用 LaTeX 3 语法的配置文件的文件名。`<value>` 可带路径，必须带扩展名（如果文件有扩展名）。
+ 文档类不继承其他标准文档类的选项，如需对已加载的宏包和 `ctexbook` 类使用选项，请在 `\documentclass` 命令前使用 `\PassOptionsToClass` 或 `\PassOptionsToPackage` 命令。

### 书籍元数据设置

书籍元数据主要通过 `\Booksetup` 命令设置，该命令接受一个参数，参数为逗号分隔列表形式的键值对 `<key>=<value>`，键名大小写敏感，键 `<key>` 的设置说明如下：

+ `BookTitle`、`BookTitle*` — 以 `tl` 形式（token list）指定书名（可以带 LaTeX 的宏），带 `*` 命令指定英文书名（以下同，不另行说明），如仅需要使用中文书名时，需要设置 `BookTitle*={}`；
+ `SubTitle`、`SubTitle*` — 以 `tl` 形式（token list）指定书名副标题，无默认值；
+ `BookSeries`、`BookSeries*` — 以 `tl` 形式（token list）指定丛书名称，无默认值；
+ `AuthorList`、`AuthorList*` — 以 `clist` 形式（逗号分隔列表）指定作者，无默认值；
+ `Edition` — 以 `int` 形式（整数）表示版本号，以 `Edition=2` 为例，封面英文版次显示罗马数字形式的 `Ed. II`，中文版次显示中文数字为 `（第二版）`；
+ `EditionStr` — 以 `str` 形式（字符串）表示版本，以 `EditionStr=2020` 为例，封面英文版次显示 `Ed. 2020`，中文版次显示中文数字为 `（2020 版）`，该键只有当 `Edition` 为 `0` 或缺省时才有效；
+ `BriefIntro` — 以 `tl` 形式（token list）给出关于图书的简介，只可以使用一段文字，不可以用空行或 `\par` 分段；
+ `WrittenStyle` — 以 `str` 形式（字符串）给出写作形式的关键字，如 `译`、`著`、`编著` 等，默认为 `著`；
+ `DedicatedTo` — 以 `tl` 形式（token list）给出出现在扉页的献词，只可使用一段文字，无默认值；
+ `Publisher` — 以 `tl` 形式（token list）给出出版社名称；
+ `Logo` — 以 `tl` 形式（token list）给出出版社 logo 的图形文件名，可指定路径，必须带扩展名，扩展名支持 `pdf`、`png` `jpg`，文件不存在时没有负面影响，只是不显示 logo 而已，该键默认值为 `logo.pdf`；
+ `CoverGraph` — 以 `tl` 形式（token list）给出封面长条形区域的图形文件名，可指定路径，必须带扩展名，扩展名支持 `pdf`、`png` `jpg`，文件不存在时没有负面影响，只是该处留白，该键默认值为 `cvgraph.pdf`；
+ `Url` — 以 `str` 形式（字符串）给出一个网络地址，用于生成封底的二维码（如果不指定 `ISBN` 时）；
+ `Editor`、`Designer` — 以 `tl` 形式（token list）给出封底显示的责任编辑和封面设计人名；
+ `Statement` — 以 `tl` 形式（token list）给出声明，列在简介与版权页；
+ `ReleaseDate`、`PrintDate` — 以 `tl` 形式（token list）给出显示在简介与版权页的发布/印刷时间，采用 `<YYYY>-<MM>-<DD>` 形式给出，如 `2020-11-02`，缺省时默认均采用编译当天；
+ `ISBN` — 以 `str` 形式（字符串）给出图书的 ISBN 号，格式为 `xxx-x-xxx-xxxxx-x`，用于在封底生成 ISBN 条形码，无默认值，缺省时封底输出 `Url` 指定网址的二维码；
+ `Price` — 以 `tl` 形式（token list）给出图书的定价，文档类自动添加小数 `.00`，缺省时文档类采用文档编译完成后的 `pdf` 文件总页面数（包括封面、封底及空白页）作为定价。

### 可用设置

+ 可使用 `\geometry` 命令重设图书页面设置
+ 可使用 `fancyhdr` 宏包相关命令重设页眉页脚
+ 可使用 `ctex` 宏包命令 `\ctexsetup` 重设章节样式
+ 提供与基本色协调的色彩名称，基本色由文档类选项 `[colortheme=<color>]` 设定，这些色彩名称可以在其他自设定中使用：
   + `genfg` — 一般前景色，采用 `<color>2`，用于章标题的颜色，图线颜色；
   + `genbgd` — 深背景色，采用 `<color>7`，用于表格的颜色；
   + `genbgd` — 浅背景色，采用 `<color>7`，用于表格的颜色；
   + `cvprim` — 封面主色调，采用 `<color>3`；
   + `cvsecd` — 封面次色调，采用 `<color>7`；
   + `cvsecd` — 封面深色条文色彩，采用 `<color>1`；
   + `cvpat`  — 封面透明条纹色彩（封面显示了透明效果），采用 `<color>5`；
+ `tabularray` 设定了基本表格样式，为 `tblr` 环境的默认设置：
   - 一般表格线采用白色，水平顶底表格线采用 `genfg` 色，线宽 1.5pt，竖向左右边框线采用 0pt 线宽；
   - 各行垂直居中对齐；
   - 奇数行采用 `gengbgl!20` 色彩，偶数行采用 `genbgl` 色彩；
   - 表头因行数不确定，建议用户自行设定，如 `row {1,2} = {fg=white,bg=genfg,font=\bfseries}` 进行自行设置以突出表头。
+ `tabularray` 设定两种长表格风格主题：
   - `plain` — 不设标题，适用于不进行表格编号的长表格
   - `normal` — 自动设置标题。
   - 长表格表内样式需要自行设定
+ 编程语言使用 `listings` 宏包进行语法高亮，语法高亮主题有 `dark` 和 `light` 两种风格，对 `lstlisting` 环境可以使用 `[style=<light/dark>]` 进行设置。  
+ `tcolorbox` 相关盒子样式设定，以下关键字可直接作为 `tcolorbox` 环境的选项使用
  - `Win10` —— Windows 10 窗口风格的文本框；
  - `Apple` —— 苹果 macOS 窗口风格的文本框；
  - `Ubuntu` —— Ubuntu 窗口风格的文本框；
+ 以上设置都在文档类选项 `[config=<file>]` 中指定的配置文件读入前配置完成，配置文件和导言区都可以对上述内容修改。

### 一些默认设置

+ 正文使用 5 号字。
+ 脚注采用中文带圈数字格式。
+ 浮动体图表默认采用 `\small` 字号，环境内居中布置。
+ 浮动体默认规则改为 `htbp`，支持就地排印。
+ 浮动体内图表标题采用 `\small` 字号，无衬线字体。
+ 图片默认路径采用 `./figures/` 和 `./graphics/`，这两个路径下的图片文件可以不需要路径名。
+ 有序、无序和解释列表采用了 `[nosep]`，取消了条目之间较大的间距。
+ 国际单位制范围、列表均中文化，`\qtyrange{20}{50}{m}` 排印为 `20m～50m`，`\qtylist{20,30,40,50}{m}` 排印为 `20m、30m、40m 和 50m`。
+ `cleveref` 智能引用标签中文化，`\cref` 自动给出标签 `图`、`表`、`式`、`附录`，章节等引用直接使用 `\cref`，其引用格式修改为 `第 2 章` 或 `第 2.2.1 节`，如需仅仅引用编号则使用 `\ref`。`\cref` 对标签列表的引用也均中文化，并且进行了数字压缩。

### 一些用户命令和环境

+ 环境
  - `timeline` 环境，语法格式：
  ```latex
  \begin{timeline}
    \item[<时间>] xxx
    \item[<时间>] xxx
  \end{timeline}
  ``` 
  环境不带参数的列表环境，列表项可选参数通常为时间，环境会用一条线将列表项标签点穿起来，起到时间线的效果。本环境能够跨页排印。
  - `EqDesc` 环境，公式解释环境，语法格式：
  ```latex
  \begin{EqDesc}[式中：]{Eq_n}
    \item[Eq_1] xxx
    \item[Eq_2] xxx
  \end{EqDesc}
  ``` 
  环境第一个参数默认为 `式中：`，排印时出现在列表最前，第二个参数内容并无意义，只是用来设定标签长度，标签采用第一个参数和放在数学模式中的第二个参数排印后的总宽度作为标签宽度，从而可以使列表项公式对齐。列表项可选参数及环境的必选参数都可以使用数学模式下的命令。
  - `argdesc` 环境，语法格式
  ```latex
  \begin{argdesc}[9em]
    \item[\marg{xxx}] xxx
    \item[\oarg{xxx}] xxx
  \end{argdesc}
  ```
  环境用于排印计算机函数语句的参数解释，本环境实际是 `description` 环境的一个包装，第一个参数是一个长度参数默认为 `9em`，表示解释内容的水平对齐位置（左边距）。列表项的参数可以使用自行定义的必选参数命令和可选参数命令，可依具体语言特点仿照 `ltxdoc` 自行设计。
  - `oscmd` 环境，语法格式
  ```latex
  \begin{oscmd}[bash]
  sudo rm -rf /
  \end{oscmd}
  ```
  本环境中的内容将抄录排印，用于表达计算机操作系统终端的命令执行。环境的参数用于指定进行语法高亮的计算机语言，如 `command.com`、`bash`、`csh` 等等，默认为 `command.com`，支持的语言为 `listings` 宏包中支持的语言和自定义语言。

+ 命令
   - `\alertwarning`、 `\alertinfo`、`\alerterror`、`\alerttip` 、`\alertupdate` 均为带一个长参数（可分段）的命令。生成信息、警告、错误、贴士和更新的信息框。这一系列命令可能与 `alertmessage` 宏包命令冲突，如果需要该宏包的命令，请在配置文件中加载 `alertmessage`。
   - `\osvar` 以一个橄榄色的小盒子排印，通常用于系统变量； 
   - `\oscommand` 以一个前景色橄榄色的黑色小盒子排印，通常用于单独的一条系统命令名称；
   - `\fname` 带一个参数，通常用于表达某文件名。 
   - `\Str` 带一个参数，通常用于表达某字符串，以等宽字体排印。 
   - `\Inscribe`、`\Inscribe` — `\Inscribe[日期]{人名}` 、`\CInscribe[日期]{人名}`，用于排印落款，前一种落款带短破折号引导。
   - `\pnme`，带一个参数，实际用小型大写字母排印参数，可用于表示英文人名。
   - `\pnmc`，带一个参数，排印中文人名，并且不会在人名中换行和换页，带 `*` 版本会给人名加外框，不可乱用。
   - `\Pnmc`，与 `\pnmc` 基本相同，不同之处在于如果人名字符少于三个，则会将人名排印充满三个字符宽度。
   - `\dif`，数学模式下命令，生成直立微分算子 $\mathrm{d}$，并与前面的变量保持合适的空隙。
   - `\MyRoman`、`\Myroman` 生成罗马数字。


## 文档示例

```latex
\documentclass[colortheme=olive]{transbook}
\Booksetup{
  BookTitle   = 这是书名,
  BookTitle*  = This Is the Book Title,
  SubTitle    = 随随便便写个副标题,
  SubTitle*   = A random subtitle,
  BriefIntro    = 
    { 
      本书的重点用于搞笑。
    },
  % Logo          = graphics/logo.pdf,
  CoverGraph    = graphics/cvgraph.png,
  % ISBN          = 978-7-302-11622-6,
  % AuthorList*   = {Mike Jordan, Mike Johnson },
  AuthorList*   = {{Jordan, Mike}, {Johnson, Mike} }, % 如果人名有逗号，用这种方式
  AuthorList    = {张小泉,李四,王麻子}, 
  WrittenStyle  = 译,
  % Edition       = 9,
  EditionStr    = 2023,
  ISBN          = 978-7-302-11622-6, % 你得自己校验这个码是不是合法
}
\usepackage{zhlipsum}
\begin{document}
\frontmatter
\tableofcontents
\mainmatter
\chapter{ 祝福 }
\zhlipsum[1-5][name=zhufu]
\chapter{ 南山经 }
\zhlipsum[1-5][name=nanshanjing]
\end{document} 
```

