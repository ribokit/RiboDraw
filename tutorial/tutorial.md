# RiboDraw Tutorial
Layout of the P4-P6 tertiary structure, showing noncanonical pairs  
_(C) Rhiju Das, Stanford University, 2018_

Please e-mail questions to `ribokit.info@gmail.com`


##Goal

This tutorial aims to show you how to use the RiboDraw code to make a nice layout of the P4-P6 domain of the *Tetrahymena* group I self-splicing intron, based on the classic crystal structure  by Cate et al., [1GID](https://www.rcsb.org/structure/1gid). By the end of this tutorial, you'll know how to make this picture:

![1gidA RiboDraw drawing](images/1gidA_drawing.png)

And along with it you'll have a Pymol Session with the 3D structure colored in an analogous way:

![1gidA Pymol](images/1gidA_pymol.png)

If you just want to skip ahead and check out an example of the final result, there are example output files in [example_output/](example_output) you can load in the drawing in MATLAB with:

```
load_drawing('example_output/1gidA_drawing.mat');
```

You can also try to follow the commands in [P4P6\_drawing\_commands.m](P4P6_drawing_commands.m), but they are better explained below. If you get stuck at particular steps, you can also load in intermediate drawings with the `load_drawing` command and the drawing workspaces saved in [example_output/workspaces/](workspaces)

## Before you start the tutorial
First, check out the [getting started](../README.md) page for RiboDraw & Rosetta installation instructions.

You might want to sketch out a drawing of your RNA 3D structure. For this tutorial, we're choosing to make the P4-P6 RNA, for which numerous representations are already floating around the literature (or passed around labs), though most leave out noncanonical pairs. Here's a picture one diagram that was passed to me by Rick Russell, with some handwritten annotations:
![P4P6 legacy image](images/P4P6_Legacy_Secstruct.JPG)

## Let's do this

### Step 0. Initialize the drawing

You'll first need to download the 3D structure from the PDB, cut out the bits you want to look at, and run the `rna_motif` Rosetta application. 

I've alread done this in [1gid_RNAA.pdb](1gid_RNAA.pdb). This is chain A from the PDB entry [1GID](https://www.rcsb.org/structure/1gid). I think I used `make_rna_rosetta_ready.py` and `extract_chain.py` in Rosetta's `rna_tools`, but you can also just prepare a similar file by hand.

Put this file into a new directory called `rna_motif`, and go into that directory:

```bash
mkdir rna_motif
cp 1gid_RNAA.pdb rna_motif
cd rna_motif
```

Now run on the UNIX command line:

```bash
rna_motif -s 1gid_RNAA.pdb -ignore_zero_occupancy false
```

You may need to use the full executable name (something like `rna_motif.macosclangrelease`) depending on how you've compiled Rosetta. The `-ignore_zero_occupancy false` flag tells Rosetta to go ahead and include a couple uridines that were uncertain in the experimental map and flagged as such by having their occupancies set to 0 in the PDB coordinate file.

The output should be a bunch of files:
```
1gid_RNAA.pdb.base_pairs.txt
1gid_RNAA.pdb.fasta
1gid_RNAA.pdb.ligands.txt
1gid_RNAA.pdb.motifs.txt
1gid_RNAA.pdb.other_contacts.txt
1gid_RNAA.pdb.stacks.txt
1gid_RNAA.pdb.stems.txt
```

These have the relevant information for RiboDraw. (Examples of these files are inside this tutorial directory `example_output/rna_motif/`[example_output/rna_motif/])

Last, you should probably define names of your helices. Open up `1gid_RNAA.pdb.stems.txt` in your favorite text editor. It should look like this:
```
A:107-110 A:211-214
A:111-112 A:208-209
A:116-121 A:200-205
A:127-129 A:193-195
A:131-134 A:189-192
A:136-138 A:180-182
A:141-149 A:154-162
A:165-166 A:174-175
A:220-223 A:250-253
A:227-235 A:239-247
```

You'll want to then add in labels for the helix/stem names that are conventional for researchers studying the molecule. In the case of P4-P6, I used:
```
A:107-110 A:211-214 P4
A:111-112 A:208-209 P4*
A:116-121 A:200-205 P5
A:127-129 A:193-195 P5a
A:131-134 A:189-192 P5a*
A:136-138 A:180-182 P5a**
A:141-149 A:154-162 P5b
A:165-166 A:174-175 P5c
A:220-223 A:250-253 P6a
A:227-235 A:239-247 P6b
```

A note here: By convention the entire stretch of 107-112 and 208-214, which is interrupted by a bulge at A210 is usually called P4. Rosetta and RiboDraw go ahead and split these into two helices. We'll call the second helical segment `P4*` for now, and hide this label later. Ditto for P5a.

Now, go into MATLAB and get into this `tutorial` directory. Type:

```Matlab
initialize_drawing( 'rna_motif/1gid_RNAA.pdb' );
```

Your MATLAB figure window should look like this:

![Step 0 initialize_drawing](images/step00_initialize_drawing.png)

Its a little crazy but all the information needed for the drawing is in there -- we just need to lay it out.

### Step 1
```Matlab
% move around stems
hide_noncanonical_pairs
show_helix_controls
set_artboards
save_drawing( 'steps/step01_movestems.mat' );
export_drawing( 'steps/step01_movestems.png' );
```

### Step 2
```
% a little more flipping to match 'standard' diagram --
%  note will demonstrate how to flip the P5abc domain later.
save_drawing( 'steps/step02_minortweaks.mat' );
export_drawing( 'steps/step02_minortweaks.png' );
```

### Step 3
```
% build in noncanonical pairs
% zoom in to particular regions
% move linkers.
%
% can associate loop residues with new helices -- show that.
%
% can add joints to linkers by pulling on little circles at residues --
%   show that. 
%  can also remove joints by moving little circles back on to residues --
%  show that.
%
% NOTE NONCANONICAL PAIRS FOR LAST TWO NTS (U259, C260) LOOK MISASSIGNED!
show_noncanonical_pairs
show_linker_controls
color_drawing rainbow
% and in pymol, rrs()
save_drawing( 'steps/step03_P4_P6ab_linkers.mat' );
export_drawing( 'steps/step03_step03_P4_P6ab_linkers.png' );
```
### Step 4
#### Step 4A
```Matlab
% zoom out (double click with magnifying glass icon)
 slice_drawing( 'A:127-195' )
% Will get:
% Warning! slice_res only catches part of helix Helix_A127. Will include the rest of that helix too
color_drawing rainbow
set_artboards
hide_helix_label( 'P5a*' );
hide_helix_label( 'P5a**' );

save_drawing( 'steps/step04A_P5abc_slice.mat' );
export_drawing( 'steps/step04A_P5abc_slice.png' );

% in pymol 
%  color white
%  rrs( 'chain A and resi 127-195')
% hide ev, not (chain A and resi 127-195)
```
#### Step 4B -- fine scale fixup of P5abc
```Matlab
% G156 -- associate with P5b.
save_drawing( 'steps/step04B_P5abc_refine_slice.mat' );
export_drawing( 'steps/step04B_P5abc_refine_slice.png' );
```

#### Step 4C -- merge drawing back in
```Matlab
merge_drawing( 1 );
set_artboards
save_drawing( 'steps/step04C_P5abc_merge_slice.mat' );
export_drawing( 'steps/step04C_P5abc_merge_slice.png' );
```
### Step 5 -- flip P5abc
```Matlab
setup_domain(  'A:127-195','P5abc' )
list_domains
hide_domain_label( 'P5abc' )
%
%*P5abc (Selection_P5abc_domain)
%
% * = label visible.
%
list_domains
% P5abc (Selection_P5abc_domain)
%
%* = label visible.

show_domain_controls
% flipped it.
color_drawing rainbow
save_drawing( 'steps/step05_flipP5abc.mat' );
export_drawing( 'steps/step05_flipP5abc.png' );
```

### Step 6
```Matlab
% Step 6 -- the rest of the linkers
% also rainbow-colored pymol
% rrs()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hide_helix_label( 'P4*')
hide_domain_controls
save_drawing( 'steps/step06_refineall.mat' );
export_drawing( 'steps/step06_refineall.png' );
```

### Step 7
```
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 7 -- some recoloring in both ribodraw and pymol
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hide_linker_controls
hide_helix_controls
color_drawing gray
color_drawing marine P5abc 
setup_domain(  'A:122-198','P5abc' ); % expand P5abc to encompass whole 'left hand' of drawing
color_drawing marine P5abc 
setup_domain(  'A:107-121 A:199-214','P4P5' );
color_drawing purple P4P5 
setup_domain(  'A:220-253','P6' ); 
color_drawing forest P6 
hide_domain_label( 'P5abc' );
hide_domain_label( 'P4P5' );
hide_domain_label( 'P6' );

% and in pymol
% color gray
% select P5abc, resi 122-198
% select P4P5, resi 107-121 or resi 199-214
% select P6, resi 220-253
% color marine, P5abc
% color purple, P4P5
% color forest, P6
% hide spheres
% save /Users/rhiju/Desktop/1gid_RNAA.pse  
save_drawing( 'steps/step07_final.mat' );
export_drawing( 'steps/step07_final.png' );

save_drawing( '1gidA_drawing.mat' );
export_drawing( '1gidA_drawing.png' );
```



