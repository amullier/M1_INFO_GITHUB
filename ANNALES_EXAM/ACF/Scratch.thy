theory Scratch
imports Main (* "~~/src/HOL/Library/Code_Target_Int" "~~/src/HOL/Library/Code_Char" *)
begin

(*
  EXAM ACF 2013/2014 : 1ERE SESSION
*)
type_synonym point = "nat * nat"
type_synonym fenetre = "point * point"
(*Une interface est une pile de fenetre*)
type_synonym interface = "fenetre list"
(*Un mode de selection de fenetre = soit ouverture soit fermeture*)
datatype mode = Open | Close
(*Un evenement souris c'est une position et un mode de selection*)
type_synonym evenement = "mode * point"

fun estDansLaFenetre :: "fenetre * point \<Rightarrow> bool"
where
"estDansLaFenetre(((x0,y0),(x1,y1)),(x,y)) = ((x\<ge>x0)\<and>(x\<le>x1)\<and>(y\<le>y0)\<and>(y\<ge>y1))"

fun removeFenetre ::"fenetre * interface \<Rightarrow> interface"
where
"removeFenetre (fenetre , []) = [] " |
"removeFenetre (fenetre ,(f_interface#r_interface)) = (if(fenetre=f_interface)then r_interface
                                          else (f_interface#(removeFenetre (fenetre,r_interface))))"

                                          

                                          
fun update :: "interface \<Rightarrow> evenement \<Rightarrow> interface "
where
"update [] event = []" |
"update (fenetre1#fenetre2#r_gui) (Open,(x,y))  = (if(estDansLaFenetre (fenetre1,(x,y)))
                                                    then
                                                      (fenetre1#fenetre2#r_gui)
                                                    else
                                                      (if(estDansLaFenetre (fenetre2,(x,y)))
                                                      then
                                                        fenetre2#fenetre1#r_gui
                                                      else
                                                        fenetre1#(update (fenetre2#r_gui) (Open,(x,y)))
                                                      )
                                                    )"|
"update ((fenetre)#[]) (Open,(x,y)) = (if(estDansLaFenetre (fenetre,(x,y)))
                                             then [] 
                                             else [])"|
"update ((fenetre)#r_gui) (Close,(x,y)) = (if(estDansLaFenetre (fenetre,(x,y))) 
                                       then r_gui
                                       else fenetre#(update (fenetre#r_gui) (Close,(x,y))))"
definition "f1 = ((0::nat,0),(1,1))"
definition "f2 = ((1,1),(2,2))"
definition "f3 = ((0,1),(1,2))"
definition "f4 = ((1,0),(2,1))"

definition "gui = [f1,f2,f3,f4]"
definition "e1 = (Open, (0,0))"
definition "e2 = (Close , (1,1))"
definition "e3 = (Open, (0,2))"
definition "e4 = (Open, (2,0))"

fun estCapturable :: "interface * evenement \<Rightarrow> bool"
where
"estCapturable ( ([], _) ) = False"|
"estCapturable ( f#r_gui, (_, (x,y))) = ( (estDansLaFenetre (f,(x,y)))\<or> (estCapturable (r_gui,(Open,x,y) ) ))"

lemma lemma1 : "(\<not>(estCapturable (gui,(Close,p))) \<longrightarrow> \<not>(gui = (update gui e)))"
sorry

lemma lemma2 : "((estDansLaFenetre (f,p)) \<longrightarrow> \<not>(List.member (update gui (Close,p)) f))"
sorry

lemma lemma3 : "((estDansLaFenetre (f,p)) \<longrightarrow> \<not>(List.firstElement (update gui (Open,p)) f ))"
sorry

datatype 'a prog = Skip | Aff string 'a | Block "'a prog" "'a prog"

value "Skip"
value "Block Skip Skip"
value "Aff antoine (0::nat) "

datatype bin_unity = Zero | Uno
type_synonym bin =  "bin_unity list" 

fun pow :: "nat \<Rightarrow> nat \<Rightarrow> nat"
where
"pow _ 0 = 1" |
"pow 0 _ = 0" |
"pow n p = (n*(pow n (p-1)))"

fun binAuxToNat :: "bin \<Rightarrow> nat \<Rightarrow> nat"
where
"binAuxToNat [] _ = 0" |
"binAuxToNat (b#reste) n = (if(b=Zero)then (binAuxToNat reste (n+1)) else (pow 2 n) + (binAuxToNat reste (n+1)) )"


fun binToNat ::"bin \<Rightarrow> nat"
where
"binToNat [] = 0" |
"binToNat bin = (binAuxToNat bin 0)" 


fun natToInt::"nat \<Rightarrow> int"
where
"natToInt 0 = 0"|
"natToInt (Suc(e)) = (1 + (natToInt e))"

value " natToInt (binToNat [Zero,Zero,Zero,Uno])"

fun natToBinPaire :: "nat \<Rightarrow> bin"
where 
"natToBinPaire 0 = [Uno]"|
"natToBinPaire (Suc(0)) = [Uno]"|
"natToBinPaire (Suc(Suc(e))) = Zero#(natToBinPaire e)"

fun natToBinImpaire :: "nat * bool \<Rightarrow> bin"
where 
"natToBinImpaire(0,_) = [Uno]"|
"natToBinImpaire ((Suc(0)),_) = [Uno]"|
"natToBinImpaire ((Suc(Suc(e))),b) = (if(b)then(natToBinImpaire e)else(Zero#(natToBinImpaire e)))"


fun pariteNat :: "nat \<Rightarrow> bool"
where
"pariteNat 0 = True" |
"pariteNat (Suc(0)) = False"|
"pariteNat (Suc(Suc(e))) = (pariteNat e)"


fun natToBin :: "nat \<Rightarrow> bin"         
where 
"natToBin 0 = []"|
"natToBin (Suc(0)) = [Uno]"|
"natToBin e =( if(pariteNat e )then (natToBinPaire e)else (Uno#(natToBinImpaire True e))) "

value "natToBin 5"






