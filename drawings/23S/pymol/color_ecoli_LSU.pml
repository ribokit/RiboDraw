# back layer, domain 3
select domain0,           chain CA and (resi 1-11 or resi 527-584 or resi 1255-1270 or resi 1648-1681 or resi 1990-2042 or resi 2895-2904)
select domain1,           chain CA and resi 12-526
select domain2_5primeext, chain CA and resi 583-810
select domain2core,       chain CA and resi 811-1195
select domain2_3primeext, chain CA and resi 1196-1254
select domain3,           chain CA and resi 1271-1647
select domain4_5primeext, chain CA and resi 1682-1763
select domain4,           chain CA and resi 1764-1989
select domain5_PTC,       chain CA and (resi 2043-2091 or resi 2228-2258 or resi 2426-2625)
select domain5_L1ext,     chain CA and resi 2092-2227
select domain5_CP,        chain CA and resi 2259-2425
select domain6,           chain CA and resi 2626-2788
select domain6_3primeext, chain CA and resi 2780-2894

color white, chain CA
color brown, domain0
color purple, domain1
color lightblue, domain2_5primeext
color marine, domain2core
color lightblue, domain2_3primeext
color violet, domain3
color paleyellow, domain4_5primeext
color orange, domain4
color salmon, domain5_L1ext
color salmon, domain5_CP
color tv_red, domain5_PTC
color forest, domain6
color palegreen, domain6_3primeext

select main_front_layer,     domain4 or domain5* or domain6
select top_front_layer, domain2* and not domain2_5primeext
select front_layer, main_front_layer or top_front_layer
select middle_layer,    domain2_5primeext or domain4_5primeext or domain0 or domain6_3primeext
select back_layer,      domain1 or domain3

# deletion diary from do soon
select 46_181, chain CA and resi 46-181
select 264_430, chain CA and resi 264-430
select 1423_1492, chain CA and resi 1423-1492
select 1514_1558, chain CA and resi 1514-1558
select 1707_1756, chain CA and resi 1707-1756
select 2092_2226, chain CA and resi 2092-2226
select 2297_2322, chain CA and resi 2297-2322
select 476_509, chain CA and resi 476-509
select 626_654, chain CA and resi 626-654
select 704_727, chain CA and resi 704-727
select 1040_1110, chain CA and resi 1040-1110
select 1161_1185, chain CA and resi 1161-1185
select 1205_1240, chain CA and resi 1205-1240
select 1682_1706, chain CA and resi 1682-1706
select 1847_1893, chain CA and resi 1847-1893
select 2833_2884, chain CA and resi 2833-2884
select 1271_1647, chain CA and resi 1271-1647

# proteins
select RPL, chain CC+CD+CE+CF+CG+CH+CJ+CK+CL+CM+CN+CO+CP+CQ+CR+CS+CT+CU+CV+CW+CX+CY+CZ+C0+C1+C2+C3+C4+C5
select L2_CC, chain CC
select L3_CD, chain CD
select L4_CE, chain CE
select L5_CF, chain CF
select L6_CG, chain CG
select L9_CH, chain CH
select L11_CJ, chain CJ
select L13_CK, chain CK
select L14_CL, chain CL
select L15_CM, chain CM
select L16_CN, chain CN
select L17_CO, chain CO
select L18_CP, chain CP
select L19_CQ, chain CQ
select L20_CR, chain CR
select L21_CS, chain CS
select L22_CT, chain CT
select L23_CU, chain CU
select L24_CV, chain CV
select L25_CW, chain CW
select L27_CX, chain CX
select L28_CY, chain CY
select L29_CZ, chain CZ
select L30_C0, chain C0
select L32_C1, chain C1
select L33_C2, chain C2
select L34_C3, chain C3
select L35_C4, chain C4
select L36_C5, chain C5

