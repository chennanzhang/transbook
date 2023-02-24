\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{transbook}
  {2023-01-11}{1.0.0}{Book Template for Translation}
\RequirePackage { xtemplate, l3keys2e }
% -----------------------------------------------------------------------------
% LaTeX3 版本检查
% -----------------------------------------------------------------------------
\clist_map_inline:nn { xtemplate, l3keys2e }
  {
    \@ifpackagelater {#1} { 2020/07/17 }
      { } { \msg_error:nnn { transbook } { l3-too-old } {#1} }
  }
\msg_new:nnn { transbook } { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
% -----------------------------------------------------------------------------
% 系统检查
% -----------------------------------------------------------------------------
\sys_if_engine_xetex:F
  {
    \msg_fatal:nnx { transbook } { unsupported-engine } { \c_sys_engine_str }
  }
\msg_new:nnn { transbook } { unsupported-engine }
  {
    The~ transbook~ class~ requires~ XeTeX~ only. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex".
  }
% -----------------------------------------------------------------------------
% 模式改变
% -----------------------------------------------------------------------------
\cs_generate_variant:Nn \file_input:n { x }
% -----------------------------------------------------------------------------
% 变量声明
% -----------------------------------------------------------------------------
\bool_new:N      \g__trbk_twoside_bool
\bool_set_true:N \g__trbk_twoside_bool
\clist_new:N     \g__trbk_to_ctexbook_clist
\int_new:N       \g__trbk_color_theme_series_int
\tl_new:N        \g__trbk_color_theme_series_tl
\tl_new:N        \g__trbk_release_date_tl
\tl_new:N        \g__trbk_print_date_tl
\tl_new:N        \g__trbk_book_title_pdf_zh_tl
% -----------------------------------------------------------------------------
% 选项设定
% -----------------------------------------------------------------------------
\keys_define:nn { trbk / option }
  {
    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n =
      {
        \clist_gput_right:Nn \g__trbk_to_ctexbook_clist { oneside }
        \bool_set_false:N    \g__trbk_twoside_bool
      },
    twoside .code:n =
      {
        \clist_gput_right:Nn \g__trbk_to_ctexbook_clist { twoside }
        \bool_set_true:N     \g__trbk_twoside_bool
      },
    colortheme   .choice:, 
    colortheme   .value_required:n = true, 
    colortheme   .choices:nn  = 
      { red, brown, yellow, olive, green, teal, cyan, azure, blue, violet, magenta, purple }
      % { \int_set_eq:NN \g__trbk_color_theme_series_int \l_keys_choice_int },
      { \tl_set_eq:NN \g__trbk_color_theme_series_tl \l_keys_choice_tl },
    colortheme   / unknown .code:n = 
      { \msg_error:nn { transbook } { invalid-colortheme } },
    colortheme   .initial:n   = azure,
    config  .tl_set:N = \g__trbk_config_filename_tl,
    unknown .code:n   = { \msg_error:nn { transbook } {unknown-option} }
  }
\msg_new:nnn { transbook } { unknown-option }
  { Package~option~`\l_keys_key_tl'~is~unknown. }
\msg_new:nnn { transbook } { invalid-colortheme }
  { The~value~which~you~set~for~the~key~`\l_keys_choice_tl'~is~invalid. ~Use~`red',~`olive',~`azure',~`violet'~or~`purple'~instead.}
\ProcessKeysOptions { trbk / option }
\PassOptionsToClass { 
    zihao = 5,
    sub4section,
    \g__trbk_to_ctexbook_clist 
    } { ctexbook }
\LoadClass { ctexbook }
% -----------------------------------------------------------------------------
% 文档调用的宏包
% -----------------------------------------------------------------------------
% \PassOptionsToPackage{ table }{ xcolor }
\RequirePackage
  {
    amsmath,
    amssymb,
    amsfonts,
    upgreek,
    xfrac,
    ninecolors,
    printlen,
    ean13isbn,
    fontawesome5,
    qrcode,
    varwidth,
    geometry,
    fancyhdr,
    caption,
    siunitx,
    subcaption,
    tabularray,
    csvsimple-l3,
    hyperref,
    cleveref,
  }
\RequirePackage[ user, abspage, lastpage ]{ zref }
\RequirePackage[perpage]{footmisc}
% -----------------------------------------------------------------------------
% 键值对设计
% -----------------------------------------------------------------------------
\keys_define:nn { trbk }
  {
    BookTitle       .tl_set:N     = \g__trbk_book_title_zh_tl,
    BookTitle       .initial:n    = { 非常长长长长长长长长长长长长的书名 },
    BookTitle*      .tl_set:N     = \g__trbk_book_title_en_tl,
    BookTitle*      .initial:n    = { A~Very~Long~Long~Long~Long~Long~Long~Title },
    SubTitle        .tl_set:N     = \g__trbk_book_subtitle_zh_tl,
    SubTitle*       .tl_set:N     = \g__trbk_book_subtitle_en_tl,
    Edition         .int_set:N    = \g__trbk_book_edition_int,
    EditionStr      .str_set:N    = \g__trbk_book_edition_str,
    BookSeries      .tl_set:N     = \g__trbk_book_series_zh_tl,
    BookSeries*     .tl_set:N     = \g__trbk_book_series_en_tl,
    BriefIntro      .tl_set:N     = \g__trbk_brief_introduction_tl,
    BriefIntro      .initial:n    = { 这本书的简介。 },
    AuthorList      .clist_set:N  = \g__trbk_book_author_zh_clist,
    AuthorList*     .clist_set:N  = \g__trbk_book_author_en_clist,
    WrittenStyle    .str_set:N    = \g__trbk_written_style_str,
    WrittenStyle    .initial:n    = { 著 },
    DedicatedTo     .tl_set:N     = \g__trbk_dedicated_to_tl,
    Publisher       .tl_set:N     = \g__trbk_publisher_tl,
    Publisher       .initial:n    = { 同济极客出版社 },
    Logo            .tl_set:N     = \g__trbk_pub_logo_tl,
    Logo            .initial:n    = { logo.pdf },
    CoverGraph      .tl_set:N     = \g__trbk_cover_graph_tl,
    CoverGraph      .initial:n    = { cvgraph.pdf },
    Url             .str_set:N    = \g__trbk_url_str,
    Url             .initial:n    = {http://www.tjad.cn},
    Editor          .tl_set:N     = \g__trbk_editor_tl,
    Editor          .initial:n    = { 张晨南 },
    Designer        .tl_set:N     = \g__trbk_designer_tl,
    Designer        .initial:n    = { 张晨南 },
    Statement       .tl_set:N     = \g__trbk_statement_tl,
    Statement       .initial:n    = { 本书只用于个人学习交流，严禁用于商业用途 },
    ReleaseDate     .code:n       =
      { 
        \tl_set:Nx \g__trbk_release_date_tl
          { \__trbk_date_parse:n { #1 } }
      },
    PrintDate       .code:n       =
      { 
        \tl_set:Nx \g__trbk_print_date_tl
          { \__trbk_date_parse:n { #1 } }
      },
    ISBN            .str_set:N    = \g__trbk_isbn_str,
    Price           .tl_set:N     = \g__trbk_price_tl,
    % Price           .initial:n    = { 358.00 }
  }
% -----------------------------------------------------------------------------
% tikz 与 tcolorbox 设置
% -----------------------------------------------------------------------------
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable,raster,listings,xparse}
\newcommand{\UbuntuMin}{
	\begin{tikzpicture}[x=2.0ex,y=2.0ex,line~width=0.15ex,scale=1]
	\shade[shading=ball,left~color=ogray,right~color=ogray!50!white] (0,0) circle (0.5);
	\draw[termimal](-0.3,0)--(0.3,0);
	\end{tikzpicture}
}
\newcommand{\UbuntuClose}{
	\begin{tikzpicture}[x=2.0ex,y=2.0ex,line~width=0.15ex,scale=1]
	\shade[shading=ball,left~color=oorange,right~color=oorange!70!white] (0,0) circle (0.5);
	\draw[termimal](-0.25,-0.25)--(0.25,0.25);
	\draw[termimal](-0.25,0.25)--(0.25,-0.25);
	\end{tikzpicture}
}
\newcommand{\UbuntuMax}{
	\begin{tikzpicture}[x=2.0ex,y=2.0ex,line~width=0.15ex,scale=1]
	\shade [shading=ball,left~color=ogray,right~color=ogray!50!white] (0,0) circle (0.5);
	\draw[termimal](-0.25,-0.2)rectangle(0.25,0.2);
	\end{tikzpicture}
}
\tcbset
  {
    skin = enhanced,
    windowbase/.style =
    {
      breakable,
      fonttitle    = \small\bfseries\sffamily,
      colback      = genbgl!20,
    },
    Win10/.style=
    {
      windowbase,
      sharp~corners,
      colframe     = genfg,
      colbacktitle = genfg,
      coltitle     = white,
      overlay~unbroken = 
      {
        \node 
          [
            inner~sep = 0pt,
            anchor    = north~east,
            yshift    = -5pt,
            xshift    = -11pt,
            text      = genbgl 
          ]
          at (frame.north~east)
          {{\small\faMinus}\quad{\small\faSquare[regular]}\quad\faTimes};
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -3pt,
            xshift    = 3pt,
            text      = white
          ] at (frame.north~west) {\faFile};
      },
      overlay~first = 
      {
        \node
          [
            inner~sep = 0pt,
            anchor    = north~east,
            yshift    = -5pt,
            xshift    = -11pt,
            text      = genbgl
          ]
          at (frame.north~east)
          {{\small\faMinus}\quad{\small\faSquare[regular]}\quad\faTimes};
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -3pt,
            xshift    = 3pt,
            text      = white
          ] 
          at (frame.north~west) {\faFile};
      }
    },
    Apple/.style = 
    {
      windowbase,
      center~title,
      colframe     = genbgl,
      colbacktitle = genbgd,
      coltitle     = genfg,
      toptitle     = 0.5ex,
      bottomtitle  = 0.5ex,
      overlay~unbroken= 
      {
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -5pt,
            xshift    = 11pt
          ]
          at (frame.north~west)
          {\small\textcolor{AppleRed}{\faCircle}\quad\textcolor{AppleYellow}{\faCircle}\quad\textcolor{AppleGreen}{\faCircle}};
      },
      overlay~first={
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -5pt,
            xshift    = 11pt
          ]
          at (frame.north~west)
          {\small\textcolor{AppleRed}{\faCircle}\quad\textcolor{AppleYellow}{\faCircle}\quad\textcolor{AppleGreen}{\faCircle}};
      }
    },
    Ubuntu/.style={
      windowbase,
      center~title,
      colframe     = genfg,
      colbacktitle = genfg,
      coltitle     = white,
      overlay~unbroken={
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -3pt,
            xshift    = 10pt
          ]
          at (frame.north~west)
          {\UbuntuClose\quad\UbuntuMin\quad\UbuntuMax};
      },
      overlay~first={
        \node
          [
            inner~sep = 0pt,
            anchor    = north~west,
            yshift    = -3pt,
            xshift    = 10pt
          ]
          at (frame.north~west)
          {\UbuntuClose\quad\UbuntuMin\quad\UbuntuMax};
      }
    },
    screen/.style =
    {
		  top            = 1mm,
      bottom         = 0mm,
      boxsep         = 0mm,
		  colback        = black!75!white,
		  colframe       = yellow!75!black,
		  fontlower      = \small\ttfamily,
		  fontupper      = \small\ttfamily,
		  listing~engine = listings,
		  breakable
	  },
    osshell/.style = 
    {
      screen,
      listing~only,
		  every~listing~line = { \textcolor{green}{\bfseries \$ ~ > } },
		  listing~options    =
        { 
          language={#1},
          breaklines,
          postbreak = \mbox{\textcolor{red}{$\hookrightarrow$}\space},
          style=dark 
        },
	  },
    codeexample/.style=
    {
		  breakable,
		  sharp~corners,
		  colback      = genbgl!20,
		  colbacktitle = genfg,
		  coltitle     = white,
		  colframe     = genfg,
		  top          = 0mm,
      bottom       = 0mm,
      boxsep       = 0mm
	  },
    alertbox/.style = 
    {
		  sidebyside,
      segmentation~hidden,
		  fontupper     = \huge,
		  fontlower     = \small,
      colback       = #1!20, 
      colupper      = #1!50!black,
		  lefthand~width= 9mm,
		  arc           = 2mm,
		  fuzzy~shadow  = {1mm}{-1mm}{0mm}{0.1mm}{black!50!white}
    },
    smallbox/.style =
    {
      nobeforeafter,
      tcbox~raise~base,
      fontupper  = \ttfamily,
      colupper   = #1,
      colback    = #1!10!white, 
      colframe   = #1!50!black,
      arc        = 0pt,
      outer~arc  = 0pt,
      top        = 0pt,
      bottom     = 0pt,
      left       = 0mm,
      right      = 0mm,
      leftrule   = 0pt,
      rightrule  = 0pt,
      toprule    = 0mm,
      bottomrule = 0mm,
      boxsep     = 0.5mm,
	  },
    smallboxdark/.style =
    {
      nobeforeafter,
      tcbox~raise~base,
      fontupper  = \ttfamily,
      colupper   = #1!20!white,
      colback    = darkgray, 
      colframe   = black,
      arc        = 2pt,
      outer~arc  = 3pt,
      top        = 0pt,
      bottom     = 0pt,
      left       = 0mm,
      right      = 0mm,
      leftrule   = 1pt,
      rightrule  = 1pt,
      toprule    = 1pt,
      bottomrule = 1pt,
      boxsep     = 0.5mm,
	  },
    codedescript/.style={
	  	colback      = genbgd,
	  	arc          = 2mm,
	  	fuzzy~shadow = {1mm}{-1mm}{0mm}{0.1mm}{black!50!white}
	  },
  }
%-------------------------------------------------------------------------------
% printlen 设置
%-------------------------------------------------------------------------------
\uselengthunit{mm}
%-------------------------------------------------------------------------------
% xeCJK设置中文样式
%-------------------------------------------------------------------------------
\xeCJKsetup{CJKecglue={\hskip 0.10em plus 0.05em minus 0.05em},CheckSingle=true}
% ------------------------------------------------------------------------------
% 字体设置
% ------------------------------------------------------------------------------
\setCJKmainfont{NotoSerifCJKsc}
  [
    Extension   = .otf,
    UprightFont = *-Light,
    BoldFont    = *-SemiBold,
  ]
\setCJKsansfont{NotoSansCJKsc}
  [
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Medium
  ]
\setCJKmonofont{Sarasa~Mono~T~SC}
\newfontfamily\roboto{RobotoCondensed}
  [ 
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold ,
    ItalicFont  = *-Italic
  ]
\setCJKfamilyfont {zhxwwk} {LXGWWenKai}
  [
    Extension   = .ttf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold 
  ]
\newcommand{\xwwk}{\CJKfamily+{zhxwwk}}
\setCJKfamilyfont{zhcusong}{NotoSerifCJKsc-Bold.otf}
\newcommand{\cusong}{\CJKfamily+{zhcusong}}
% ------------------------------------------------------------------------------
% 页面设置
% ------------------------------------------------------------------------------
\geometry
  {
    inner      = 2.5 cm ,
    outer      = 4.0 cm ,
    top        = 3.5 cm ,
    bottom     = 5 cm   ,
    headheight = 15 pt  ,
  }
% ------------------------------------------------------------------------------
% 页眉页脚设计
% ------------------------------------------------------------------------------
\renewcommand{\headrulewidth}{0mm}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{
  \begin{tikzpicture}[overlay,remember~picture]
    \draw [line~width=0.5pt,genfg] 
      ([xshift=3.8cm,yshift=-3.0cm]current~page.north~west) --++(0,3.0cm);
    \node at ([xshift=3.6cm,yshift=-3.0cm]current~page.north~west) 
      [above~left]{\thepage};
    \node at ([xshift=4cm,yshift=-3.0cm]current~page.north~west) 
      [above~right]{\slshape\leftmark};
  \end{tikzpicture}
}
\fancyhead[RO]{
  \begin{tikzpicture}[overlay,remember~picture]
    \draw[line~width=0.5pt,genfg]
      ([xshift=-3.8cm,yshift=-3.0cm]current~page.north~east)--++(0,3.0cm);
    \node at ([xshift=-3.6cm,yshift=-3.0cm]current~page.north~east)
      [above~right]{\thepage};
    \node at ([xshift=-4cm,yshift=-3.0cm]current~page.north~east) 
      [above~left]{\slshape\rightmark};
  \end{tikzpicture}
}
\fancypagestyle{plain}{\fancyhf{}}
% ------------------------------------------------------------------------------
% 章节格式设计
% ------------------------------------------------------------------------------
\ctexset {
  part={
    format     = \zihao{0}\bfseries\centering,
    pagestyle  = { empty },
    nameformat = \rule{0.1\linewidth}{0pt}\rule{0.8\linewidth}{2bp}\rule{0.1\linewidth}{0pt}\par,
    aftername  = \par\medskip,
    aftertitle = \par\bigskip\nointerlineskip\rule{0.1\linewidth}{0pt}\rule{0.8\linewidth}{2bp}\rule{0.1\linewidth}{0pt}\par
  },
  chapter = {
    beforeskip   = 50pt,
    format       = \huge\bfseries,
    name         = {,},
    nameformat   = \mbox{}\hfill\mbox{},
    number       = \arabic{chapter},
    numberformat = \color{genfg}\fontencoding{OT1}\fontfamily{cmss}\fontsize{60pt}{72pt}\selectfont,
    aftername    = \par\medskip{\color{genfg}\hrule height2pt}\par\medskip,
    titleformat  = \color{genfg},
    aftertitle   = \par\smallskip
  },
  section        ={
    format       = \zihao{-3}\bfseries\flushleft,     
    afterskip    = 10pt,
    beforeskip   = 10pt,
  },
  subsection    ={
    format      = \zihao{4}\bfseries\flushleft,      
    afterskip   = 7pt,
    beforeskip  = 7pt,
  },
  subsubsection ={
    format      = \zihao{-4}\bfseries\flushleft,
    afterskip   = 3pt,
    beforeskip  = 3pt,
  },
  paragraph ={
    format      = \zihao{5}\bfseries\flushleft,
    afterskip   = 2pt,
    beforeskip  = 2pt,
  },
  subparagraph ={
    format      = \zihao{5}\flushleft,
    afterskip   = 2pt,
    beforeskip  = 2pt,
  },
  appendixname = {}
}
%-------------------------------------------------------------------------------
% 脚注改为中文带圈数字脚注方式
%-------------------------------------------------------------------------------
\RequirePackage{xpatch}
\newcommand{\circlenumber}[1]{%
\ifnum #1<21
  \edef\a{\the\numexpr #1+9311}
\else
  \ifnum #1<36
    \edef\a{\the\numexpr #1+12860}
  \else
    \ifnum #1<51
     \edef\a{\the\numexpr #1+12941}
    \else
      \PackageError{popularsym}%
      {Number~is~too~big!}{The~Number~should~be~not~Greater~than~50}
    \fi
  \fi
\fi
{\CJKfontspec{Noto~Serif~CJK~SC}\fontspec{Noto~Serif~CJK~SC}\symbol\a}}
\renewcommand{\thefootnote}{\protect\circlenumber{\arabic{footnote}}}
%-------------------------------------------------------------------------------
% 浮动体内容默认采用小号字并居中
%-------------------------------------------------------------------------------
\xpatchcmd\@floatboxreset{\normalsize}{\centering\small}{}{}
%-------------------------------------------------------------------------------
% \includegraphics 图片的默认路径。
%-------------------------------------------------------------------------------
\graphicspath{{./figures/}{./graphics/}}
%-------------------------------------------------------------------------------
% 普通列表定义 已说明
%-------------------------------------------------------------------------------
\RequirePackage[shortlabels,inline]{enumitem}
\setlist{nosep,listparindent=2em}
\setlist[enumerate]{itemindent=3.5em}
\setlist[itemize]{itemindent=2.0em}
\setlist[enumerate,1]{leftmargin=0em,label=\arabic*)}
\setlist[enumerate,2]{leftmargin=1em,label=\alph*)}
\setlist[enumerate,3]{leftmargin=1em,label=\roman*)}
\setlist[description]{labelindent=\parindent}
%-------------------------------------------------------------------------------
% 设置图表标题形式
%-------------------------------------------------------------------------------
\captionsetup{
  labelsep = quad,
  font     = { small, sf },
  skip     = 5pt
}
%-------------------------------------------------------------------------------
% 设置表格样式
%-------------------------------------------------------------------------------
\UseTblrLibrary{siunitx}
\SetTblrInner{
  hlines        = { white },
  vlines        = { white },
  hline{ 1, Z } = { 1.5 pt, genfg },
  vline{ 1, Z } = { 0 pt },
  rows          = { m },
  row { odd  }  = { genbgl!20 }, 
  row { even }  = { genbgl },
}
\NewTblrTheme { plain }
{
  \SetTblrTemplate{head,contfoot}{empty}
  \SetTblrStyle{note,remark}{\footnotesize}
}
\DefTblrTemplate{conthead-text}{normal}{（续）}
\NewTblrTheme { normal }
{
  \SetTblrTemplate{contfoot}{empty}
  \SetTblrTemplate{conthead-text}{normal}
  \SetTblrStyle{note,remark}{\footnotesize\rmfamily}
  \SetTblrStyle{caption-tag,caption-sep,caption-text,conthead-text}{\small\sffamily}
}
%-------------------------------------------------------------------------------
% 浮动图表规则放松
%-------------------------------------------------------------------------------
\setcounter{topnumber}{4}
\setcounter{bottomnumber}{4}
\setcounter{totalnumber}{10}
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.70}
\renewcommand{\floatpagefraction}{0.66}
%-------------------------------------------------------------------------------
% 浮动图表默认位置规则
%-------------------------------------------------------------------------------
\def\fps@figure{htbp}
\def\fps@table{htbp}
%-------------------------------------------------------------------------------
% 重定义目录，给目录加标签
%-------------------------------------------------------------------------------
\renewcommand\tableofcontents
  {
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname}
    \@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}
    \pdfbookmark{目录}{contents}
    \@starttoc{toc}
    \if@restonecol\twocolumn\fi
  }
%-------------------------------------------------------------------------------
% 编程语言语法高亮模式设置
%-------------------------------------------------------------------------------
\lstdefinestyle{ light } 
  {
    basicstyle      = \small \color{ blue } \ttfamily,
    identifierstyle = \color{ violet },
    columns         = flexible,
    commentstyle    = \color{gray}\slshape,
    keywordstyle    = { [1] \color{ blue    } },
    keywordstyle    = { [2] \color{ teal    } },
    keywordstyle    = { [3] \color{ orange  } },
    keywordstyle    = { [4] \color{ red     } },
    keywordstyle    = { [5] \color{ cyan    } },
    stringstyle     = \color{ brown },
    tabsize         = 2,
    % postbreak       = $\hookrightarrow$,
  }
\lstdefinestyle{ dark } 
  {
    basicstyle      = \small \color{ olive!20!white } \ttfamily,
    identifierstyle = \color{ yellow },
    columns         = flexible,
    commentstyle    = \color{ lightgray }\slshape,
    keywordstyle    = { [1] \color{ olive!20!white } },
    keywordstyle    = { [2] \color{ green          } },
    keywordstyle    = { [3] \color{ orange         } },
    keywordstyle    = { [4] \color{ red            } },
    keywordstyle    = { [5] \color{ cyan           } },
    stringstyle     = \color{ brown!90!white },
    tabsize         = 2,
  }
% ------------------------------------------------------------------------------
% siunitx 设置
% ------------------------------------------------------------------------------
\sisetup{
  separate-uncertainty,
  retain-explicit-plus=true,
  list-final-separator = {~和~},
  list-pair-separator  = {~和~},
  list-separator = {、},
  range-phrase   = {～}
}
% ------------------------------------------------------------------------------
% hyperref 设置
% ------------------------------------------------------------------------------
\hypersetup
  {
    colorlinks         = true   ,
    linkcolor          = teal2  ,
    citecolor          = brown2 ,
    urlcolor           = blue2  ,
    bookmarksnumbered  = true   ,
    bookmarksopen      = false  ,
  }
% ------------------------------------------------------------------------------
% cleveref 设置
% ------------------------------------------------------------------------------
\crefname{equation}{式}{式}
\crefname{figure}{图}{图}
\crefname{table}{表}{表}
\crefname{appendix}{附录}{附录}
\crefname{chapter}{}{}
\crefname{section}{}{}
\crefname{subsection}{}{}
\crefname{subsubsection}{}{}
\creflabelformat{chapter}{#2第\nobreakspace #1\nobreakspace 章#3}
\creflabelformat{section}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{subsection}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{subsubsection}{#2第\nobreakspace #1\nobreakspace 节#3}
\newcommand{\crefpairconjunction}{~和~}
\newcommand{\crefmiddleconjunction}{、}
\newcommand{\creflastconjunction}{~和~}
\newcommand{\crefpairgroupconjunction}{~和~}
\newcommand{\crefmiddlegroupconjunction}{、}
\newcommand{\creflastgroupconjunction}{~和~}
\newcommand{\crefrangeconjunction}{～}
% ------------------------------------------------------------------------------
% 额外的配置文件读取
% ------------------------------------------------------------------------------
\tl_if_empty:NF \g__trbk_config_filename_tl
  {
    \IfFileExists{\tl_use:N \g__trbk_config_filename_tl}
      { \file_input:x {\tl_use:N \g__trbk_config_filename_tl} }
      { \relax }
  }
% ------------------------------------------------------------------------------
% 内部宏命令定义
% ------------------------------------------------------------------------------
% ---- 日期解析
\cs_new:Npn \__trbk_date_parse:n #1 
  { \__trbk__date_parse_aux:w #1 \q_stop }
\cs_new:Npn \__trbk__date_parse_aux:w #1-#2-#3 \q_stop 
  { #1 年 \int_eval:n {#2} 月 \int_eval:n {#3} 日 }
\cs_new_protected:Npn \trbk_set_color:nn #1#2
  {
    \colorlet { #1 } { \tl_use:N \g__trbk_color_theme_series_tl #2 }
  }
\clist_map_inline:nn
  {
    { genfg  } { 2 },
    { genbgd } { 7 },
    { genbgl } { 9 },
    { cvprim } { 3 },
    { cvsecd } { 7 },
    { cvbar  } { 1 },
    { cvpat  } { 5 },
  }
  {\trbk_set_color:nn #1}
% ---- 画 ISBN 条形码
\cs_new:Npn \__trbk_draw_barcode:n #1 { \EANisbn[SC5a,ISBN=#1] } 
\cs_new_protected:Npn \trbk_draw_barcode:
  {
    \exp_args:Nx \__trbk_draw_barcode:n \g__trbk_isbn_str
  }
% ---- 人名格式化
\cs_new:Npn \__trbk_parse_chinese_person_name_str:n #1 
  { 
    \int_compare:nNnTF { \str_count_ignore_spaces:n { #1 } } = { 2 }  
      { \quad\makebox[3em][s]{ #1 } } { \quad #1  }
  }
% ---- 封面设计
\cs_new_protected:Nn \trbk_book_cover:
  {
    \begin{titlepage}
      \thispagestyle{empty}
      \pdfbookmark{封面}{cover}
      \begin{tikzpicture}[overlay, remember~picture, inner~sep=0pt]
        \fill[ cvsecd ]
          ( current~page.north~west ) rectangle ( current~page.south~east );
        \fill[ cvbar ]
          ([yshift =-4cm] current~page.center ) rectangle ( current~page.west )
          ([xshift = 2cm , yshift =-4cm] current~page.west ) 
          rectangle ( [yshift =-8cm] current~page.east );
        \fill[ cvprim ]
          ([xshift = 2cm] current~page.north~west ) 
          rectangle ([xshift = -2cm, yshift = -7.5cm] current~page.east );
        \fill[ cvtext ]
          ([xshift = 2cm ] current~page.west ) rectangle(current~page.south);
        \IfFileExists {\tl_use:N \g__trbk_cover_graph_tl}
          {
            \node at ([ xshift = 2cm ] current~page.west ) 
            [anchor = north~west, opacity = 0.8]
            {
              \includegraphics [ width = \dim_eval:n{ 0.5\paperwidth - 2cm} ] 
              { \tl_use:N \g__trbk_cover_graph_tl }
            };
          }
          {\relax }
        \fill[cvpat , opacity = 0.4]
          ([xshift = 2cm , yshift =-8cm] current~page.west ) 
          rectangle ([xshift = -2cm, yshift = 2cm] current~page.south~east );
        \coordinate (logo) 
          at ([xshift = -3.5cm, yshift = 3cm] current~page.south~east );
        \IfFileExists{ \tl_use:N \g__trbk_pub_logo_tl }
          {
            \node at ( logo ) [ right ]
              { 
                \includegraphics [height=1cm] 
                  { \tl_use:N \g__trbk_pub_logo_tl } 
              };
          }
          { \relax }
        \node (publish) at (logo)
          [ left=5mm, color=cvtext ]
          { \LARGE\bfseries\xwwk\tl_use:N \g__trbk_publisher_tl};
        \tl_if_empty:NF \g__trbk_book_series_zh_tl 
          {
            \node (zhseries) 
            at ([xshift = -2.5cm, yshift = -2.5cm] current~page.north~east )
            [left, color=cvtext]
            { \Large\sffamily\tl_use:N \g__trbk_book_series_zh_tl};
          }
        \tl_if_empty:NF \g__trbk_book_series_en_tl
          {
            \node (enseries) at ([yshift = -5mm] zhseries.south~east )
            [left, color=cvtext]
            {\Large\slshape\sffamily\tl_use:N \g__trbk_book_series_en_tl};
          }
        \coordinate (linestart) 
          at ([xshift = 2.2cm ,  yshift =4.5cm] current~page.west );
        \coordinate (lineend)   
          at ([xshift = -2.2cm , yshift =4.5cm] current~page.east );
        \draw[line~width=1mm,cvtext] (linestart)--(lineend);
        \node (zhtitle) 
          at ([yshift=-5mm]linestart)
          [anchor=north~west,cvtext] 
          {
            \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
              \raggedright
              \cusong\Huge\tl_use:N\g__trbk_book_title_zh_tl
            \end{varwidth}
          };
        \node (entitle) at ([yshift= 5mm]linestart)
          [anchor=south~west,cvtext] 
          {
            \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
              \raggedright
              \scshape\roboto\Huge\tl_use:N\g__trbk_book_title_en_tl
            \end{varwidth}
          };
        \tl_if_empty:NF \g__trbk_book_subtitle_zh_tl 
          { 
            \node at ([yshift=-2mm]zhtitle.south~west)
              [anchor=north~west,cvtext] 
              {
                \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
                  \sffamily\Large\tl_use:N\g__trbk_book_subtitle_zh_tl
                \end{varwidth}
              }; 
          }
        \tl_if_empty:NF \g__trbk_book_subtitle_en_tl 
          { 
            \node at ([yshift=2mm]entitle.north~west)
              [anchor=south~west,cvtext] 
                {
                  \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
                    \itshape\roboto\Large\tl_use:N\g__trbk_book_subtitle_en_tl
                  \end{varwidth}
                }; 
          }
        \coordinate (decs) 
          at ([ yshift=-4.5cm, xshift=5mm  ]current~page.center);
        \coordinate (dece) 
          at ([ yshift=-3.5cm, xshift=-25mm ]current~page.east);
        \draw [ cvtext ]
          (decs)--++(3.5,0)--++(1,1)--(dece);
        \fill [ cvtext ] (decs) circle (5pt);
        \fill [ cvtext ] (dece) circle (5pt);
        \clist_if_empty:NF \g__trbk_book_author_zh_clist
          {
            \node (written )at ([yshift=-12mm] dece) [anchor=north~east,cvtext]
              { 
                \sffamily \Large \bfseries 
                \str_use:N \g__trbk_written_style_str
              };
            \node at ([xshift=-5mm]written.west) [left, cvtext]
              {
                \sffamily \bfseries \Large 
                \clist_map_inline:Nn \g__trbk_book_author_zh_clist
                  { \__trbk_parse_chinese_person_name_str:n {##1} } 
              };
          }
        \clist_if_empty:NF \g__trbk_book_author_en_clist
          { 
            \node at ([yshift=12mm] decs) [anchor=south~west,cvtext]
              { 
                \Large\ \parbox{ \dim_eval:n{ 0.5\paperwidth - 3cm} }
                {
                  \bfseries
                  \clist_use:Nnnn \g__trbk_book_author_en_clist 
                    {\\} {\\} {\\}
                }  
              }; 
          }
        \int_compare:nNnTF { \g__trbk_book_edition_int } = { 0 }
          {
            \str_if_empty:NF \g__trbk_book_edition_str
            {
              \node at (entitle.south-|dece)
                [cvtext,anchor=south~east]
                {
                  \bfseries\slshape \Large Ed.~
                  \str_use:N \g__trbk_book_edition_str
                };
              \node at (zhtitle.north-|dece) [cvtext, anchor =north~east ]
                {\Large\bfseries（ \str_use:N \g__trbk_book_edition_str  版）};
            }
          }
          {
            \node at (entitle.south-|dece)
              [cvtext,anchor=south~east]
              {
                \bfseries\slshape \Large Ed.~
                \int_to_Roman:n {\g__trbk_book_edition_int}
              };
            \node at (zhtitle.north-|dece) [cvtext, anchor =north~east ]
              {\Large\bfseries（第 \zhnum_number:f { \int_use:N \g__trbk_book_edition_int } 版）};
          }
      \end{tikzpicture}
    \end{titlepage}
  }
% ---- 封底设计
\cs_new_protected:Nn \trbk_book_back_cover:
  {
    \thispagestyle{empty}
    \pdfbookmark{封底}{backcover}
    \begin{tikzpicture}[overlay, remember~picture, inner~sep=0pt]
      \fill[ cvsecd ]
          ( current~page.north~west ) rectangle ( current~page.south~east );
        \fill[ cvbar ]
          ([yshift =-8cm] current~page.east ) rectangle ( current~page.west );
        \fill[ cvprim ]
          ([xshift = -2cm] current~page.north~east ) 
          rectangle ([xshift = 2cm, yshift = -7.5cm] current~page.west );
        \fill[ cvtext ]
          ([xshift = -2cm ] current~page.east ) rectangle(current~page.south);
        \node (editor) at ( [xshift = 2.5cm, yshift=-2.5cm] current~page.north~west )
          [cvtext,anchor=north~west]{\Large\bfseries~责任编辑：\makebox[3em][s]{\tl_use:N \g__trbk_editor_tl}};
        \node (designer) at ( [yshift=-0.5cm] editor.south~west )
          [cvtext,anchor=north~west]{\Large\bfseries~封面设计：\makebox[3em][s]{\tl_use:N \g__trbk_designer_tl}};
        \str_if_empty:NTF \g__trbk_isbn_str
          {
            \node (barcode) at ([xshift=-25mm,yshift=50mm]current~page.south~east)
            [cvbar,anchor=south~east]{ \fbox{\qrcode[nolink,height=4cm]{ \str_use:N \g__trbk_url_str }} };
          }
          {
            \node (barcode) at ([xshift=-25mm,yshift=50mm]current~page.south~east)
            [cvbar,anchor=south~east]{ \trbk_draw_barcode: };
          }
        \draw [cvbar,thick] ([yshift=-2mm]barcode.south~west)--([yshift=-2mm]barcode.south~east)
          node[anchor=north~east,text=cvbar,inner~sep=2mm]{\Large\sffamily~定价：\tl_use:N \g__trbk_price_tl ~元};
    \end{tikzpicture}
  }
% ---- 扉页设计
\cs_new_protected:Nn \trbk_book_flypage:
{
  \begin{titlepage}
    \thispagestyle{empty}\pdfbookmark{扉页}{flypage}
    \begin{flushleft}
      \Huge
      {\scshape\roboto\tl_use:N\g__trbk_book_title_en_tl}
      \par\bigskip\hrule\bigskip
      {\cusong\tl_use:N\g__trbk_book_title_zh_tl}\par
      \bigskip
    \end{flushleft}
    \begin{flushleft}
      \Large\bfseries
      \clist_if_empty:NF \g__trbk_book_author_en_clist
        { \clist_use:Nnnn \g__trbk_book_author_en_clist {\\} {\\} {\\} }
      \par\bigskip
    \end{flushleft}
    \begin{flushright}
      \sffamily \Large \hrule \bigskip
      \clist_if_empty:NF \g__trbk_book_author_zh_clist
        {
          \clist_map_inline:Nn \g__trbk_book_author_zh_clist
            { \__trbk_parse_chinese_person_name_str:n {##1} }
          \qquad
          \str_use:N \g__trbk_written_style_str 
        }
    \end{flushright}
    \vspace{\stretch{1}}
    \begin{center}
      \LARGE 
      \tl_if_empty:NF \g__trbk_dedicated_to_tl 
        { 献给：\tl_use:N \g__trbk_dedicated_to_tl}
    \end{center}
    \vspace{\stretch{1}}
    \begin{center}
      \Large\xwwk\tl_use:N \g__trbk_publisher_tl
    \end{center}
    \newpage\thispagestyle{empty}
    \begin{minipage}{0.8\linewidth}
      \centerline{* ~ * ~ * \quad \makebox[6em][s]{内容简介} \quad * ~ * ~ *}
      \vspace{1em}\parindent 2em \tl_use:N \g__trbk_brief_introduction_tl
    \end{minipage}
    \vfill\parindent 0em
    \makebox[4em][s]{责任编辑}\quad \tl_use:N \g__trbk_editor_tl \par
    \makebox[4em][s]{封面设计}\quad \tl_use:N \g__trbk_designer_tl \par
    \makebox[4em][s]{出版发行}\quad \tl_use:N \g__trbk_publisher_tl \par
    \makebox[4em][s]{网    址}\quad \url{\exp_args:Nc \str_use:N {g__trbk_url_str}} \par
    \makebox[4em][s]{开    本}\quad \rndprintlength{\paperwidth}$\times$\rndprintlength{\paperheight} \par
    \makebox[4em][s]{版    次}\quad \tl_use:N \g__trbk_release_date_tl ~ 发行 \qquad \tl_use:N \g__trbk_print_date_tl ~ 印刷\par
    \str_if_empty:NF \g__trbk_isbn_str 
      {\makebox[4em][s]{书号}\quad \str_use:N \g__trbk_isbn_str \par}
    \makebox[4em][s]{定    价}\quad \tl_use:N \g__trbk_price_tl ~元 \par
    \bigskip \hrule \bigskip
    \begin{center}
      （\tl_use:N \g__trbk_statement_tl）
    \end{center}
  \end{titlepage}
}
% -----------------------------------------------------------------------------
% 自定义设置
% -----------------------------------------------------------------------------
\definecolor{cvtext}{RGB}{255,251,240}
\definecolor{AppleRed}{RGB}{255,95,86}
\definecolor{AppleYellow}{RGB}{255,189,46}
\definecolor{AppleGreen}{RGB}{39,201,63}
\definecolor{ogray}{RGB}{148,147,141}
\definecolor{oorange}{RGB}{233,101,56}
\definecolor{termimal}{RGB}{80,78,70}
\tl_if_empty:NT \g__trbk_release_date_tl 
  {
    \tl_set:Nn \g__trbk_release_date_tl 
      {\the\year 年\the\month 月\the\day 日}
  }
\tl_if_empty:NT \g__trbk_print_date_tl 
  {
    \tl_set:Nn \g__trbk_print_date_tl 
      {\the\year 年\the\month 月\the\day 日}
  }
\ctex_at_end_preamble:n
  {
    \hypersetup{
      pdftrapped    = true,
      pdftitle      = \tl_use:N \g__trbk_book_title_zh_tl,
      pdfcreator    = XeLaTeX,
      pdfpagelayout = TwoPageRight,
      pdfauthor     = \clist_use:Nnnn\g__trbk_book_author_zh_clist{~}{~}{~},
      pdfdisplaydoctitle = true,
    }
    \xpatchcmd\footnoterule{.4\columnwidth}{1in}{}{}
    \xpatchcmd\@makefntext{{\hss\@makefnmark}}{{\hss\@makefnmarkNormal}\space}{}{}
    \def\@makefnmarkNormal{\lower .1ex\hbox{\normalfont\@thefnmark}}
    \tl_if_empty:NT \g__trbk_price_tl
      { \tl_set:Nn \g__trbk_price_tl { \zref[abspage]{LastPage} .00} }
  }
\let\emph\textbf
% -----------------------------------------------------------------------------
% 用户命令定义
% -----------------------------------------------------------------------------
\NewDocumentCommand \Booksetup     { m } 
  {\keys_set:nn { trbk } { #1 }}
\NewDocumentCommand \makecover     {   } 
  { \trbk_book_cover: \global\let\makecover\relax }
\NewDocumentCommand \makeflypage   {   } 
  { \trbk_book_flypage: \global\let\makeflypage\relax }
\NewDocumentCommand \makebackcover {   } 
  { 
    \clearpage
    \bool_if:NT \g__trbk_twoside_bool
      {
        \int_if_odd:nT \c@page
          { \hbox:n { } \thispagestyle { empty } \newpage }
      }
    \trbk_book_back_cover: 
    \global\let\makebackcover\relax
  }
\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \bool_if:NT \g__trbk_twoside_bool
      {
        \int_if_odd:nF \c@page
          { \hbox:n { } \thispagestyle { empty } \newpage }
      }
  }
%% --- 时间线环境
\NewDocumentEnvironment{timeline}{ }
  {
    \begin{list} { } 
    {
      \setlength { \labelwidth    } { 3.5cm}
      \setlength { \labelsep      } { 0.2cm}
      \setlength { \leftmargin    } { 3.7cm}
      \setlength { \rightmargin   } { 0cm  }
      \setlength { \parsep        } { 0ex  }
      \setlength { \itemsep       } { 1ex  }
      \setlength { \itemindent    } { 0em  }
      \setlength { \listparindent } { 3.7cm}
      \renewcommand {\makelabel} [1]
        {
          \makebox{ \parbox[t][1em]{3.3cm}{\raggedleft ##1} }
          \hfill
          \makebox[0pt]
            { \tikz[baseline]\fill[ball~color=genfg](0,0.7ex)circle(0.5ex); }
        }
    }
  }
  { \end{list} }
\tcolorboxenvironment{timeline}
  {
    blanker,
    breakable,
    before~skip=8pt,
    after~skip=8pt,
    borderline~west={0.5pt}{3.5cm}{genfg}
  }
\AfterEndEnvironment{timeline}{\bigskip}
%% --- 公式符号解释环境
\newcounter{qlst}
\NewDocumentEnvironment {EqDesc} { O{式中：} m}
  {
    \xpatchcmd{\@trivlist}{\topsep}{0pt}{}{}
    \xpatchcmd{\@trivlist}{\partopsep}{0pt}{}{}
    \begin{ list } { }
      {
        \usecounter{qlst}
	      \settowidth{\labelwidth}{#1\ensuremath{#2}\ --- \ }
	      \setlength{\labelsep}{0pt}
        \setlength{\leftmargin}{\labelwidth}
        \setlength{\rightmargin}{0em}
        \setlength{\parsep}{0ex}
        \setlength{\itemsep}{0ex}
        \setlength{\itemindent}{0em}
        \setlength{\listparindent}{0em}
        \renewcommand{\makelabel}[1]
          {
            \stepcounter{qlst}
            \int_compare:nNnTF {\value{qlst}} > {1}
              {\hfill\ensuremath{##1}\ --- \ }
              {#1\hfill\ensuremath{##1}\ --- \ }
          }
      }
  }
  { \end { list } }
%% --- 信息、警告、贴士、错误 信息框
\DeclareTotalTColorBox{ \alertwarning } { +m }
  { alertbox = orange } { \centering\faExclamationTriangle \tcblower #1 }
\DeclareTotalTColorBox{ \alertinfo } { +m } 
  { alertbox = blue } { \centering\faInfoCircle \tcblower #1 }
\DeclareTotalTColorBox{\alerttip} { +m } 
  { alertbox = green } { \centering\faCheckCircle \tcblower #1 }
\DeclareTotalTColorBox{\alerterror} { +m } 
  { alertbox = red } { \centering\faTimesCircle \tcblower #1 }
\DeclareTotalTColorBox{\alertupdate} { +m } 
  { alertbox = cyan } { \centering\faArrowCircleUp \tcblower #1 }
%% --- 系统变量盒子
\DeclareTotalTCBox{ \osvar }{ m }
  { smallbox  = olive, fontupper = \sffamily }
  { #1 }
\DeclareTotalTCBox{ \oscommand }{ m }
  { smallboxdark  = olive  }
  { #1 }
%% --- shell 命令行格式
% \newtcblisting{oscmd}{osshell=\$}
\DeclareTCBListing{ oscmd }{ O{command.com} }
{  osshell=#1 }
%% --- 字符串样式
\NewDocumentCommand\Str { m } { \texttt{#1} }
%% --- 文件名及扩展名的格式
\NewDocumentCommand\fname { m }
  { \scalebox{ 0.8 } {\faFile*[regular]} \nobreakspace\texttt{ #1 } }
%% --- 编程语言参数解释环境
\NewDocumentEnvironment{ argdesc }{ O{9em} }
  {
    \begin{description}
      [
        style     = nextline,
        leftmargin= #1,
        font      = \mdseries
      ]
  }
  { \end{description} }
%% --- 落款格式
\NewDocumentCommand { \Inscribe }{ o m }
  {
    \par\vspace*{2em}
    \begin{flushright}
      --- ~ #2 \hspace*{4em}\mbox{}
      \IfNoValueF {#1} {\par #1 \hspace{2em}} 
    \end{flushright}\par
  }
\NewDocumentCommand { \CInscribe } { o m }
  {
    \par\vspace*{2em}
    \begin{flushright}
      { \large #2 } \hspace*{ 4.5em }\mbox{}\par
      \IfNoValueTF {#1} 
        {  
          #1 \hspace{2em}\mbox{}
        } 
        { 
          \tl_set:Nx \l_tmpa_tl { \__trbk_date_parse:n { #1 } } 
          \tl_use:N \l_tmpa_tl \hspace{2em}\mbox{}
        } 
    \end{flushright}\par
  }
\NewDocumentCommand \pnme { m } { \textsc { #1 } }
\NewDocumentCommand \pnmc { s m } 
  {
    \IfBooleanTF#1
      { \setlength \fboxsep { 1pt } \fbox{ #2 } }
      { \mbox{ #2 } }
  }
\NewDocumentCommand \Pnmc { s m } 
  {
    \IfBooleanTF#1
      { 
        \setlength \fboxsep { 1pt }
        \int_compare:nNnTF { \str_count_ignore_spaces:n { #2 } } = { 2 } 
          { \framebox[3em][s]{ #2 } }
          { \fbox{ #2 } }
      }
      { 
        \int_compare:nNnTF { \str_count_ignore_spaces:n { #2 } } = { 2 }
          { \makebox[3em][s]{ #2 } }
          { \mbox{ #2 } }
      }
  }
% ------------------------------------------------------------------------------
% 启动执行
% ------------------------------------------------------------------------------
\AtBeginDocument{ \makecover\makeflypage  }
\AtEndDocument{ \makebackcover }
%-------------------------------------------------------------------------------
\endinput