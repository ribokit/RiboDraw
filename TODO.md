## TODO
* write a hacky send_to_back() function to replace uistack.
* allow setup_tertiary_contact to accept 'master linker' to inherit rel_pos, etc.
* more arrowheads on long linkers [extra_arrows1, extra_arrows2]
* allow rename of helices as 'display_label' [cleanup layout of 23S]
* protein/exit tunnel representation
* Read-in & auto-color motifs [SRL, etc.]

* Fix chains for 5S RNA

### Documentation stuff
* put in docstrings for all files
* document JSON file format.
* explain difference: stems vs. helices
* check independence from RiboKit

### Future
* settings icon for toggles --> menu.
* auto-rectify linkers
* pathfinder routine for arrow linkers & noncanonical pairs
* convert to javascript
* Calculate 3D helix axis vectors in Rosetta and use to cross-check 2D helix orientations
* Allow DSSR setup of input files from PDB
* Initialization from secstruct alone (no PDB)
* Create a 'score' for total number of harmonious elements [e.g. lack of explicit linkers, mainly horizontal and vertical lines]
* For demo, produce 3-4 level 'game' 
* document MATLAB functions in .md, or use Sphinx --> move to RiboKit

