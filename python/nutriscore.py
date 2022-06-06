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
import requests
import calcul


cb = input("Code barre : ")
result = requests.get('https://world.openfoodfacts.org/api/v0/product/'+cb+'.json')  # Input

#result = requests.get('https://world.openfoodfacts.org/api/v0/product/737628064502.json')  # Nouilles instantanées, nutriscore connu par l'api
# result = requests.get('https://world.openfoodfacts.org/api/v0/product/3057640265358.json') # Eau, nutriscore connu par l'api
# result = requests.get('https://world.openfoodfacts.org/api/v0/product/3254380004821.json') # Eau Jules, nutriscore inconnu par l'api

result = result.json()
product = result['product']
#nutriscore_data = product['nutriscore_data']
#nutriscore_grade = product['nutriscore_grade']
nutriments = product['nutriments']


#if not 'nutriscore_data' in product:
#    print("Données nutriscore inconnues")
#    exit()


#Si le nutriscore est renvoyé par l'api alors on se contente de renvoyer le nutriscore
if 'nutriscore_grade' in product:
    print("Nutriscore : "+str(product['nutriscore_grade']))
    exit()
else:
    print('Nutriscore inconnu')

#Si le produit n'a pas de categorie, on ne peut pas savoir s'il sagit de nourriture, de boisson ou de matière grasse et on ne peut donc pas calculer le nutriscore
categories = product['categories_hierarchy']
if not categories:
  print("Pas de catégorie renseignée, impossible de caluler le nutriscore")
  exit()


