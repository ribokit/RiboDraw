%load_drawing 23S_5S_drawing_eterna_theme_UPDATE.mat
%
% note that we decided to turn off all locks and all don't cares

full_secstruct  = '((((((((......((((((((((......((..(((((((((((((......((((((........))).....((((((...(((.......))).......))))))...)))....(((....)))(((((.(....).))))).(((((((((.........))))))))).))...((((((...................))))).).........((....))...(((((.....((.....))....)))))...(((..((((......(((((((((.(((.(((...(((((......)))))........(((.......)))...)))...))).)))))))))...))))........((((((((.........))))))))......(((((......)))))..)))......)).))))))).))...............((....))....)).........((((.....))))...................)))))))))).......((((..(((((......)))))..))))..................((((((....(((((((((((((..(((...((.....))...)))...((....))..((((.....)))).....)))))))))))))..((.....((((((.....((((((((((.((((...((((((......))))))...).)))...(((.(((((........))))))))..).)))))))))...(((.....)))......))))))........))..((((((....(((((....))))).((((((((..((((((((((.....(((...(((.((((...((.((.........))..))...)))).)))..)).).....)))))).)))..)))))))).)...(((((((((........)))))))))....(((......)))...((((.(((...(((......(.((((((...........((..(((((..(((.......(((((.(((..(((.........)))..)))........(((......)))..)))))...)))..))))).))...................))))))))))...)))))))((((((((......))))))))....))))))..(((((...(((......((((((((....))))))))...)))..)))))........)))))).......((.....((((((.......))))))((((....((((..((..(((((((...((.....)).))))))......(((.(((.(.(((...(((....)))...)))..))))..(((((........)))))..(((((((((((((...((((....((((..(((..((((((((((((.......).))))))((..((((....(((((((((((.((.....))))))))))..)))....))))...))(..(((((....)))))...))))))...)))...)))).........))))...))....))))))))))).))).))).....((......)).)))).((((.....))))..))))..((((....((((((((.((..(............(((((...............)))))((((((.....(((...((((.....))))...)))...))))))............(((((((((...((.........))...(((((((.....(((....))).......)))))))..((((.(((..(((((((..(((........(((((..((....))...)))))........))))))))..)))))(((((.........)))))....................(((((.......)))))..........))))...)).)))))))....))).)))))))).))))))...........(((((........)))))..((((((((.(((.((......((((.((((((..(((((.(((.(((((.((((((((((...((...............((...((......(.((((((....)))))).)...)).............))......))...))))))))))...(((.((((((.....)))))))))....))))).)))..)))))..(((.......)))((((((...........))))))..((...(((((((...((((((.......)))))).....((......))....)))))))...((((..((((....))))..)))).(((....))).))..........(((((((.((........))))))))).............))))..))))))......((((..(.((((((...((.......))...))))))...).)).).).....((.((.((((((..(((((((((......))))))..))).(((((.....))))).....)))))..)...))..))....(..((((....))).)..)....))..)))))))))))....(((((((...((((..(((((((...............))))))).(((((...((((...(((((((((((....))))))..)))))...)))).)))))...(((....((((.............))))....))).)))).......)))))))(.(((((.....))))).....((..(((((.......)))))....((((((((..((....(((((....)))))...))...))))).))).....))....)))))))))..';
full_locks      = repmat('o',1,length(full_secstruct));
full_sequence   = 'GGUUAAGCGACUAAGCGUACACGGUGGAUGCCCUGGCAGUCAGAGGCGAUGAAGGACGUGCUAAUCUGCGAUAAGCGUCGGUAAGGUGAUAUGAACCGUUAUAACCGGCGAUUUCCGAAUGGGGAAACCCAGUGUGUUUCGACACACUAUCAUUAACUGAAUCCAUAGGUUAAUGAGGCGAACCGGGGGAACUGAAACAUCUAAGUACCCCGAGGAAAAGAAAUCAACCGAGAUUCCCCCAGUAGCGGCGAGCGAACGGGGAGCAGCCCAGAGCCUGAAUCAGUGUGUGUGUUAGUGGAAGCGUCUGGAAAGGCGCGCGAUACAGGGUGACAGCCCCGUACACAAAAAUGCACAUGCUGUGAGCUCGAUGAGUAGGGCGGGACACGUGGUAUCCUGUCUGAAUAUGGGGGGACCAUCCUCCAAGGCUAAAUACUCCUGACUGACCGAUAGUGAACCAGUACCGUGAGGGAAAGGCGAAAAGAACCCCGGCGAGGGGAGUGAAAAAGAACCUGAAACCGUGUACGUACAAGCAGUGGGAGCACGCUUAGGCGUGUGACUGCGUACCUUUUGUAUAAUGGGUCAGCGACUUAUAUUCUGUAGCAAGGUUAACCGAAUAGGGGAGCCGAAGGGAAACCGAGUCUUAACUGGGCGUUAAGUUGCAGGGUAUAGACCCGAAACCCGGUGAUCUAGCCAUGGGCAGGUUGAAGGUUGGGUAACACUAACUGGAGGACCGAACCGACUAAUGUUGAAAAAUUAGCGGAUGACUUGUGGCUGGGGGUGAAAGGCCAAUCAAACCGGGAGAUAGCUGGUUCUCCCCGAAAGCUAUUUAGGUAGCGCCUCGUGAAUUCAUCUCCGGGGGUAGAGCACUGUUUCGGCAAGGGGGUCAUCCCGACUUACCAACCCGAUGCAAACUGCGAAUACCGGAGAAUGUUAUCACGGGAGACACACGGCGGGUGCUAACGUCCGUCGUGAAGAGGGAAACAACCCAGACCGCCAGCUAAGGUCCCAAAGUCAUGGUUAAGUGGGAAACGAUGUGGGAAGGCCCAGACAGCCAGGAUGUUGGCUUAGAAGCAGCCAUCAUUUAAAGAAAGCGUAAUAGCUCACUGGUCGAGUCGGCCUGCGCGGAAGAUGUAACGGGGCUAAACCAUGCACCGAAGCUGCGGCAGCGACGCUUAUGCGUUGUUGGGUAGGGGAGCGUUCUGUAAGCCUGCGAAGGUGUGCUGUGAGGCAUGCUGGAGGUAUCAGAAGUGCGAAUGCUGACAUAAGUAACGAUAAAGCGGGUGAAAAGCCCGCUCGCCGGAAGACCAAGGGUUCCUGUCCAACGUUAAUCGGGGCAGGGUGAGUCGACCCCUAAGGCGAGGCCGAAAGGCGUAGUCGAUGGGAAACAGGUUAAUAUUCCUGUACUUGGUGUUACUGCGAAGGGGGGACGGAGAAGGCUAUGUUGGCCGGGCGACGGUUGUCCCGGUUUAAGCGUGUAGGCUGGUUUUCCAGGCAAAUCCGGAAAAUCAAGGCUGAGGCGUGAUGACGAGGCACUACGGUGCUGAAGCAACAAAUGCCCUGCUUCCAGGAAAAGCCUCUAAGCAUCAGGUAACAUCAAAUCGUACCCCAAACCGACACAGGUGGUCAGGUAGAGAAUACCAAGGCGCUUGAGAGAACUCGGGUGAAGGAACUAGGCAAAAUGGUGCCGUAACUUCGGGAGAAGGCACGCUGAUAUGUAGGUGAGGUCCCUCGCGGAUGGAGCUGAAAUCAGUCGAAGAUACCAGCUGGCUGCAACUGUUUAUUAAAAACACAGCACUGUGCAAACACGAAAGUGGACGUAUACGGUGUGACGCCUGCCCGGUGCCGGAAGGUUAAUUGAUGGGGUUAGCGCAAGCGAAGCUCUUGAUCGAAGCCCCGGUAAACGGCGGCCGUAACUAUAACGGUCCUAAGGUAGCGAAAUUCCUUGUCGGGUAAGUUCCGACCUGCACGAAUGGCGUAAUGAUGGCCAGGCUGUCUCCACCCGAGACUCAGUGAAAUUGAACUCGCUGUGAAGAUGCAGUGUACCCGCGGCAAGACGGAAAGACCCCGUGAACCUUUACUAUAGCUUGACACUGAACAUUGAGCCUUGAUGUGUAGGAUAGGUGGGAGGCUUUGAAGUGUGGACGCCAGUCUGCAUGGAGCCGACCUUGAAAUACCACCCUUUAAUGUUUGAUGUUCUAACGUUGACCCGUAAUCCGGGUUGCGGACAGUGUCUGGUGGGUAGUUUGACUGGGGCGGUCUCCUCCUAAAGAGUAACGGAGGAGCACGAAGGUUGGCUAAUCCUGGUCGGACAUCAGGAGGUUAGUGCAAUGGCAUAAGCCAGCUUGACUGCGAGCGUGACGGCGCGAGCAGGUGCGAAAGCAGGUCAUAGUGAUCCGGUGGUUCUGAAUGGAAGGGCCAUCGCUCAACGGAUAAAAGGUACUCCGGGGAUAACAGGCUGAUACCGCCCAAGAGUUCAUAUCGACGGCGGUGUUUGGCACCUCGAUGUCGGCUCAUCACAUCCUGGGGCUGAAGUAGGUCCCAAGGGUAUGGCUGUUCGCCAUUUAAAGUGGUACGCGAGCUGGGUUUAGAACGUCGUGAGACAGUUCGGUCCCUAUCUGCCGUGGGCGCUGGAGAACUGAGGGGGGCUGCUCCUAGUACGAGAGGACCGGAGUGGACGCAUCACUGGUGUUCGGGUUGUCAUGCCAAUGGCACUGCCCGGUAGCUAAAUGCGGAAGAGAUAAGUGCUGAAAGCAUCUAAGCACGAAACUUGCCCCGAGAUGAGUUCUCCCUGACCCUUUAAGGGUCCUGAAGGAACGUUGAAGACGACGACGUUGAUAGGCCGGGUGUGUAAGCGCAGCGAUGCGUUGAGCUAACCGGUACUAAUGAACCGUGAGGCUUAACCUU';
full_IUPAC      = 'RRUYARGYRRHBAAGBGYAYRHGGYRRAUGCCYDGGCRRWVASAGGCGAWRAARGRCGURNDWDBBKRCGAWAASBBNNGRBVAGBYRRBADNRDVCNNWNNNNNCNNVSAUNYYYGAAURGGRVAAYCCRVYNNNNNUHRNNNNRBYWWYDHNHNVBNRAUHCAUMRBNDNDHRRRGSDAASSNRGDRAASUGAAACAUCUHAGUABYYNBAGGARMRGAAAUCAAYHGAKAUUYCSNHAGUAGYGGCGARCGAAMVBGRANNAGYCHNGARCCUGAAUCAGYRKRUGUGUUARNDRAABSRUYUGGAAARKYVMRCSRDASHRRGUGABADYCYBGUANNYAAAAAUGCACAURCUGUGAGCUCRMHRARUARRDCGRVRCACGWGDHAYBYUGWYUGAANAWRGGGGGMCCAUCCUCYAAGRCUAAAUACUMSUBWYYGACCGAUAGYGAACHAGUACYGURARGVAARGKBRAAAAGAACCSCKGHDAGGGSAGUGAAAHAGAWMCURAAACYBBRURCVUACAAGCWGURGRAGYVNNNUUAGNBNKGYGACUGCGUACCUUUUGUAUMAUSGGUCAGCGASUURYWYDYHGURGCRAGSUUAABCRHVUAGSGDAGSCGNARVRAAABCGAGUYYKAAHHRRGCRHUAAGUYKCDRBVWRYASACCSRAMMCSNRRYGAUCUABYYAUGRBCAKGDWGRRKGYNRRGUAAHAYYDRCUGRAGGDCCGAMCYSACKNHYGUKRMAARRBBMGSGGAUGAVHUGUGRMUVGGRGUGAAAGRCYAAWCAARYYNGGWGAUAKCUGGUUCUCCYCGAAAKCUAUUKAGGUAGMGCSUHNNRNDHWNRYYNNNSGRGGUAGAGCWCUGUUWNGRYHAKRGGKYYWBMCCGVMYURBSRANYCNWKGCAAACUVCRAAUACBNNNRRRYDHNDDYNYRGSAGWCABWCDRCGGKUGMUAASSWYCGUNGUSRARAGGRWRAVRRYCCAKAYCGHCRGMUMRSRNCYCVARRUYNHDRYUMAGUGGKAAACGAWGUGGGAARGCHYAVACARCYAGGABSUUKGCYUAGAMGCAGCCAHCMUUWAAAGAAAGCSUAAUAGCUCACURGWCRAGUYRKYCYGCGCGGAAGAUDUAACGGGGYWAARYHDNRYRCCRAAGCYRCGGCAGCGACRCUUAUGCGUUGUUGGGUAGRGGAGCGUUSKGUAMGBSDDHGAAGRKNNNYYGDRARRBNKRYUGGASVUAUCMSAAGUGCGAAUGCUGACRURAGUARCGAYAADRBRDGUGAAAWVCHYVYHCGCCGDAARHCYAAGGDUUYCWGYBCAAMGUYAAUCKRVGCWGRGUDAGYCGRYHCCUAAKRYRAGGCHGWRRDGCGUARHYRAUGGRWADYNGGUUAAUAKUCCNRHRCUUGGUGUUACUGCGAAGGGGGGACGGAGAAGGCUAUGUUGGCCGGGCGACGGUUGUCCCGGUUUAAGCGUGUAGGCUGGUUUUCCAGGCAAAUCCGGAAAAUCAAGGCUGAGGCGUGAUGACGAGGCACUACGGUGCUGAAGCAACAAAUGCCCUGCUUCCAGGAAAAGCCUCUAAGCAUCAGGUAACAUCAARYCGUACYNNAAACSRACACASGURGDYRGGWHGARWAKWCYMAGGCGCUUGAGAKAMCYYDGSUGAAGGAACUMGGCAAAWURRHRCCGUAACUUMGGRAGAAGGYDYGCYVNYAUGUAGGUGARGUCCCUCGCGGAUGGAGCUGAARNBRGYBRMAGHDAHSMGVYSGCUGSRACUGUUUAHYAAAAACAYRSVACWSUGCDAAVDCGNAAGHBRRMGUAUASKGUSUGAYRCCUGCCCGGUGCYKGAAGGUUAADYRADRRDGUHADMBHMRKHRAAGCWYYDRAHHGAAGCCCCRGUAAACGGCGGCCGUAACUAUAACGGUCCYRWKGUAGYKAMRUWCCUUGUCGGGYAAGUWYSGACCUGCACGAAUGGYRUAAYSAYGGCSRBRCUGUCUCCASCHGRGRSUCAGYRAARWYGAANUYGCHGHKAAGRURCDGYRUWYCCRYGGCWAGACGGAAAGACCCCGUGMACCUUUACURYARCUUDRYAYKGAHCHYYRRNHHBDNHYGUGYAGRAUAGVUGGKAGVCWDWGAARNNNDDRCGCYAGYHNBNNUGGAGBCRDHSKUGAAAUACCABYCUKBNNNNBYYKDKGYUCUMACBHNRNNBHVKNAHHBKRNNHDVRRACMRUGYHWGGYRGGYAGUUUGACUGGGGCGGUCUCCUCCYAAARNGUAACGGAGGAGYRCDAARRUDNVCUMAKMVYGGUYGGAHAUCRBKMRBWKWGURYAAWGGYANAAGBNHGYUUVACUGYGAGMVNBAYRVBKCRAGCAGRURCGAAAGYAGGUCWUAGUGAUCCGGURGUYCUKHAUGGAARGGSCAUCGCUCAACGGAUAAAAGGUACKCYGGGGAUAACAGGCURAUWCCVCCCAAGAGYUCAYAUCGACGGBGGWGUUUGGCACCUCGAUGUCGGCUCAUCDCAUCCUGGRGCUGHAGYNGGUCCCAARGGUAUGGCUGUUCGCCAUUUAAAGHGGUACGYGASCUGGGUUYARAACGUCGUGAGACAGUUYGGUCCCUAUCURYCRUGGRHGHWDGADDWYUGADDRRRKYUGMYYYUAGUASSAGAGGACCRRRKUGRACGHRYYDCUGGUGUWYVGGUUGUBHYGCCARDSGCAYHGCCBGGUAGCUAHRUDCGGHMDNGAUAASYGCUGAAMGCAUMUAAGCRBRARRCBHVYYHHRAGAUDARWHHKCHSKRRVNVHDHRDBNBYHYDDAAGRDNYGUBVNAGACBABVASGUWRAUAGGYNVSRWGUGDARKYDHDRNDWKDHRUKNAGCKRASBNRUACUAAUBRVYCGWGMGRCUURAYYHU';
full_structure_constrained_bases = [];
export_full = 0;

