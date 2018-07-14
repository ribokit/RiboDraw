# RiboDraw Tutorial
Layout of the P4-P6 tertiary structure, showing noncanonical pairs  
_(C) Rhiju Das, Stanford University, 2018_

Please e-mail questions to `ribokit.info@gmail.com`


##Goal

This tutorial aims to show you how to use the RiboDraw code to make a nice layout of the P4-P6 domain of the Tetrahymena ribozyme, based on the classic crystal structure  by Cate et al., [1GID](https://www.rcsb.org/structure/1gid). By the end of this tutorial, you'll know how to make this picture:

![1gidA RiboDraw drawing](images/1gidA_drawing.png)

And along with it you'll have a Pymol Session with the 3D structure colored in an analogous way:

![1gidA Pymol](images/1gidA_pymol.png)


# Before you start the tutorial
First, check out the [getting started](../README.md) page for RiboDraw installation instructions.

You might want to sketch out a drawing of your RNA 3D structure. For this tutorial, we're choosing to make the P4-P6 RNA, for which numerous representations are already floating around the literature (or passed around labs), though most leave out noncanonical pairs. Here's a picture one diagram that was passed to me by Rick Russell:
![P4P6 legacy image](images/P4P6_Legacy_Secstruct.JPG)

### Step 0. Initializing the drawing

Download RiboKit either by cloning this repository:
```
git clone https://github.com/RiboKit/RiboDraw.git 
```
or check for the latest release at:
```
https://github.com/RiboKit/RiboDraw/releases
```
