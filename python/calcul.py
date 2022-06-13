#___________NEGATIFS___________________
def pt_energie(number):  # Renvoie entre 0 et 10 points en fonction du nombre de kcal pour 100g
    if number in range(0, 335):
        return 0
    elif number in range(336, 669):
        return 1
    elif number in range(670, 1004):
        return 2
    elif number in range(1005, 1339):
        return 3
    elif number in range(1340, 1674):
        return 4
    elif number in range(1675, 2009):
        return 5
    elif number in range(2010, 2344):
        return 6
    elif number in range(2345, 2679):
        return 7
    elif number in range(2680, 3014):
        return 8
    elif number in range(3015, 3349):
        return 9
    elif number >= 3350:
        return 10

def pt_energie_boisson(number):  # Renvoie entre 0 et 10 points en fonction du nombre de kcal pour 100g (Pour les boissons)
    if number == 0:
        return 0
    elif number in range(1, 30):
        return 1
    elif number in range(31, 60):
        return 2
    elif number in range(61, 90):
        return 3
    elif number in range(91, 120):
        return 4
    elif number in range(121, 150):
        return 5
    elif number in range(151, 180):
        return 6
    elif number in range(181, 210):
        return 7
    elif number in range(211, 240):
        return 8
    elif number in range(241, 270):
        return 9
    elif number >= 270:
        return 10

def pt_sucres_boisson(number):  # Renvoie entre 0 et 10 points en fonction du nombre de g de sucres pour 100g (Pour les boissons)
    if number < 4.5:
        return 0
    elif 4.6 < number < 9:
        return 1
    elif 9.1 < number < 13.5:
        return 2
    elif 13.6 < number < 18:
        return 3
    elif 18.1 < number < 22.5:
        return 4
    elif 22.6 < number < 27:
        return 5
    elif 27.1 < number < 31:
        return 6
    elif 31.1 < number < 36:
        return 7
    elif 36.1 < number < 40:
        return 8
    elif 40.1 < number < 44.5:
        return 9
    elif number >= 45:
        return 10

# def pt_sucres(number):  # Renvoie entre 0 et 10 points en fonction du nombre de g de sucres pour 100g
#     if number == 0:
#         return 0
#     elif number in range(0.1, 1.5):
#         return 1
#     elif number in range(1.6, 3):
#         return 2
#     elif number in range(3.1, 4.5):
#         return 3
#     elif number in range(4.6, 6):
#         return 4
#     elif number in range(6.1, 7.5):
#         return 5
#     elif number in range(7.8, 9):
#         return 6
#     elif number in range(9.1, 10.5):
#         return 7
#     elif number in range(10.6, 12):
#         return 8
#     elif number in range(12.1, 13.5):
#         return 9
#     elif number > 13.5:
#         return 10


def pt_sucres(number):  # Renvoie entre 0 et 10 points en fonction du nombre de g de sucres pour 100g
    if number == 0:
        return 0
    elif 0.1 < number < 1.5:
        return 1
    elif 1.6 < number < 3:
        return 2
    elif 3.1 < number < 4.5:
        return 3
    elif 4.6 < number < 6:
        return 4
    elif 6.1 < number < 7.5:
        return 5
    elif 7.8 < number < 9:
        return 6
    elif 9.1 < number < 10.5:
        return 7
    elif 10.6 < number < 12:
        return 8
    elif 12.1 < number < 13.5:
        return 9
    elif number > 13.5:
        return 10



def pt_graisses_sat(number):  # Renvoie entre 0 et 10 points en fonction du nombre de g de graisses saturées pour 100g
    if number < 1:
        return 0
    elif 1.1 < number < 2:
        return 1
    elif 2.1 < number < 3:
        return 2
    elif 3.1 < number < 4:
        return 3
    elif 4.1 < number < 5:
        return 4
    elif 5.1 < number < 6:
        return 5
    elif 6.1 < number < 7:
        return 6
    elif 7.1 < number < 8:
        return 7
    elif 8.1 < number < 9:
        return 8
    elif 9.1 < number < 10:
        return 9
    elif number >= 10.1:
        return 10

