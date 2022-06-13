//
//  Calcul.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 11/06/2022.
//

/**
 """
 Calcul du nutriscore des produits alimentaires
 
 Le nutriscore est basé sur les valeurs nutritionnelles de 100g du produit :
 
 Les facteurs nutritionnels suivants sont à limiter :
 l’énergie (kJ/100g)
 les acides gras saturés (g/100g)
 les sucres simples (g/100g)
 le sel (mg/100g)
 
 Les facteurs nutritionnels à favoriser :
 les fibres (g/100g)
 les protéines (g/100g)
 les fruits et légumes, légumineuses et fruits à coque (g/100g)
 
 Ne sont pas concernés par le nutriscore :
 les herbes aromatiques, thés, cafés et levures
 les boisson alcoliséess
 les produits dont la face la plus grande a une surface inférieure a 25cm² ????????????
 
 Les fromages blancs ne sont pas considérés comme des fromages
 Le lait, les yaourts a boire, les boissons lactées aromatisées ou chocolatées, les boissons reconstituées
 avec un liquide autre que de l'eau et les obissons végétales ne sont pas considérées comm des boissons dans le calcul
 du nutriscore
 
 Les boissons sont :
 les eaux minérales de source,
 les eaux aromatisées,
 les jus de fruits,
 les nectars, les smoothies,
 les boissons sucrées et édulorées,
 les thés, les infusions
 et le café
 """
 */


import Foundation


func pt_energie(number:Int) -> Int{
    if(0 < number &&  number < 335){
        return 0
    }
    else if(336 < number &&  number < 669){
        return 1
    }
    else if(670 < number &&  number < 1004){
        return 2
    }
    else if(1005 < number &&  number < 1339){
        return 3
    }
    else if(1340 < number &&  number < 1674){
        return 4
    }
    else if(1675 < number &&  number < 2009){
        return 5
    }
    else if(2010 < number &&  number < 2344){
        return 6
    }
    
    else if(2345 < number &&  number < 2679){
        return 7
    }
    else if(2680 < number &&  number < 3014){
        return 8
    }
    else if(3015 < number &&  number < 3349){
        return 9
    }
    else if( number >= 3350){
        return 10
    }
    return -1
}


//Renvoie entre 0 et 10 points en fonction du nombre de g de sucres pour 100g
func pt_sucres(number:Double) -> Int{
    if (number == 0){
        return 0
    }
    else if( 0.1 < number && number <= 1.5){
        return 1}
    else if( 1.6 < number && number <= 3){
        return 2}
    else if( 3.1 < number && number <= 4.5){
        return 3}
    else if( 4.6 < number && number <= 6){
        return 4}
    else if( 6.1 < number && number <= 7.5){
        return 5}
    else if( 7.8 < number && number <= 9){
        return 6}
    else if( 9.1 < number && number <= 10.5){
        return 7}
    else if( 10.6 < number && number <= 12){
        return 8}
    else if( 12.1 < number && number <= 13.5){
        return 9}
    else if( number > 13.5){
        return 10}
    return -1
}


//# Renvoie entre 0 et 10 points en fonction du nombre de g de graisses saturées pour 100g
func pt_graisses_sat(number:Double) -> Int{
    if (number < 1){
        return 0}
    else if( 1.1 < number && number <= 2){
        return 1}
    else if( 2.1 < number && number <= 3){
        return 2}
    else if( 3.1 < number && number <= 4){
        return 3}
    else if( 4.1 < number && number <= 5){
        return 4}
    else if( 5.1 < number && number <= 6){
        return 5}
    else if( 6.1 < number && number <= 7){
        return 6}
    else if( 7.1 < number && number <= 8){
        return 7}
    else if( 8.1 < number && number <= 9){
        return 8}
    else if( 9.1 < number && number <= 10){
        return 9}
    else if( number >= 10.1){
        return 10}
    return -1
}

//# Renvoie entre 0 et 10 points en fonction du nombre de mg de sodium pour 100g
func pt_sodium(number:Double) -> Int{
    if (number < 90){
        return 0}
    else if( 90.1 < number && number <= 180){
        return 1}
    else if( 180.1 < number && number <= 270){
        return 2}
    else if( 270.1 < number && number <= 360){
        return 3}
    else if( 360.1 < number && number <= 450){
        return 4}
    else if( 450.1 < number && number <= 540){
        return 5}
    else if( 540.1 < number && number <= 630){
        return 6}
    else if( 630.1 < number && number <= 720){
        return 7}
    else if( 720.1 < number && number <= 810){
        return 8}
    else if( 810.1 < number && number <= 900){
        return 9}
    else if( number >= 900.1){
        return 10}
    return -1
}

//Renvoie entre 0 et 5 points en fonction de la teneur en fruits et légumes en %
func pt_fruits_legumes(number:Double) -> Int{
    if (number < 40){
        return 0}
    else if( 40.1 < number && number <= 60){
        return 1}
    else if( 60.1 < number && number <= 80){
        return 2}
    else if( number >= 80.1){
        return 5}
    return -1
}
//# Renvoie entre 0 et 5 points en fonction du nombre de g de fibres pour 100g
func pt_fibres(number:Double) -> Int{
    if (number < 0.7){
        return 0}
    else if( 0.8 < number && number <= 1.4){
        return 1}
    else if( 1.5 < number && number <= 2.1){
        return 2}
    else if( 2.5 < number && number <= 2.8){
        return 3}
    else if( 2.9 < number && number <= 3.5){
        return 4}
    else if( number >= 3.6){
        return 5}
    return -1
}

//# Renvoie entre 0 et 5 points en fonction du nombre de g de protéines pour 100g
func pt_proteines(number:Double) -> Int{
    if (number < 1.6){
        return 0}
    else if( 1.7 < number && number <= 3.2){
        return 1}
    else if( 3.3 < number && number <= 4.8){
        return 2}
    else if( 4.9 < number && number <= 6.4){
        return 3}
    else if( 6.5 < number && number <= 8){
        return 4}
    else if( number >= 8.1){
        return 5
    }
    return -1
}

//
func score(PointsP:Int, PointsN:Int, pt_fruits_legumes:Int,pt_fibres:Int) -> Int{
    if (PointsN >= 11){
        if (pt_fruits_legumes == 5){
            return PointsN-PointsP
        }
        else if (pt_fruits_legumes < 5){
            return PointsN - (pt_fibres+pt_fruits_legumes)
        }}
    else if (PointsN < 11){ //or 'en:cheeses' in categories:
        return PointsN-PointsP
    }
    return -1
}






//___________LETTRE___________________
func lettre(score_final:Int) -> String{
    if (score_final < 0){
        return "a"}
    else if(0 < score_final && score_final < 2){
        return "b"}
    else if(3 < score_final && score_final < 10){
        return "c"}
    else if(11 < score_final && score_final < 18){
        return "d"}
    else if( score_final > 19){
        return "e"
    }
    return"Erreur"
}

// func lettre_boisson(score_final){#BOISSON
// # A = seulement pour les eaux
//     if score_final < 1){
//         return "B"}
//     else if( score_final in range(2, 5)){
//         return "C"}
//     else if( score_final in range(6, 9)){
//         return "D"}
//     else if( score_final > 10){
//         return "E"
//
