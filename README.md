# 汇编语言学习
<b>参考书：</b>使用王爽写的《汇编语言》第三版<br />
<b>学习工具(win7 x64)：</b>
DOSBox 0.74、masm.exe、link.exe、debug.exe。<br />
另外需要一款编辑器，用来编辑源程序，推荐sublime text。需要到这里下载支持汇编语法高亮的插件：<a href="https://github.com/Nessphoro/sublimeassembly" target="_blank">https://github.com/Nessphoro/sublimeassembly</a><br />
## 目录介绍
<big><b>学习工具</b></big>：包含win7 64位下需要的工具：DOSBox 0.74安装包、masm.exe、link.exe、debug.exe<br />
<big><b>experiment.asm</b></big>：参考书上面的练习与实验（不全，但需要的代码都在里面）

## 64位windows7下DOSBox使用方法：
<big><b>step1：</b></big>新建文件夹（下面以`C:\coding\assembly-language-learning`为例）<br />
<big><b>step2：</b></big>将`debug.exe`、`masm.exe`、`link.exe`放到`C:\coding\assembly-language-learning`文件夹下<br />
<big><b>step3：</b></big>打开DOSBox。这里可以看到Z:\DOSBox里的虚拟盘，我们采用mount命令将其转变到`C:\coding\assembly-language-learning`目录下，如果只是用这一次，可以直接在命令行中输入如下命令：
<pre><code>Z:\> mount d C:\coding\assembly-language-learning
Z:\> D:
D:\>
</code></pre>
如果是一直使用，则可以修改autoexe，方法如下：
打开`DOSBox 0.74 Options`，在打开的文件里找到`[autoexec]`（应该在文本的最后位置），向下面那样在末尾添加上面两条命令
<pre><code>[autoexec]
\# Lines in this section will be run at startup.
\# You can put your MOUNT lines here.
mount d c:\coding\assembly-language-learning
D:
</code></pre>
<big><b>step4：</b></big>接下来在目录C:\coding\assembly-language-learning下编写源程序（假设1.asm）并按照如下方式编译链接并运行或者调试
<pre><code>[autoexec]
D:\>masm 1;		快速编译（省略生成中间文件）
D:\>link 1;		快速链接（省略生成中间文件）
D:\>1.exe		运行可执行程序
D:\>debug 1.exe		debug中进行调试
</code></pre>