def pt_graisses_sat_mat_grasse(number):  # Renvoie entre 0 et 10 points en fonction du nombre de g de graisses saturées pour 100g (Pour les matières grasses)
    if number < 10:
        return 0
    elif 10.1 < number < 16:
        return 1
    elif 16.1 < number < 22:
        return 2
    elif 22.1 < number < 28:
        return 3
    elif 28.1 < number < 34:
        return 4
    elif 34.1 < number < 40:
        return 5
    elif 40.1 < number < 46:
        return 6
    elif 46.1 < number < 52:
        return 7
    elif 52.1 < number < 58:
        return 8
    elif 58.1 < number < 64:
        return 9
    elif number >= 64.1:
        return 10

def pt_sodium(number):  # Renvoie entre 0 et 10 points en fonction du nombre de mg de sodium pour 100g
    if number < 90:
        return 0
    elif 90.1 < number <= 180:
        return 1
    elif 180.1 < number <= 270:
        return 2
    elif 270.1 < number <= 360:
        return 3
    elif 360.1 < number <= 450:
        return 4
    elif 450.1 < number <= 540:
        return 5
    elif 540.1 < number <= 630:
        return 6
    elif 630.1 < number <= 720:
        return 7
    elif 720.1 < number <= 810:
        return 8
    elif 810.1 < number <= 900:
        return 9
    elif number >= 900.1:
        return 10



#___________POSITIFS___________________

def pt_fruits_legumes(number):  # Renvoie entre 0 et 5 points en fonction de la teneur en fruits et légumes en %
    if number < 40:
        return 0
    elif 40.1 < number < 60:
        return 1
    elif 60.1 < number < 80:
        return 2
    elif number >= 80.1:
        return 5

def pt_fruits_legumes_boisson(number):  # Renvoie entre 0 et 10 points en fonction de la teneur en fruits et légumes en % (Pour les boissons)
    if number < 40:
        return 0
    elif 40.1 < number < 60:
        return 2
    elif 60.1 < number < 80:
        return 4
    elif number >= 80.1:
        return 10

def pt_fibres(number):  # Renvoie entre 0 et 5 points en fonction du nombre de g de fibres pour 100g
    if number < 0.7:
        return 0
    elif 0.8 < number < 1.4:
        return 1
    elif 1.5 < number < 2.1:
        return 2
    elif 2.5 < number < 2.8:
        return 3
    elif 2.9 < number < 3.5:
        return 4
    elif number >= 3.6:
        return 5

def pt_proteines(number):  # Renvoie entre 0 et 5 points en fonction du nombre de g de protéines pour 100g
    if number < 1.6:
        return 0
    elif 1.7 < number < 3.2:
        return 1
    elif 3.3 < number < 4.8:
        return 2
    elif 4.9 < number < 6.4:
        return 3
    elif 6.5 < number < 8:
        return 4
    elif number >= 8.1:
        return 5

"""
#___________SCORE_FINAL___________________
if pointsN >= 11:
    if pt_fruits_legumes = 5: # OU pt_fruits_legumes_boisson
        return pointsN - pointsP
    elif pt_fruits_legumes < 5: # OU pt_fruits_legumes_boisson
        return PointsN - (pt_fibres + pt_fruits_legumes)
elif PointsN < 11 | : #OU si le produit est un fromage
    return pointsN - pointsP
"""
#___________LETTRE___________________
def lettre(score_final): #ALIMENT 
    if score_final < 0:
        return "A"
    elif score_final in range(0, 2):
        return "B"
    elif score_final in range(3, 10):
        return "C"
    elif score_final in range(11, 18):
        return "D"
    elif score_final > 19:
        return "E"

def lettre_boisson(score_final): #BOISSON 
# A = seulement pour les eaux
    if score_final < 1:
        return "B"
    elif score_final in range(2, 5):
        return "C"
    elif score_final in range(6, 9):
        return "D"
    elif score_final > 10:
        return "E"
  