###==========DEBUT BOISSON===========###
if 'en:beverages' in categories:

 #kcal pour 100g
  try:
      pt_kcal = calcul.pt_energie_boisson(nutriments['energy-kcal_100g'])
  except:
    print("Nombre de kcal pour 100g inconnu, impossible de calculer le nutriscore") 

  #Sucres
  try:
      pt_sucres = calcul.pt_sucres_boisson(nutriments['sugars_100g'])
  except:
    print("Sucres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Graisses saturées pt_graisses_sat
  try:
      pt_graisses_sat = calcul.pt_graisses_sat(nutriments['saturated-fat_100g'])
  except:
    print("Graisses saturées 100g inconnues, impossible de calculer le nutriscore") 

  #Sodium pt_sodium
  try:
      pt_sodium = calcul.pt_sodium(nutriments['salt_100g']* 1000) 
  except:
    print("Sels pour 100g inconnu, impossible de calculer le nutriscore") 

  PointsN = pt_sodium + pt_graisses_sat + pt_sucres + pt_kcal

  #Fruits legumes
  try:
      pt_fruits_legumes = calcul.pt_fruits_legumes_boisson(nutriments['fruits-vegetables-nuts-estimate-from-ingredients_100g'])
  except:
    print("Pourcentage de fruits et legumes inconnu, impossible de calculer le nutriscore") 

  #Fibres
  try:
      pt_fibres = calcul.pt_fibres(nutriments['fiber_100g'])
  except:
    print("Fibres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Proteines
  try:
      pt_proteines = calcul.pt_proteines(nutriments['proteins_100g'])
  except:
    print("Proteines pour 100g inconnues, impossible de calculer le nutriscore") 

  PointsP = pt_fruits_legumes + pt_fibres + pt_proteines
  print("Points négatifs : "+str(PointsN))
  print("Points positifs : "+str(PointsP))

  if PointsN >= 11:

    if pt_fruits_legumes == 5:
      score_final = PointsN-PointsP

    elif pt_fruits_legumes < 5:
      score_final = PointsN - (pt_fibres+pt_fruits_legumes)

  elif PointsN < 11:
     score_final = PointsN-PointsP

     print(calcul.lettre_boisson(score_final))

###==========FIN BOISSON===========###


###==========DEBUT MATIERE GRASSE===========###
elif 'en:fats' in categories:

 #kcal pour 100g
  try:
      pt_kcal = calcul.pt_energie(nutriments['energy-kcal_100g'])
  except:
    print("Nombre de kcal pour 100g inconnu, impossible de calculer le nutriscore") 

  #Sucres
  try:
      pt_sucres = calcul.pt_sucres(nutriments['sugars_100g'])
  except:
    print("Sucres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Graisses saturées pt_graisses_sat
  try:
      pt_graisses_sat = calcul.pt_graisses_sat_mat_grasse(nutriments['saturated-fat_100g'])
  except:
    print("Graisses saturées 100g inconnues, impossible de calculer le nutriscore") 

  #Sodium pt_sodium
  try:
      pt_sodium = calcul.pt_sodium(nutriments['salt_100g']* 1000) 
  except:
    print("Sels pour 100g inconnu, impossible de calculer le nutriscore") 

  PointsN = pt_sodium + pt_graisses_sat + pt_sucres + pt_kcal

  #Fruits legumes
  try:
      pt_fruits_legumes = calcul.pt_fruits_legumes(nutriments['fruits-vegetables-nuts-estimate-from-ingredients_100g'])
  except:
    print("Pourcentage de fruits et legumes inconnu, impossible de calculer le nutriscore") 

  #Fibres
  try:
      pt_fibres = calcul.pt_fibres(nutriments['fiber_100g'])
  except:
    print("Fibres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Proteines
  try:
      pt_proteines = calcul.pt_proteines(nutriments['proteins_100g'])
  except:
    print("Proteines pour 100g inconnues, impossible de calculer le nutriscore") 

  PointsP = pt_fruits_legumes + pt_fibres + pt_proteines
  print("Points négatifs : "+str(PointsN))
  print("Points positifs : "+str(PointsP))

  if PointsN >= 11:

    if pt_fruits_legumes == 5:
      score_final = PointsN-PointsP

    elif pt_fruits_legumes < 5:
      score_final = PointsN - (pt_fibres+pt_fruits_legumes)

  elif PointsN < 11:
     score_final = PointsN-PointsP

     print(calcul.lettre(score_final))

###=========FIN MATIERE GRASSE===========###




###=========DEBUT NOURRITURE===========###
else:

  #kcal pour 100g
  try:
      print("Calories pour 100g : "+ str(nutriments['energy-kcal_100g']))
      pt_kcal = calcul.pt_energie(nutriments['energy-kcal_100g'])
      #print ("Points(N) energie : "+str(pt_kcal))
  except:
    print("Nombre de kcal pour 100g inconnu, impossible de calculer le nutriscore") 

  #Sucres
  try:
      print("Sucres pour 100g : "+ str(nutriments['sugars_100g']))
      pt_sucres = calcul.pt_sucres(nutriments['sugars_100g'])
      #print ("Points(N) Sucres : "+str(pt_sucres))
  except:
    print("Sucres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Graisses saturées pt_graisses_sat
  try:
      print("Graisses saturées 100g : "+ str(nutriments['saturated-fat_100g']))
      pt_graisses_sat = calcul.pt_graisses_sat(nutriments['saturated-fat_100g'])
      #print ("Points(N) graisses : "+str(pt_graisses_sat))
  except:
    print("Graisses saturées 100g inconnues, impossible de calculer le nutriscore") 

  #Sodium pt_sodium
  try:
      print("Sels pour 100g : "+ str(nutriments['salt_100g']* 1000)+" mg")
      pt_sodium = calcul.pt_sodium(nutriments['salt_100g']* 1000) 
      #print ("Points(N) Sels : "+str(pt_sodium))
  except:
    print("Sels pour 100g inconnu, impossible de calculer le nutriscore") 


  PointsN = pt_sodium + pt_graisses_sat + pt_sucres + pt_kcal
  print("Points négatifs : "+str(PointsN))

  #Fruits legumes
  try:
      print("Pourcentage de fruits et legumes : "+ str(nutriments['fruits-vegetables-nuts-estimate-from-ingredients_100g']))
      pt_fruits_legumes = calcul.pt_fruits_legumes(nutriments['fruits-vegetables-nuts-estimate-from-ingredients_100g'])
  except:
    print("Pourcentage de fruits et legumes inconnu, impossible de calculer le nutriscore") 

  #Fibres
  try:
      print("Fibres pour 100g : "+ str(nutriments['fiber_100g']))
      pt_fibres = calcul.pt_fibres(nutriments['fiber_100g'])
  except:
    print("Fibres pour 100g inconnue, impossible de calculer le nutriscore") 

  #Proteines
  try:
      print("Proteines pour 100g : "+ str(nutriments['proteins_100g']))
      pt_proteines = calcul.pt_proteines(nutriments['proteins_100g'])
  except:
    print("Proteines pour 100g inconnues, impossible de calculer le nutriscore") 

  PointsP = pt_fruits_legumes + pt_fibres + pt_proteines
  print("Points positifs : "+str(PointsP))

  if PointsN >= 11:

    if pt_fruits_legumes == 5:
      score_final = PointsN-PointsP

    elif pt_fruits_legumes < 5:
      score_final = PointsN - (pt_fibres+pt_fruits_legumes)

  elif PointsN < 11 or 'en:cheeses' in categories:
     score_final = PointsN-PointsP

  print(calcul.lettre(score_final))
###=========FIN NOURRITURE===========###





#TODO : 
# 
# Tester si range inclut les valeurs bornes ou pas
# Non 