domains = {...
    'Selection_Domain_I_domain',...
    'Selection_Domain_II_3prime_extension_domain','Selection_Domain_II_5prime_extension_domain','Selection_Domain_II_core_domain',...
    'Selection_Domain_III_domain',...
    'Selection_Domain_IV_core_domain',...
    'Selection_Domain_IV_3prime_extension_domain',...
    'Selection_Domain_V_Central_Protuberance_domain',...
    'Selection_Domain_V_L1_stalk_domain',...
    'Selection_Domain_V_domain',....
    'Selection_Domain_VI_core_domain',...
    'Selection_Domain_VI_3prime_extension_domain',...
    'Selection_Domain_0_domain',...
    'Selection_Front_Layer_domain',...
    'Selection_Middle_Layer_domain',...
    'Selection_Top_Front_Layer_domain',...
    'Selection_Main_Front_Layer_domain',...
    'Selection_VeryBackLayer_domain',...
    'Selection_Back_Layer_domain',...
    'Selection_Peptidyl_Transferase_Center_domain',...
    };
    
domains = {'Selection_Domain_VI_3prime_extension_domain','Selection_Domain_II_5prime_extension_domain','Selection_Middle_Layer_domain'};
domains = {'Selection_Domain_IV_3prime_extension_domain'};

for i = 1:length( domains )
    figure(1);
    domain = getappdata(gca,domains{i} );
    slice_drawing( domains{i} );
    export_eterna(domains{i}, full_sequence, full_secstruct,full_locks,full_IUPAC,full_structure_constrained_bases, export_full );
    close( gcf );
    fprintf( 'DOMAIN NAME: %s\n\n\n',domain.name );
end