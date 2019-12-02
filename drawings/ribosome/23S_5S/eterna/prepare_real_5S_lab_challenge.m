%load_drawing 5S_drawing_eterna_theme_ALTLAYOUT.mat

full_secstruct  = '((((((((((.....((((((((....(((((((.............))))..)))...)))))).)).((.((....((((((((...))))))))....)).))...)))))))))).';
full_locks      = 'oooooooooooooooxoooooooooooooooooooooxoooooxoooooooooooooooooooooooxoxxoooooooooooooooooooooooooooooooooxxoooooooooooooo';
full_sequence   = 'UGCCUGGCGGCCGUAGCGCGGUGGUCCCACCUGACCCCAUGCCGAACUCAGAAGUGAAACGCCGUAGCGCCGAUGGUAGUGUGGGGUCUCCCCAUGCGAGAGUAGGGAACUGCCAGGCAU';
full_IUPAC      = 'UGYYUGRYGRCMAUAGMRHDDUGGWMCCACCYGAYYCCAUBCCGAACUCRGHAGUGAAACGNHDYWKCGCCGAUGRUAGUGUGGSGHYUCSCCAUGYGARAGUAGGDMAYYGYCARRYWU';
full_structure_constrained_bases = [1,14, 17,65, 78,96, 109,119];
export_full = 1;

export_eterna('5S rRNA', full_sequence, full_secstruct,full_locks,full_IUPAC,full_structure_constrained_bases, export_full );