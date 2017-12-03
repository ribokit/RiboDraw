# back layer, domain 3
select domain_5prime,  segid V  and (resi 1-559 or resi 913-920)
select domain_C,       segid V  and (resi 560-912)
select domain_3primeMajor, segid V  and (resi 921-1398)
select domain_3primeminor, segid V  and (resi 1399-1542)

color white, chain CA
color marine, domain_5prime
color violet, domain_C
color tv_red, domain_3primeMajor
color gold,   domain_3primeminor

# proteins
select RPS, chain BB+BC+BF+BE+BF+BG+BH+BI+BJ+BK+BL+BM+BN+BO+BP+BQ+BR+BS+BT+BU
select S2_BB, chain BB
select S3_BC, chain BC
select S4_BD, chain BD
select S5_BE, chain BE
select S6_BF, chain BF
select S7_BG, chain BG
select S8_BH, chain BH
select S9_BI, chain BI
select S1_BJ, chain BJ
select S1_BK, chain BK
select S1_BL, chain BL
select S1_BM, chain BM
select S1_BN, chain BN
select S1_BO, chain BO
select S1_BP, chain BP
select S1_BQ, chain BQ
select S1_BR, chain BR
select S1_BS, chain BS
select S2_BT, chain BT
select S2_BU, chain BU
